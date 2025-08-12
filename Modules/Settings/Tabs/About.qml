import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.Services
import qs.Widgets

ColumnLayout {
  id: root

  property string latestVersion: GitHub.latestVersion
  property string currentVersion: "v1.2.1" // Fallback version
  property var contributors: GitHub.contributors

  spacing: 0
  Layout.fillWidth: true
  Layout.fillHeight: true

  Process {
    id: currentVersionProcess

    command: ["sh", "-c", "cd " + Quickshell.shellDir + " && git describe --tags --abbrev=0 2>/dev/null || echo 'Unknown'"]
    Component.onCompleted: {
      running = true
    }

    stdout: StdioCollector {
      onStreamFinished: {
        const version = text.trim()
        if (version && version !== "Unknown") {
          root.currentVersion = version
        } else {
          currentVersionProcess.command = ["sh", "-c", "cd " + Quickshell.shellDir
                                           + " && cat package.json 2>/dev/null | grep '\"version\"' | cut -d'\"' -f4 || echo 'Unknown'"]
          currentVersionProcess.running = true
        }
      }
    }
  }

  ScrollView {
    id: scrollView

    Layout.fillWidth: true
    Layout.fillHeight: true
    padding: 16
    rightPadding: 12
    clip: true
    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
    ScrollBar.vertical.policy: ScrollBar.AsNeeded

    ColumnLayout {
      width: scrollView.availableWidth
      spacing: 0

      NText {
        text: "Noctalia: quiet by design"
        font.pointSize: 24 * Scaling.scale(screen)
        font.weight: Style.fontWeightBold
        color: Colors.textPrimary
        Layout.alignment: Qt.AlignCenter
        Layout.bottomMargin: 8 * Scaling.scale(screen)
      }

      NText {
        text: "It may just be another quickshell setup but it won't get in your way."
        font.pointSize: 14 * Scaling.scale(screen)
        color: Colors.textSecondary
        Layout.alignment: Qt.AlignCenter
        Layout.bottomMargin: 16 * Scaling.scale(screen)
      }

      GridLayout {
        Layout.alignment: Qt.AlignCenter
        columns: 2
        rowSpacing: 4
        columnSpacing: 8

        NText {
          text: "Latest Version:"
          font.pointSize: 16 * Scaling.scale(screen)
          color: Colors.textSecondary
          Layout.alignment: Qt.AlignRight
        }

        NText {
          text: root.latestVersion
          font.pointSize: 16 * Scaling.scale(screen)
          color: Colors.textPrimary
          font.weight: Style.fontWeightBold
        }

        NText {
          text: "Installed Version:"
          font.pointSize: 16 * Scaling.scale(screen)
          color: Colors.textSecondary
          Layout.alignment: Qt.AlignRight
        }

        NText {
          text: root.currentVersion
          font.pointSize: 16 * Scaling.scale(screen)
          color: Colors.textPrimary
          font.weight: Style.fontWeightBold
        }
      }

      Rectangle {
        Layout.alignment: Qt.AlignCenter
        Layout.topMargin: 8
        Layout.preferredWidth: updateText.implicitWidth + 46
        Layout.preferredHeight: 32
        radius: 20
        color: updateArea.containsMouse ? Colors.accentPrimary : "transparent"
        border.color: Colors.accentPrimary
        border.width: 1
        visible: {
          if (root.currentVersion === "Unknown" || root.latestVersion === "Unknown")
            return false

          const latest = root.latestVersion.replace("v", "").split(".")
          const current = root.currentVersion.replace("v", "").split(".")
          for (var i = 0; i < Math.max(latest.length, current.length); i++) {
            const l = parseInt(latest[i] || "0")
            const c = parseInt(current[i] || "0")
            if (l > c)
              return true

            if (l < c)
              return false
          }
          return false
        }

        RowLayout {
          anchors.centerIn: parent
          spacing: 8

          NText {
            text: "system_update"
            font.family: "Material Symbols Outlined"
            font.pointSize: 18 * Scaling.scale(screen)
            color: updateArea.containsMouse ? Colors.backgroundPrimary : Colors.accentPrimary
          }

          NText {
            id: updateText

            text: "Download latest release"
            font.pointSize: 14 * Scaling.scale(screen)
            color: updateArea.containsMouse ? Colors.backgroundPrimary : Colors.accentPrimary
          }
        }

        MouseArea {
          id: updateArea

          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            Quickshell.execDetached(["xdg-open", "https://github.com/Ly-sec/Noctalia/releases/latest"])
          }
        }
      }

      // Separator
      Rectangle {
        Layout.fillWidth: true
        Layout.topMargin: 26
        Layout.bottomMargin: 18
        height: 1
        color: Colors.outline
        opacity: 0.3
      }

      NText {
        text: "Contributors"
        font.pointSize: 18 * Scaling.scale(screen)
        font.weight: Style.fontWeightBold
        color: Colors.textPrimary
        Layout.alignment: Qt.AlignCenter
        Layout.topMargin: 32
      }

      NText {
        text: "(" + root.contributors.length + ")"
        font.pointSize: 14 * Scaling.scale(screen)
        color: Colors.textSecondary
        Layout.alignment: Qt.AlignCenter
        Layout.topMargin: 4
      }

      ScrollView {
        Layout.alignment: Qt.AlignCenter
        Layout.preferredWidth: 200 * 4
        Layout.fillHeight: true
        Layout.topMargin: 16
        clip: true
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AsNeeded

        GridView {
          id: contributorsGrid

          anchors.fill: parent
          width: 200 * 4
          height: Math.ceil(root.contributors.length / 4) * 100
          cellWidth: 200
          cellHeight: 100
          model: root.contributors

          delegate: Rectangle {
            width: contributorsGrid.cellWidth - 16
            height: contributorsGrid.cellHeight - 4
            radius: 20
            color: contributorArea.containsMouse ? Colors.hover : "transparent"

            RowLayout {
              anchors.fill: parent
              anchors.margins: 8
              spacing: 12

              Item {
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 40
                Layout.preferredHeight: 40

                Image {
                  id: avatarImage

                  anchors.fill: parent
                  source: modelData.avatar_url || ""
                  sourceSize: Qt.size(80, 80)
                  visible: false
                  mipmap: true
                  smooth: true
                  asynchronous: true
                  fillMode: Image.PreserveAspectCrop
                  cache: true

                  onStatusChanged: {
                    if (status === Image.Error) {
                      console.log("[About] Failed to load avatar for", modelData.login, "URL:", modelData.avatar_url)
                    }
                  }
                }

                MultiEffect {
                  anchors.fill: parent
                  source: avatarImage
                  maskEnabled: true
                  maskSource: mask
                }

                Item {
                  id: mask

                  anchors.fill: parent
                  layer.enabled: true
                  visible: false

                  Rectangle {
                    anchors.fill: parent
                    radius: parent.width / 2
                  }
                }

                NText {
                  anchors.centerIn: parent
                  text: "person"
                  font.family: "Material Symbols Outlined"
                  font.pointSize: 24 * Scaling.scale(screen)
                  color: contributorArea.containsMouse ? Colors.backgroundPrimary : Colors.textPrimary
                  visible: !avatarImage.source || avatarImage.status !== Image.Ready
                }
              }

              ColumnLayout {
                spacing: 4
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true

                NText {
                  text: modelData.login || "Unknown"
                  font.pointSize: 13 * Scaling.scale(screen)
                  color: contributorArea.containsMouse ? Colors.backgroundPrimary : Colors.textPrimary
                  elide: Text.ElideRight
                  Layout.fillWidth: true
                }

                NText {
                  text: (modelData.contributions || 0) + " commits"
                  font.pointSize: 11 * Scaling.scale(screen)
                  color: contributorArea.containsMouse ? Colors.backgroundPrimary : Colors.textSecondary
                }
              }
            }

            MouseArea {
              id: contributorArea

              anchors.fill: parent
              hoverEnabled: true
              cursorShape: Qt.PointingHandCursor
              onClicked: {
                if (modelData.html_url)
                  Quickshell.execDetached(["xdg-open", modelData.html_url])
              }
            }
          }
        }
      }
    }
  }
}

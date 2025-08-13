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
  property string currentVersion: "v2.0.0" // Fallback version
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
    padding: Style.marginLarge * scaling
    rightPadding: Style.marginMedium * scaling
    clip: true
    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
    ScrollBar.vertical.policy: ScrollBar.AsNeeded

    ColumnLayout {
      width: scrollView.availableWidth
      spacing: 0

      NText {
        text: "Noctalia: quiet by design"
        font.pointSize: Style.fontSizeXXL * scaling
        font.weight: Style.fontWeightBold
        color: Colors.textPrimary
        Layout.alignment: Qt.AlignCenter
        Layout.bottomMargin: Style.marginSmall * scaling
      }

      NText {
        text: "It may just be another quickshell setup but it won't get in your way."
        font.pointSize: Style.fontSizeMedium * scaling
        color: Colors.textSecondary
        Layout.alignment: Qt.AlignCenter
        Layout.bottomMargin: Style.marginLarge * scaling
      }

      GridLayout {
        Layout.alignment: Qt.AlignCenter
        columns: 2
        rowSpacing: Style.marginTiny * scaling
        columnSpacing: Style.marginSmall * scaling

        NText {
          text: "Latest Version:"
          color: Colors.textSecondary
          Layout.alignment: Qt.AlignRight
        }

        NText {
          text: root.latestVersion
          color: Colors.textPrimary
          font.weight: Style.fontWeightBold
        }

        NText {
          text: "Installed Version:"
          color: Colors.textSecondary
          Layout.alignment: Qt.AlignRight
        }

        NText {
          text: root.currentVersion
          color: Colors.textPrimary
          font.weight: Style.fontWeightBold
        }
      }

      Rectangle {
        Layout.alignment: Qt.AlignCenter
        Layout.topMargin: Style.marginSmall * scaling
        Layout.preferredWidth: updateText.implicitWidth + 46 * scaling
        Layout.preferredHeight: 32 * scaling
        radius: Style.radiusLarge * scaling
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
            font.pointSize: 18 * scaling
            color: updateArea.containsMouse ? Colors.backgroundPrimary : Colors.accentPrimary
          }

          NText {
            id: updateText
            text: "Download latest release"
            font.pointSize: 14 * scaling
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

      NDivider {
        Layout.fillWidth: true
        Layout.topMargin: Style.marginLarge * 2 * scaling
        Layout.bottomMargin: Style.marginLarge * scaling
      }

      NText {
        text: `Contributors: ${root.contributors.length}`
        font.pointSize: Style.fontSizeLarge * scaling
        font.weight: Style.fontWeightBold
        color: Colors.textPrimary
        Layout.alignment: Qt.AlignCenter
        Layout.topMargin: Style.marginLarge * 2
      }

      ScrollView {
        Layout.alignment: Qt.AlignCenter
        Layout.preferredWidth: 200 * Style.marginTiny * scaling
        Layout.fillHeight: true
        Layout.topMargin: Style.marginLarge * scaling
        clip: true
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AsNeeded

        GridView {
          id: contributorsGrid

          anchors.fill: parent
          width: 200 * 4 * scaling
          height: Math.ceil(root.contributors.length / 4) * 100
          cellWidth: 200 * scaling
          cellHeight: 100 * scaling
          model: root.contributors

          delegate: Rectangle {
            width: contributorsGrid.cellWidth - Style.marginLarge * scaling
            height: contributorsGrid.cellHeight - Style.marginTiny * scaling
            radius: Style.radiusLarge * scaling
            color: contributorArea.containsMouse ? Colors.hover : "transparent"

            RowLayout {
              anchors.fill: parent
              anchors.margins: Style.marginSmall * scaling
              spacing: Style.marginMedium * scaling

              Item {
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 64 * scaling
                Layout.preferredHeight: 64 * scaling

                NImageRounded {
                  imagePath: modelData.avatar_url || ""
                  anchors.fill: parent
                  anchors.margins: Style.marginTiny * scaling
                  fallbackIcon: "person"
                  borderColor: Colors.accentPrimary
                  borderWidth: Math.max(1, Style.borderMedium * scaling)
                  imageRadius: width * 0.5
                }
              }

              ColumnLayout {
                spacing: Style.marginTiny * scaling
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true

                NText {
                  text: modelData.login || "Unknown"
                  font.weight: Style.fontWeightBold
                  color: contributorArea.containsMouse ? Colors.backgroundPrimary : Colors.textPrimary
                  elide: Text.ElideRight
                  Layout.fillWidth: true
                }

                NText {
                  text: (modelData.contributions || 0) + " commits"
                  font.pointSize: Style.fontSizeSmall * scaling
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

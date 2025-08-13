import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.Services
import qs.Widgets

// Header card with avatar, user and quick actions
NBox {
  id: root

  readonly property real scaling: Scaling.scale(screen)
  property string uptimeText: "--"

  Layout.fillWidth: true
  // Height driven by content
  implicitHeight: content.implicitHeight + Style.marginMedium * 2 * scaling

  RowLayout {
    id: content
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.margins: Style.marginMedium * scaling
    spacing: Style.marginMedium * scaling

    NImageRounded {
      width: Style.baseWidgetSize * 1.25 * scaling
      height: Style.baseWidgetSize * 1.25 * scaling
      imagePath: Settings.data.general.avatarImage
      fallbackIcon: "person"
      borderColor: Colors.accentPrimary
      borderWidth: Math.max(1, Style.borderMedium * scaling)
    }

    ColumnLayout {
      Layout.fillWidth: true
      spacing: 2 * scaling
      NText {
        text: Quickshell.env("USER") || "user"
        font.weight: Style.fontWeightBold
      }
      NText {
        text: `System Uptime: ${uptimeText}`
        color: Colors.textSecondary
      }
    }

    RowLayout {
      spacing: Style.marginSmall * scaling
      Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
      Item {
        Layout.fillWidth: true
      }
      NIconButton {
        icon: "settings"
        tooltipText: "Open settings"
        onClicked: {
          settingsPanel.requestedTab = settingsPanel.tabsIds.GENERAL
          settingsPanel.isLoaded = !settingsPanel.isLoaded
        }
      }
      NIconButton {
        id: powerButton
        icon: "power_settings_new"
        onClicked: {
          //settingsPanel.isLoaded = !settingsPanel.isLoaded
          powerMenu.show()
        }
      }
    }
  }

  // ----------------------------------
  // Uptime
  Timer {
    interval: 60000
    repeat: true
    running: true
    onTriggered: uptimeProcess.running = true
  }

  Process {
    id: uptimeProcess
    command: ["cat", "/proc/uptime"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        var uptimeSeconds = parseFloat(this.text.trim().split(' ')[0])
        var minutes = Math.floor(uptimeSeconds / 60) % 60
        var hours = Math.floor(uptimeSeconds / 3600) % 24
        var days = Math.floor(uptimeSeconds / 86400)

        // Format the output
        if (days > 0) {
          uptimeText = days + "d " + hours + "h"
        } else if (hours > 0) {
          uptimeText = hours + "h" + minutes + "m"
        } else {
          uptimeText = minutes + "m"
        }

        uptimeProcess.running = false
      }
    }
  }

  // ----------------------------------
  // Logout menu
  function logout() {
    if (WorkspaceManager.isNiri) {
      logoutProcessNiri.running = true
    } else if (WorkspaceManager.isHyprland) {
      logoutProcessHyprland.running = true
    } else {
      console.warn("No supported compositor detected for logout")
    }
  }

  function suspend() {
    suspendProcess.running = true
  }

  function shutdown() {
    shutdownProcess.running = true
  }

  function reboot() {
    rebootProcess.running = true
  }

  function updateSystemInfo() {
    uptimeProcess.running = true
  }

  Process {
    id: shutdownProcess

    command: ["shutdown", "-h", "now"]
    running: false
  }

  Process {
    id: rebootProcess

    command: ["reboot"]
    running: false
  }

  Process {
    id: suspendProcess

    command: ["systemctl", "suspend"]
    running: false
  }

  Process {
    id: logoutProcessNiri

    command: ["niri", "msg", "action", "quit", "--skip-confirmation"]
    running: false
  }

  Process {
    id: logoutProcessHyprland

    command: ["hyprctl", "dispatch", "exit"]
    running: false
  }

  Process {
    id: logoutProcess

    command: ["loginctl", "terminate-user", Quickshell.env("USER")]
    running: false
  }

  NPanel {
    id: powerMenu

    anchors.top: powerButton.bottom
    anchors.right: powerButton.right

    Rectangle {
      width: 160 * scaling
      height: 220 * scaling
      color: Colors.surface
      radius: 8 * scaling
      border.color: Colors.outline
      border.width: 1 * scaling
      visible: true
      z: 9999
      anchors.top: parent.top
      anchors.right: parent.right
      anchors.rightMargin: 32 * scaling
      anchors.topMargin: powerButton.y + powerButton.height + 48 * scaling

      // Prevent closing when clicking in the panel bg
      MouseArea {
        anchors.fill: parent
      }

      ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8 * scaling
        spacing: 4 * scaling

        Rectangle {
          Layout.fillWidth: true
          Layout.preferredHeight: 36 * scaling
          radius: 6 * scaling
          color: lockButtonArea.containsMouse ? Colors.accentPrimary : "transparent"

          Item {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 12 * scaling
            anchors.rightMargin: 12 * scaling

            Row {
              id: lockRow
              spacing: 8 * scaling
              anchors.left: parent.left
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter

              Text {
                text: "lock_outline"
                font.family: "Material Symbols Outlined"
                font.pixelSize: 16 * scaling
                color: lockButtonArea.containsMouse ? Colors.onAccent : Colors.textPrimary
                verticalAlignment: Text.AlignVCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 1 * scaling
              }

              Text {
                text: "Lock Screen"
                font.pixelSize: 14 * scaling
                color: lockButtonArea.containsMouse ? Colors.onAccent : Colors.textPrimary
                verticalAlignment: Text.AlignVCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 1 * scaling
              }
            }
          }

          MouseArea {
            id: lockButtonArea

            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
              lockScreen.locked = true
              systemMenu.visible = false
            }
          }
        }

        Rectangle {
          Layout.fillWidth: true
          Layout.preferredHeight: 36 * scaling
          radius: 6 * scaling
          color: suspendButtonArea.containsMouse ? Colors.accentPrimary : "transparent"

          Item {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 12 * scaling
            anchors.rightMargin: 12 * scaling

            Row {
              id: suspendRow
              spacing: 8 * scaling
              anchors.left: parent.left
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter

              Text {
                text: "bedtime"
                font.family: "Material Symbols Outlined"
                font.pixelSize: 16 * scaling
                color: suspendButtonArea.containsMouse ? Colors.onAccent : Colors.textPrimary
                verticalAlignment: Text.AlignVCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 1 * scaling
              }

              Text {
                text: "Suspend"
                font.pixelSize: 14 * scaling
                color: suspendButtonArea.containsMouse ? Colors.onAccent : Colors.textPrimary
                verticalAlignment: Text.AlignVCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 1 * scaling
              }
            }
          }

          MouseArea {
            id: suspendButtonArea

            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
              suspend()
              systemMenu.visible = false
            }
          }
        }

        Rectangle {
          Layout.fillWidth: true
          Layout.preferredHeight: 36 * scaling
          radius: 6 * scaling
          color: rebootButtonArea.containsMouse ? Colors.accentPrimary : "transparent"

          Item {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 12 * scaling
            anchors.rightMargin: 12 * scaling

            Row {
              id: rebootRow
              spacing: 8 * scaling
              anchors.left: parent.left
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter

              Text {
                text: "refresh"
                font.family: "Material Symbols Outlined"
                font.pixelSize: 16 * scaling
                color: rebootButtonArea.containsMouse ? Colors.onAccent : Colors.textPrimary
                verticalAlignment: Text.AlignVCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 1 * scaling
              }

              Text {
                text: "Reboot"
                font.pixelSize: 14 * scaling
                color: rebootButtonArea.containsMouse ? Colors.onAccent : Colors.textPrimary
                verticalAlignment: Text.AlignVCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 1 * scaling
              }
            }
          }

          MouseArea {
            id: rebootButtonArea

            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
              reboot()
              systemMenu.visible = false
            }
          }
        }

        Rectangle {
          Layout.fillWidth: true
          Layout.preferredHeight: 36 * scaling
          radius: 6 * scaling
          color: logoutButtonArea.containsMouse ? Colors.accentPrimary : "transparent"

          Item {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 12 * scaling
            anchors.rightMargin: 12 * scaling

            Row {
              id: logoutRow
              spacing: 8 * scaling
              anchors.left: parent.left
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter

              Text {
                text: "exit_to_app"
                font.family: "Material Symbols Outlined"
                font.pixelSize: 16 * scaling
                color: logoutButtonArea.containsMouse ? Colors.onAccent : Colors.textPrimary
                verticalAlignment: Text.AlignVCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 1 * scaling
              }

              Text {
                text: "Logout"
                font.pixelSize: 14 * scaling
                color: logoutButtonArea.containsMouse ? Colors.onAccent : Colors.textPrimary
                verticalAlignment: Text.AlignVCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 1 * scaling
              }
            }
          }

          MouseArea {
            id: logoutButtonArea

            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
              logout()
              systemMenu.visible = false
            }
          }
        }

        Rectangle {
          Layout.fillWidth: true
          Layout.preferredHeight: 36 * scaling
          radius: 6 * scaling
          color: shutdownButtonArea.containsMouse ? Colors.accentPrimary : "transparent"

          Item {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 12 * scaling
            anchors.rightMargin: 12 * scaling

            Row {
              id: shutdownRow
              spacing: 8 * scaling
              anchors.left: parent.left
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter

              Text {
                text: "power_settings_new"
                font.family: "Material Symbols Outlined"
                font.pixelSize: 16 * scaling
                color: shutdownButtonArea.containsMouse ? Colors.onAccent : Colors.textPrimary
                verticalAlignment: Text.AlignVCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 1 * scaling
              }

              Text {
                text: "Shutdown"
                font.pixelSize: 14 * scaling
                color: shutdownButtonArea.containsMouse ? Colors.onAccent : Colors.textPrimary
                verticalAlignment: Text.AlignVCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 1 * scaling
              }
            }
          }

          MouseArea {
            id: shutdownButtonArea

            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
              shutdown()
              systemMenu.visible = false
            }
          }
        }
      }
    }
  }
}

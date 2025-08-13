import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.Services
import qs.Widgets

NPanel {
  id: powerMenu
  visible: false

  // Anchors will be set by the parent component

  function show() {
    visible = true
  }

  function hide() {
    visible = false
  }

  // Close menu when clicking outside
  Connections {
    target: Quickshell
    function onMousePressed() {
      if (powerMenu.visible && !powerMenu.contains(Quickshell.mousePosition)) {
        powerMenu.hide()
      }
    }
  }

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
    anchors.topMargin: 86 * scaling

    // Prevent closing when clicking in the panel bg
    MouseArea {
      anchors.fill: parent
      onClicked: {

        // Prevent event bubbling
      }
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
            // TODO: Implement lock screen functionality
            console.log("Lock screen requested")
            powerMenu.visible = false
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
            powerMenu.visible = false
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
            powerMenu.visible = false
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
            powerMenu.visible = false
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
            powerMenu.visible = false
          }
        }
      }
    }
  }

  // ----------------------------------
  // System functions
  function logout() {
    if (Workspaces.isNiri) {
      logoutProcessNiri.running = true
    } else if (Workspaces.isHyprland) {
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
} 
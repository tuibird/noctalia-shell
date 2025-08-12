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
  // Hold a single instance of the Settings window (root is NLoader)
  property var settingsWindow: null

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
        onClicked: {
          if (!root.settingsWindow) {
            const comp = Qt.createComponent("../../Settings/SettingsWindow.qml")
            if (comp.status === Component.Ready) {
              root.settingsWindow = comp.createObject(root)
            } else {
              comp.statusChanged.connect(function () {
                if (comp.status === Component.Ready) {
                  root.settingsWindow = comp.createObject(root)
                }
              })
            }
          }
          if (root.settingsWindow) {
            root.settingsWindow.isLoaded = !root.settingsWindow.isLoaded
          }
        }
      }
      NIconButton {
        icon: "power_settings_new"
      }
    }
  }

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
}

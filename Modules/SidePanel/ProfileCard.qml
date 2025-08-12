import QtQuick
import QtQuick.Layouts
import Quickshell
import QtQuick.Effects
import qs.Services
import qs.Widgets

// Header card with avatar, user and quick actions
NBox {
  id: root

  readonly property real scaling: Scaling.scale(screen)
  // Hold a single instance of the Settings window (root is NLoader)
  property var settingsWindow: null

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
        text: "System Uptime: —"
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
        sizeMultiplier: 0.9
        onClicked: function () {
          if (!root.settingsWindow) {
            const comp = Qt.createComponent("../Settings/SettingsWindow.qml")
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
        sizeMultiplier: 0.9
      }
    }
  }
}

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth
import qs.Services
import qs.Widgets

ColumnLayout {
  id: root

  spacing: 0

  ScrollView {
    id: scrollView

    Layout.fillWidth: true
    Layout.fillHeight: true
    padding: Style.marginMedium * scaling
    clip: true
    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
    ScrollBar.vertical.policy: ScrollBar.AsNeeded

    ColumnLayout {
      width: scrollView.availableWidth
      spacing: 0

      Item {
        Layout.fillWidth: true
        Layout.preferredHeight: 0
      }

      ColumnLayout {
        spacing: Style.marginLarge * scaling
        Layout.fillWidth: true

        NText {
          text: "Network Settings"
          font.pointSize: Style.fontSizeXL * scaling
          font.weight: Style.fontWeightBold
          color: Colors.textPrimary
        }

        NToggle {
          label: "WiFi Enabled"
          description: "Enable WiFi connectivity"
          value: Settings.data.network.wifiEnabled
          onToggled: function (newValue) {
            Settings.data.network.wifiEnabled = newValue
          }
        }

        NToggle {
          label: "Bluetooth Enabled"
          description: "Enable Bluetooth connectivity"
          value: Settings.data.network.bluetoothEnabled
          onToggled: function (newValue) {
            Settings.data.network.bluetoothEnabled = newValue
          }
        }
      }
    }
  }
}

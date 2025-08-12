import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth
import qs.Services
import qs.Widgets

Item {
  property real scaling: 1
  readonly property string tabIcon: "wifi"
  readonly property string tabLabel: "Network"
  readonly property int tabIndex: 4
  anchors.fill: parent

  ColumnLayout {
    anchors.fill: parent
    spacing: Style.marginMedium * scaling

    NText {
      text: "Wi‑Fi"
      font.weight: Style.fontWeightBold
      color: Colors.accentSecondary
    }

    NToggle {
      label: "Enable Wi‑Fi"
      description: "Turn Wi‑Fi radio on or off"
      value: Settings.data.network.wifiEnabled
      onToggled: function (newValue) {
        Settings.data.network.wifiEnabled = newValue
        Quickshell.execDetached(["nmcli", "radio", "wifi", newValue ? "on" : "off"])
      }
    }

    NDivider {
      Layout.fillWidth: true
    }

    NText {
      text: "Bluetooth"
      font.weight: Style.fontWeightBold
      color: Colors.accentSecondary
    }

    NToggle {
      label: "Enable Bluetooth"
      description: "Turn Bluetooth radio on or off"
      value: Settings.data.network.bluetoothEnabled
      onToggled: function (newValue) {
        Settings.data.network.bluetoothEnabled = newValue
        if (Bluetooth.defaultAdapter) {
          Bluetooth.defaultAdapter.enabled = newValue
          if (Bluetooth.defaultAdapter.enabled)
            Bluetooth.defaultAdapter.discovering = true
        }
      }
    }

    Item {
      Layout.fillHeight: true
    }
  }
}

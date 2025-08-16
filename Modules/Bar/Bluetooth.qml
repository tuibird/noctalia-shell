import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import qs.Commons
import qs.Services
import qs.Widgets

NIconButton {
  id: root

  readonly property bool bluetoothEnabled: Settings.data.network.bluetoothEnabled
  sizeMultiplier: 0.8
  showBorder: false
  visible: bluetoothEnabled

  Component.onCompleted: {
    Logger.log("Bluetooth", "Component loaded, bluetoothEnabled:", bluetoothEnabled)
    Logger.log("Bluetooth", "BluetoothService available:", typeof BluetoothService !== 'undefined')
    if (typeof BluetoothService !== 'undefined') {
      Logger.log("Bluetooth", "Connected devices:", BluetoothService.connectedDevices.length)
    }
  }
  icon: {
    // Show different icons based on connection status
    if (BluetoothService.connectedDevices.length > 0) {
      return "bluetooth_connected"
    } else if (BluetoothService.isDiscovering) {
      return "bluetooth_searching"
    } else {
      return "bluetooth"
    }
  }
  tooltipText: "Bluetooth Devices"
  onClicked: {
    if (!bluetoothMenuLoader.active) {
      bluetoothMenuLoader.isLoaded = true
    }
    if (bluetoothMenuLoader.item) {
      if (bluetoothMenuLoader.item.visible) {
        // Panel is visible, hide it with animation
        if (bluetoothMenuLoader.item.hide) {
          bluetoothMenuLoader.item.hide()
        } else {
          bluetoothMenuLoader.item.visible = false
        }
      } else {
        // Panel is hidden, show it
        bluetoothMenuLoader.item.visible = true
      }
    }
  }

  BluetoothMenu {
    id: bluetoothMenuLoader
  }
}

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import qs.Services
import qs.Widgets

NIconButton {
  id: root

  readonly property real scaling: Scaling.scale(screen)
  readonly property bool wifiEnabled: Settings.data.network.wifiEnabled
  sizeMultiplier: 0.8
  showBorder: false
  icon: {
    let connected = false
    for (const net in network.networks) {
      if (network.networks[net].connected) {
        connected = true
        break
      }
    }
    return connected ? network.signalIcon(parent.currentSignal) : "wifi_off"
  }
  tooltipText: "WiFi Networks"
  onClicked: {
    if (!wifiMenuLoader.active) {
      wifiMenuLoader.isLoaded = true
    }
    if (wifiMenuLoader.item) {
      wifiMenuLoader.item.visible = !wifiMenuLoader.item.visible
      if (wifiMenuLoader.item.visible) {
        network.onMenuOpened()
      } else {
        network.onMenuClosed()
      }
    }
  }

  Network {
    id: network
  }

  WiFiMenu {
    id: wifiMenuLoader
  }
}

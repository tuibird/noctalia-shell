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
  sizeMultiplier: 0.8
  showBorder: false
  icon: "notifications"
  tooltipText: "Notification History"
  onClicked: {
    if (!notificationHistoryPanel.active) {
      notificationHistoryPanel.isLoaded = true
    }
    if (notificationHistoryPanel.item) {
      if (notificationHistoryPanel.item.visible) {
        // Panel is visible, hide it with animation
        if (notificationHistoryPanel.item.hide) {
          notificationHistoryPanel.item.hide()
        } else {
          notificationHistoryPanel.item.visible = false
        }
      } else {
        // Panel is hidden, show it
        notificationHistoryPanel.item.visible = true
      }
    }
  }
}

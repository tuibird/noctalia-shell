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
    if (!notificationHistoryPanelLoader.active) {
      notificationHistoryPanelLoader.isLoaded = true
    }
    if (notificationHistoryPanelLoader.item) {
      if (notificationHistoryPanelLoader.item.visible) {
        // Panel is visible, hide it with animation
        if (notificationHistoryPanelLoader.item.hide) {
          notificationHistoryPanelLoader.item.hide()
        } else {
          notificationHistoryPanelLoader.item.visible = false
        }
      } else {
        // Panel is hidden, show it
        notificationHistoryPanelLoader.item.visible = true
      }
    }
  }

  NotificationHistoryPanel {
    id: notificationHistoryPanelLoader
  }
}

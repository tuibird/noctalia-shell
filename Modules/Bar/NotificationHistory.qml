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
      notificationHistoryPanelLoader.item.visible = !notificationHistoryPanelLoader.item.visible
    }
  }

  NotificationHistoryPanel {
    id: notificationHistoryPanelLoader
  }
} 
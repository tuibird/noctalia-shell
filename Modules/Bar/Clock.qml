import QtQuick
import qs.Services
import qs.Widgets

// Clock Icon with attached calendar
NClock {
  id: root

  NTooltip {
    id: tooltip
    text: Time.dateString
    target: root
  }

  onEntered: {
    if (!calendar.isLoaded) {
      tooltip.show()
    }
  }
  onExited: {
    tooltip.hide()
  }
  onClicked: {
    tooltip.hide()
    calendar.isLoaded = !calendar.isLoaded
  }
}

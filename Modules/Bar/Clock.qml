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

  onEntered: function () {
    if (!calendar.isLoaded) {
      tooltip.show()
    }
  }
  onExited: function () {
    tooltip.hide()
  }
  onClicked: function () {
    tooltip.hide()
    calendar.isLoaded = !calendar.isLoaded
    
  }
}

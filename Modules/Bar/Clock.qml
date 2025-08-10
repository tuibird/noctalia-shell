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

  NCalendar {
    id: calendar
    visible: false
  }

  onEntered: function () {
    if (!calendar.visible) {
      tooltip.show()
    }
  }
  onExited: function () {
    tooltip.hide()
  }
  onClicked: function () {
    calendar.visible = !calendar.visible
    tooltip.hide()
  }
}

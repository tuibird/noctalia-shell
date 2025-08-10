import QtQuick
import qs.Services
import qs.Widgets

Rectangle {
  id: root

  readonly property real scaling: Scaling.scale(screen)

  width: textItem.paintedWidth
  height: textItem.paintedHeight
  color: "transparent"

  NText {
    id: textItem
    text: Time.time
    anchors.centerIn: parent
  }

  MouseArea {
    id: clockMouseArea
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    hoverEnabled: true
    onEntered: {
      if (!calendar.visible) {
        tooltip.show()
      }
    }
    onExited: {
      tooltip.hide()
    }
    onClicked: function () {
      calendar.visible = !calendar.visible
      tooltip.hide()
    }
  }

  NCalendar {
    id: calendar
    visible: false
  }

  NTooltip {
    id: tooltip
    text: Time.dateString
    target: root
  }
}

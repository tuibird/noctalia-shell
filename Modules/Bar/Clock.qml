import QtQuick
import qs.Services
import qs.Widgets

Rectangle {
  id: root

  readonly property real scaling: Scaling.scale(screen)

  width: textItem.paintedWidth
  height: textItem.paintedHeight
  color: "transparent"

  Text {
    id: textItem
    text: Time.time
    font.family: Settings.settings.fontFamily
    font.weight: Font.Bold
    font.pointSize: Style.fontMedium * scaling
    color: Colors.textPrimary
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
      if (calendar.visible) {
        tooltip.hide()
      }
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

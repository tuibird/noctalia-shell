import QtQuick
import qs.Services
import qs.Widgets

Rectangle {
  id: root

  readonly property real scaling: Scaling.scale(screen)
  property var onEntered: function () {}
  property var onExited: function () {}
  property var onClicked: function () {}

  width: textItem.paintedWidth
  height: textItem.paintedHeight
  color: "transparent"

  NText {
    id: textItem
    text: Time.time
    anchors.centerIn: parent
    font.weight: Style.fontWeightBold
  }

  MouseArea {
    id: clockMouseArea
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    hoverEnabled: true
    onEntered: root.onEntered()
    onExited: root.onExited()
    onClicked: root.onClicked()
  }
}

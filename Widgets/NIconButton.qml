import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.Services

Rectangle {
  id: root

  readonly property real scaling: Scaling.scale(screen)
  property real size: Style.baseWidgetSize * scaling
  property string icon
  property bool enabled: true
  property bool hovering: false
  property var onEntered: function () {}
  property var onExited: function () {}
  property var onClicked: function () {}

  implicitWidth: size
  implicitHeight: size
  radius: width * 0.5

  color: root.hovering ? Colors.accentPrimary : "transparent"

  Text {
    anchors.centerIn: parent
    text: root.icon
    font.family: "Material Symbols Outlined"
    font.pointSize: Style.fontSizeXL * scaling
    color: root.hovering ? Colors.onAccent : Colors.textPrimary
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    opacity: root.enabled ? Style.opacityFull : Style.opacityMedium
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    hoverEnabled: true
    onEntered: {
      hovering = true
      root.onEntered()
    }
    onExited: {
      hovering = false
      root.onExited()
    }
    onClicked: {
      root.onClicked()
    }
  }
}

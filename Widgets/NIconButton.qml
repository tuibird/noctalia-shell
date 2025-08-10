import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.Services

Rectangle {
  id: root

  readonly property real scaling: Scaling.scale(screen)
  // Multiplier to control how large the button container is relative to Style.baseWidgetSize
  property real sizeMultiplier: 0.8
  property real size: Style.baseWidgetSize * sizeMultiplier * scaling
  property string icon
  property string tooltipText
  property bool enabled: true
  property bool hovering: false
  property var onEntered: function () {}
  property var onExited: function () {}
  property var onClicked: function () {}
  property real fontPointSize: Style.fontSizeMedium

  implicitWidth: size
  implicitHeight: size
  radius: width * 0.5

  color: root.hovering ? Colors.accentPrimary : "transparent"

  Text {
    anchors.centerIn: parent
    anchors.horizontalCenterOffset: 0
    anchors.verticalCenterOffset: 0
    text: root.icon
    font.family: "Material Symbols Outlined"
    font.pointSize: root.fontPointSize * scaling
    color: root.hovering ? Colors.onAccent : Colors.textPrimary
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    opacity: root.enabled ? Style.opacityFull : Style.opacityMedium
  }

  NTooltip {
    id: tooltip
    target: root
    positionAbove: false
    text: root.tooltipText
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    hoverEnabled: true
    onEntered: {
      hovering = true
      if (tooltipText) {
        tooltip.show()
      }
      root.onEntered()
    }
    onExited: {
      hovering = false
      if (tooltipText) {
        tooltip.hide()
      }
      root.onExited()
    }
    onClicked: {
      root.onClicked()
    }
  }
}

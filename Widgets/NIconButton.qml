import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.Services
import qs.Theme

Rectangle {
  id: root

  // Local scale convenience with safe fallback
  readonly property real scale: (typeof screen !== 'undefined'
                                 && screen) ? Scaling.scale(screen) : 1.0

  property real size: 32 * scale
  property string icon
  property bool enabled: true
  property bool hovering: false

  implicitWidth: size
  implicitHeight: size
  radius: width * 0.5

  color: root.hovering ? Theme.accentPrimary : "transparent"

  Text {
    id: iconText
    anchors.centerIn: parent
    text: root.icon
    font.family: "Material Symbols Outlined"
    font.pixelSize: 24 * scale
    color: root.hovering ? Theme.onAccent : Theme.textPrimary
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    opacity: root.enabled ? 1.0 : 0.5
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    hoverEnabled: true
    onEntered: hovering = true
    onExited: hovering = false
  }
}

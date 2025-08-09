import QtQuick
import qs.Services

Window {
  id: root

  readonly property real scaling: Scaling.scale(screen)
  property bool isVisible: false
  property string text: "Placeholder"
  property Item target: null
  property int delay: Style.tooltipDelay
  property bool positionAbove: false

  flags: Qt.ToolTip | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
  color: "transparent"
  visible: false

  onIsVisibleChanged: {
    if (isVisible) {
      if (delay > 0) {
        timerShow.running = true
      } else {
        _showNow()
      }
    } else {
      _hideNow()
    }
  }

  function show() {
    isVisible = true
  }
  function hide() {
    isVisible = false
  }

  function _showNow() {
    // Compute new size everytime we show the tooltip
    width = Math.max(50 * scaling, tooltipText.implicitWidth + 24 * scaling)
    height = Math.max(50 * scaling, tooltipText.implicitHeight + 16 * scaling)

    if (!target) {
      return
    }

    if (positionAbove) {
      // Position tooltip above the target
      var pos = target.mapToGlobal(0, 0)
      x = pos.x - width / 2 + target.width / 2
      y = pos.y - height - 12 // 12 px margin above
    } else {
      // Position tooltip below the target
      var pos = target.mapToGlobal(0, target.height)
      x = pos.x - width / 2 + target.width / 2
      y = pos.y + 12 // 12 px margin below
    }
    visible = true
  }

  function _hideNow() {
    visible = false
  }

  Connections {
    target: root.target
    function onXChanged() {
      if (root.visible) {
        root._showNow()
      }
    }
    function onYChanged() {
      if (root.visible) {
        root._showNow()
      }
    }
    function onWidthChanged() {
      if (root.visible) {
        root._showNow()
      }
    }
    function onHeightChanged() {
      if (root.visible) {
        root._showNow()
      }
    }
  }

  Timer {
    id: timerShow
    interval: delay
    running: false
    repeat: false
    onTriggered: {
      _showNow()
      running = false
    }
  }

  Rectangle {
    anchors.fill: parent
    radius: Style.radiusMedium * scaling
    color: Theme.backgroundTertiary
    border.color: Theme.outline
    border.width: 1 * scaling
    opacity: 0.97
    z: 1
  }

  Text {
    id: tooltipText
    anchors.centerIn: parent
    text: root.text
    color: Theme.textPrimary
    font.family: Theme.fontFamily
    font.pointSize: Style.fontSmall * scaling
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    wrapMode: Text.Wrap
    z: 1
  }
}

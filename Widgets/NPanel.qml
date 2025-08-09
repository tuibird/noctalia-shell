import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Services

PanelWindow {
  id: outerPanel

  readonly property real scaling: Scaling.scale(screen)
  property bool showOverlay: Settings.settings.dimPanels
  property int topMargin: Style.barHeight * scaling
  property color overlayColor: showOverlay ? Theme.overlay : "transparent"

  function hide() {
    visible = false
  }

  function show() {
    visible = true
  }

  implicitWidth: screen.width
  implicitHeight: screen.height
  color: visible ? overlayColor : "transparent"
  visible: false
  WlrLayershell.exclusionMode: ExclusionMode.Ignore
  screen: (typeof modelData !== 'undefined' ? modelData : null)
  anchors.top: true
  anchors.left: true
  anchors.right: true
  anchors.bottom: true
  margins.top: topMargin

  MouseArea {
    anchors.fill: parent
    onClicked: outerPanel.hide()
  }

  Behavior on color {
    ColorAnimation {
      duration: 350
      easing.type: Easing.InOutCubic
    }
  }
}

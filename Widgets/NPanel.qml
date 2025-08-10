import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Services

PanelWindow {
  id: outerPanel

  readonly property real scaling: Scaling.scale(screen)
  property bool showOverlay: Settings.data.general.dimDesktop
  property int topMargin: Style.barHeight * scaling
  property color overlayColor: showOverlay ? Colors.overlay : "transparent"
  signal dismissed

  function hide() {
    //visible = false
    dismissed()
  }

  function show() {
    // Ensure only one panel is visible at a time using Settings as ephemeral store
    try {
      if (Settings.openPanel && Settings.openPanel !== outerPanel && Settings.openPanel.hide) {
        Settings.openPanel.hide()
      }
      Settings.openPanel = outerPanel
    } catch (e) {
      // ignore
    }
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

  Component.onDestruction: {
    try {
      if (visible && Settings.openPanel === outerPanel) Settings.openPanel = null
    } catch (e) {}
  }

  onVisibleChanged: function() {
    try {
      if (!visible && Settings.openPanel === outerPanel) Settings.openPanel = null
    } catch (e) {}
  }
}

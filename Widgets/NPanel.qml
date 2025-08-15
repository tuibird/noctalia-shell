import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Services

PanelWindow {
  id: root

  readonly property real scaling: Scaling.scale(screen)

  property bool showOverlay: Settings.data.general.dimDesktop
  property int topMargin: Style.barHeight * scaling
  property color overlayColor: showOverlay ? Colors.applyOpacity(Colors.mShadow, "AA") : "transparent"
  signal dismissed

  function hide() {
    //visible = false
    root.dismissed()
  }

  function show() {
    // Ensure only one panel is visible at a time using PanelManager as ephemeral storage
    try {
      if (PanelManager.openedPanel && PanelManager.openedPanel !== root && PanelManager.openedPanel.hide) {
        PanelManager.openedPanel.hide()
      }
      PanelManager.openedPanel = root
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

  anchors.top: true
  anchors.left: true
  anchors.right: true
  anchors.bottom: true
  margins.top: topMargin

  MouseArea {
    anchors.fill: parent
    onClicked: root.hide()
  }

  Behavior on color {
    ColorAnimation {
      duration: Style.animationSlow
      easing.type: Easing.InOutCubic
    }
  }

  Component.onDestruction: {
    try {
      if (visible && Settings.openPanel === root)
        Settings.openPanel = null
    } catch (e) {

    }
  }

  onVisibleChanged: {
    try {
      if (!visible && Settings.openPanel === root)
        Settings.openPanel = null
    } catch (e) {

    }
  }
}

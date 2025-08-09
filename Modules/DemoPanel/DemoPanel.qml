import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.Services
import qs.Widgets

/*
  An experiment/demo panel to tweaks widgets
*/


NPanel {
  id: root

  readonly property real scaling: Scaling.scale(screen)

  Rectangle {
    color: Theme.backgroundPrimary
    radius: Style.radiusMedium * scaling
    border.color: Theme.backgroundTertiary
    border.width: Math.max(1, 1.5 * scale)
    width: 340 * scaling
    height: 200
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.topMargin: 4 * scaling
    anchors.rightMargin: 4 * scaling

    // Prevent closing when clicking in the panel bg
    MouseArea {
      anchors.fill: parent
    }

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: 16 * scaling
      spacing: 12 * scaling

      NToggle {
        label: "Label"
        description: "Description"
        onToggled: function(value: bool) {
          console.log("NToggle: " + value)
        }
      }

      NIconButton {
        id: myIconButton
        icon: "refresh"
        onEntered: function() {
          myTooltip.show();
        }
        onExited: function() {
          myTooltip.hide();
        }
      }

      NTooltip {
        id: myTooltip
        target: myIconButton
        positionAbove: false
        text: "Hello world"
      }

      NSlider {}
     

    }
  }
}

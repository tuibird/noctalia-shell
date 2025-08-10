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
    color: Colors.backgroundPrimary
    radius: Style.radiusMedium * scaling
    border.color: Colors.backgroundTertiary
    border.width: Math.min(1, Style.borderMedium * scaling)
    width: 500 * scaling
    height: 300
    anchors.centerIn: parent


    // Prevent closing when clicking in the panel bg
    MouseArea {
      anchors.fill: parent
    }

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: 16 * scaling
      spacing: 12 * scaling


      // NIconButton
      ColumnLayout {
        spacing: 16 * scaling
        NText {
          text: "NIconButton"
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
      }


      // NToggle
      ColumnLayout {
        spacing: 16 * scaling
        uniformCellSizes: true
        NText {
          text: "NToggle + NTooltip"
        }

        NToggle {
          label: "Label"
          description: "Description"
          onToggled: function(value: bool) {
            console.log("NToggle: " + value)
          }
        }

        NTooltip {
          id: myTooltip
          target: myIconButton
          positionAbove: false
          text: "Hello world"
        }
      }

      // NSlider
      ColumnLayout {
        spacing: 16 * scaling
        NText {
          text: "NSlider"
        }

        NSlider {}
      }

    }
  }
}

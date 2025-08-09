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
    border.width: Math.max(1, 1.5 * scale)
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
      RowLayout {
        spacing: 16 * scaling
        Text {
          text: "NIconButton"
          color: Colors.textPrimary
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
      RowLayout {
        spacing: 16 * scaling
        uniformCellSizes: true
        Text {
          text: "NToggle + NTooltip"
          color: Colors.textPrimary
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
      RowLayout {
        spacing: 16 * scaling
        Text {
          text: "NSlider"
          color: Colors.textPrimary
        }

        NSlider {}
      }

    }
  }
}

import QtQuick
import Quickshell
import QtQuick.Controls
import QtQuick.Layouts
import qs.Widgets
import qs.Services
import qs.Theme

PanelWindow {
  id: root

  readonly property real scaling: Scaling.scale(screen)
  property var modelData

  screen: modelData
  implicitHeight: Style.barHeight * scaling
  color: "transparent"

  anchors {
    top: true
    left: true
    right: true
  }

  Item {
    anchors.fill: parent

    Rectangle {
      anchors.fill: parent
      color: Theme.backgroundPrimary
      layer.enabled: true
    }

    // Testing widgets
    RowLayout {

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

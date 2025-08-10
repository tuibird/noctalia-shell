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

NLoader {
  id: root

  panel: Component {
    NPanel {
      id: demoPanel

      readonly property real scaling: Scaling.scale(screen)

      // Ensure panel shows itself once created
      Component.onCompleted: show()

      Rectangle {
        color: Colors.backgroundPrimary
        radius: Style.radiusMedium * scaling
        border.color: Colors.backgroundTertiary
        border.width: Math.min(1, Style.borderMedium * scaling)
        width: 500 * scaling
        height: 400
        anchors.centerIn: parent

        // Prevent closing when clicking in the panel bg
        MouseArea { anchors.fill: parent }

        ColumnLayout {
          anchors.fill: parent
          anchors.margins: Style.marginXL * scaling
          spacing: Style.marginSmall * scaling

          // NIconButton
          ColumnLayout {
            spacing: 16 * scaling
            NText { text: "NIconButton"; color: Colors.accentSecondary }

            NIconButton {
              id: myIconButton
              icon: "refresh"
              onEntered: function() { myTooltip.show() }
              onExited: function() { myTooltip.hide() }
            }
            NTooltip { id: myTooltip; target: myIconButton; positionAbove: false; text: "Hello world"; }

            NDivider { Layout.fillWidth: true }
          }

          // NToggle
          ColumnLayout {
            spacing: Style.marginLarge * scaling
            uniformCellSizes: true
            NText { text: "NToggle + NTooltip"; color: Colors.accentSecondary }

            NToggle {
              label: "Label"
              description: "Description"
              onToggled: function(value: bool) { console.log("NToggle: " + value) }
            }


            NDivider { Layout.fillWidth: true }
          }

          // NSlider
          ColumnLayout {
            spacing: 16 * scaling
            NText { text: "Scaling"; color: Colors.accentSecondary }
            RowLayout {
              spacing: Style.marginSmall * scaling
              NText { text: `${Math.round(Scaling.overrideScale * 100)}%`; Layout.alignment: Qt.AlignVCenter }
              NSlider {
                id: scaleSlider
                from: 0.6
                to: 1.8
                stepSize: 0.01
                value: Scaling.overrideScale
                onMoved: function() { Scaling.overrideScale = value }
                onPressedChanged: function() { Scaling.overrideEnabled = true }
              }
              NIconButton {
                icon: "restart_alt"
                sizeMultiplier: 0.7
                onClicked: function() {
                  Scaling.overrideEnabled = false
                  Scaling.overrideScale = 1.0
                }
              }
            }
            NDivider { Layout.fillWidth: true }
          }
        }
      }
    }
  }
}

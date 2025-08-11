import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.Services
import qs.Widgets

NLoader {
  id: root

  content: Component {
    NPanel {
      id: demoPanel

      readonly property real scaling: Scaling.scale(screen)

      // Ensure panel shows itself once created
      Component.onCompleted: show()

      Rectangle {
        id: bgRect
        color: Colors.backgroundPrimary
        radius: Style.radiusMedium * scaling
        border.color: Colors.backgroundTertiary
        border.width: Math.max(1, Style.borderMedium * scaling)
        width: 600 * scaling
        height: 600 * scaling
        anchors.centerIn: parent

        // Prevent closing when clicking in the panel bg
        MouseArea {
          anchors.fill: parent
        }

        ColumnLayout {
          anchors.fill: parent
          anchors.margins: Style.marginXL * scaling
          spacing: Style.marginSmall * scaling

          // NSlider
          ColumnLayout {
            spacing: 16 * scaling
            NText {
              text: "Scaling"
              color: Colors.accentSecondary
              font.weight: Style.fontWeightBold
            }
            RowLayout {
              spacing: Style.marginSmall * scaling
              NText {
                text: `${Math.round(Scaling.overrideScale * 100)}%`
                Layout.alignment: Qt.AlignVCenter
              }
              NSlider {
                id: scaleSlider
                from: 0.6
                to: 1.8
                stepSize: 0.01
                value: Scaling.overrideScale
                implicitWidth: bgRect.width * 0.75
                onMoved: function () {
                  Scaling.overrideScale = value
                }
                onPressedChanged: function () {
                  Scaling.overrideEnabled = true
                }
              }
              NIconButton {
                icon: "refresh"
                sizeMultiplier: 1.0
                fontPointSize: Style.fontSizeXL * scaling
                onClicked: function () {
                  Scaling.overrideEnabled = false
                  Scaling.overrideScale = 1.0
                }
              }
            }
            NDivider {
              Layout.fillWidth: true
            }
          }

          // NIconButton
          ColumnLayout {
            spacing: 16 * scaling
            NText {
              text: "NIconButton"
              color: Colors.accentSecondary
              font.weight: Style.fontWeightBold
            }

            NIconButton {
              id: myIconButton
              icon: "celebration"
              sizeMultiplier: 1.0
              fontPointSize: Style.fontSizeXL * scaling
            }

            NDivider {
              Layout.fillWidth: true
            }
          }

          // NToggle
          ColumnLayout {
            spacing: Style.marginMedium * scaling
            NText {
              text: "NToggle"
              color: Colors.accentSecondary
              font.weight: Style.fontWeightBold
            }

            NToggle {
              label: "Label"
              description: "Description"
              onToggled: function (value) {
                console.log("NToggle: " + value)
              }
            }

            NDivider {
              Layout.fillWidth: true
            }
          }

          // NComboBox
          ColumnLayout {
            spacing: Style.marginMedium * scaling
            NText {
              text: "NComboBox"
              color: Colors.accentSecondary
              font.weight: Style.fontWeightBold
            }

            NComboBox {
              optionsKeys: ["cat", "dog", "bird", "monkey", "fish", "turtle", "elephant", "tiger"]
              optionsLabels: ["Cat", "Dog", "Bird", "Monkey", "Fish", "Turtle", "Elephant", "Tiger"]
              currentKey: "cat"
              onSelected: function (value) {
                console.log("NComboBox: selected " + value)
              }
            }

            NDivider {
              Layout.fillWidth: true
            }
          }

          // NBusyIndicator
          ColumnLayout {
            spacing: Style.marginMedium * scaling
            NText {
              text: "NBusyIndicator"
              color: Colors.accentSecondary
              font.weight: Style.fontWeightBold
            }

            NBusyIndicator {
            }

            NDivider {
              Layout.fillWidth: true
            }
          }
        }
      }
    }
  }
}

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
      Component.onCompleted: {
        console.log("[DemoPanel] Component completed, showing panel")
        show()
      }

      Rectangle {
        id: bgRect
        color: Colors.backgroundPrimary
        radius: Style.radiusMedium * scaling
        border.color: Colors.accentPrimary
        border.width: 2
        width: 500 * scaling
        height: 700 * scaling
        anchors.centerIn: parent

        // Prevent closing when clicking in the panel bg
        MouseArea {
          anchors.fill: parent
        }

        // Debug: Add a simple text to see if content is visible
        NText {
          text: "DemoPanel is working!"
          color: Colors.accentPrimary
          font.pointSize: Style.fontSizeLarge * scaling
          anchors.top: parent.top
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.topMargin: 20 * scaling
        }

        ColumnLayout {
          anchors.fill: parent
          anchors.margins: Style.marginMedium * scaling
          anchors.topMargin: (Style.marginMedium + 40) * scaling
          spacing: Style.marginMedium * scaling

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
                onMoved: {
                  Scaling.overrideScale = value
                }
                onPressedChanged: {
                  Scaling.overrideEnabled = true
                }
              }
              NIconButton {
                icon: "refresh"
                fontPointSize: Style.fontSizeXL * scaling
                onClicked: {
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
                console.log("[DemoPanel] NToggle:", value)
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
                console.log("[DemoPanel] NComboBox: selected ", value)
              }
            }

            NDivider {
              Layout.fillWidth: true
            }
          }

          // NTextInput
          ColumnLayout {
            spacing: Style.marginMedium * scaling
            NText {
              text: "NTextInput"
              color: Colors.accentSecondary
              font.weight: Style.fontWeightBold
            }

            NTextInput {
              text: "Type anything"
              Layout.fillWidth: true
              onEditingFinished: {

              }
              NDivider {
                Layout.fillWidth: true
              }
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

            NBusyIndicator {}

            NDivider {
              Layout.fillWidth: true
            }
          }
        }
      }
    }
  }
}

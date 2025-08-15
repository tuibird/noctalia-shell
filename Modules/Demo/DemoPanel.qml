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

      // Override hide function to animate first
      function hide() {
        // Start hide animation
        bgRect.scaleValue = 0.8
        bgRect.opacityValue = 0.0

        // Hide after animation completes
        hideTimer.start()
      }

      // Connect to NPanel's dismissed signal to handle external close events
      Connections {
        target: demoPanel
        function onDismissed() {
          // Start hide animation
          bgRect.scaleValue = 0.8
          bgRect.opacityValue = 0.0

          // Hide after animation completes
          hideTimer.start()
        }
      }

      // Also handle visibility changes from external sources
      onVisibleChanged: {
        if (!visible && bgRect.opacityValue > 0) {
          // Start hide animation
          bgRect.scaleValue = 0.8
          bgRect.opacityValue = 0.0

          // Hide after animation completes
          hideTimer.start()
        }
      }

      // Timer to hide panel after animation
      Timer {
        id: hideTimer
        interval: Style.animationSlow
        repeat: false
        onTriggered: {
          demoPanel.visible = false
          demoPanel.dismissed()
        }
      }

      // Ensure panel shows itself once created
      Component.onCompleted: {
        show()
      }

      Rectangle {
        id: bgRect
        color: Colors.mSurfaceVariant
        radius: Style.radiusMedium * scaling
        border.color: Colors.mOutlineVariant
        border.width: Math.max(1, Style.borderThin * scaling)
        width: 500 * scaling
        height: 700 * scaling
        anchors.centerIn: parent

        // Animation properties
        property real scaleValue: 0.8
        property real opacityValue: 0.0

        scale: scaleValue
        opacity: opacityValue

        // Animate in when component is completed
        Component.onCompleted: {
          scaleValue = 1.0
          opacityValue = 1.0
        }

        // Prevent closing when clicking in the panel bg
        MouseArea {
          anchors.fill: parent
        }

        // Animation behaviors
        Behavior on scale {
          NumberAnimation {
            duration: Style.animationSlow
            easing.type: Easing.OutExpo
          }
        }

        Behavior on opacity {
          NumberAnimation {
            duration: Style.animationNormal
            easing.type: Easing.OutQuad
          }
        }

        ColumnLayout {
          anchors.fill: parent
          anchors.margins: Style.marginXL * scaling

          NText {
            text: "DemoPanel"
            color: Colors.mPrimary
            font.pointSize: Style.fontSizeXL * scaling
            font.weight: Style.fontWeightBold
            Layout.alignment: Qt.AlignHCenter
          }

          ColumnLayout {

            spacing: Style.marginMedium * scaling

            // NSlider
            ColumnLayout {
              spacing: Style.marginLarge * scaling
              NText {
                text: "Scaling"
                color: Colors.mSecondary
                font.weight: Style.fontWeightBold
              }
              NText {
                text: `${Math.round(Scaling.overrideScale * 100)}%`
                Layout.alignment: Qt.AlignVCenter
              }
              RowLayout {
                spacing: Style.marginSmall * scaling
                NSlider {
                  id: scaleSlider
                  from: 0.6
                  to: 1.8
                  stepSize: 0.01
                  value: Scaling.overrideScale
                  implicitWidth: bgRect.width * 0.75
                  onMoved: {

                  }
                  onPressedChanged: {
                    Scaling.overrideScale = value
                    Scaling.overrideEnabled = true
                  }
                }
                NIconButton {
                  icon: "refresh"
                  fontPointSize: Style.fontSizeLarge * scaling
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
              spacing: Style.marginLarge * scaling
              NText {
                text: "NIconButton"
                color: Colors.mSecondary
                font.weight: Style.fontWeightBold
              }

              NIconButton {
                id: myIconButton
                icon: "celebration"
                fontPointSize: Style.fontSizeLarge * scaling
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
                color: Colors.mSecondary
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
                color: Colors.mSecondary
                font.weight: Style.fontWeightBold
              }

              NComboBox {
                label: "Animal"
                description: "What's your favorite?"
                model: ListModel {
                  ListElement {
                    key: "cat"
                    name: "Cat"
                  }
                  ListElement {
                    key: "dog"
                    name: "Dog"
                  }
                  ListElement {
                    key: "bird"
                    name: "Bird"
                  }
                  ListElement {
                    key: "fish"
                    name: "Fish"
                  }
                  ListElement {
                    key: "turtle"
                    name: "Turtle"
                  }
                  ListElement {
                    key: "elephant"
                    name: "Elephant"
                  }
                  ListElement {
                    key: "tiger"
                    name: "Tiger"
                  }
                }
                currentKey: "dog"
                onSelected: function (key) {
                  console.log("[DemoPanel] NComboBox: selected ", key)
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
                color: Colors.mSecondary
                font.weight: Style.fontWeightBold
              }

              NTextInput {
                label: "Input label"
                description: "A cool description"
                text: "Type anything"
                Layout.fillWidth: true
                onEditingFinished: {

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
                color: Colors.mSecondary
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
}

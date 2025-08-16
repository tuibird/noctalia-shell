import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import qs.Commons
import qs.Services
import qs.Widgets

Item {
  property real scaling: 1
  readonly property string tabIcon: "brightness_6"
  readonly property string tabLabel: "Brightness"
  Layout.fillWidth: true
  Layout.fillHeight: true

  ScrollView {
    anchors.fill: parent
    clip: true
    ScrollBar.vertical.policy: ScrollBar.AsNeeded
    ScrollBar.horizontal.policy: ScrollBar.AsNeeded
    contentWidth: parent.width

    ColumnLayout {
      width: parent.width
      ColumnLayout {
        spacing: Style.marginLarge * scaling
        Layout.margins: Style.marginLarge * scaling
        Layout.fillWidth: true

        NText {
          text: "Brightness Settings"
          font.pointSize: Style.fontSizeXL * scaling
          font.weight: Style.fontWeightBold
          color: Colors.mOnSurface
        }

        NText {
          text: "Configure brightness controls and monitor settings."
          font.pointSize: Style.fontSize * scaling
          color: Colors.mOnSurfaceVariant
        }

        // Bar Visibility Section
        ColumnLayout {
          spacing: Style.marginSmall * scaling
          Layout.fillWidth: true
          Layout.topMargin: Style.marginLarge * scaling

          NText {
            text: "Bar Integration"
            font.pointSize: Style.fontSizeLarge * scaling
            font.weight: Style.fontWeightBold
            color: Colors.mOnSurface
          }

          NToggle {
            label: "Show Brightness Icon"
            description: "Display the brightness control icon in the top bar"
            checked: !Settings.data.bar.hideBrightness
            onToggled: checked => {
                         Settings.data.bar.hideBrightness = !checked
                       }
          }
        }

        NDivider {
          Layout.fillWidth: true
          Layout.topMargin: Style.marginLarge * scaling
          Layout.bottomMargin: Style.marginLarge * scaling
        }

        // Brightness Step Section
        ColumnLayout {
          spacing: Style.marginSmall * scaling
          Layout.fillWidth: true

          NText {
            text: "Brightness Step Size"
            font.pointSize: Style.fontSizeLarge * scaling
            font.weight: Style.fontWeightBold
            color: Colors.mOnSurface
          }

          NText {
            text: "Adjust the step size for brightness changes (scroll wheel, keyboard shortcuts)"
            font.pointSize: Style.fontSizeSmall * scaling
            color: Colors.mOnSurfaceVariant
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
          }

          RowLayout {
            Layout.fillWidth: true
            spacing: Style.marginMedium * scaling

            NSlider {
              Layout.fillWidth: true
              from: 1
              to: 50
              value: Settings.data.brightness.brightnessStep
              stepSize: 1
              onPressedChanged: {
                if (!pressed) {
                  Settings.data.brightness.brightnessStep = value
                }
              }
            }

            NText {
              text: Settings.data.brightness.brightnessStep + "%"
              Layout.alignment: Qt.AlignVCenter
              color: Colors.mOnSurface
              font.pointSize: Style.fontSizeMedium * scaling
              font.weight: Style.fontWeightBold
            }
          }
        }

        NDivider {
          Layout.fillWidth: true
          Layout.topMargin: Style.marginLarge * scaling
          Layout.bottomMargin: Style.marginLarge * scaling
        }

        // Monitor Overview Section
        ColumnLayout {
          spacing: Style.marginSmall * scaling
          Layout.fillWidth: true

          NText {
            text: "Monitor Brightness Overview"
            font.pointSize: Style.fontSizeLarge * scaling
            font.weight: Style.fontWeightBold
            color: Colors.mOnSurface
          }

          NText {
            text: "Current brightness levels for all detected monitors"
            font.pointSize: Style.fontSizeSmall * scaling
            color: Colors.mOnSurfaceVariant
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
          }

          // Single monitor display using the same data source as the bar icon
          Rectangle {
            Layout.fillWidth: true
            radius: Style.radiusMedium * scaling
            color: Colors.mSurface
            border.color: Colors.mOutline
            border.width: Math.max(1, Style.borderThin * scaling)
            implicitHeight: contentCol.implicitHeight + Style.marginXL * 2 * scaling

            ColumnLayout {
              id: contentCol
              anchors.fill: parent
              anchors.margins: Style.marginLarge * scaling
              spacing: Style.marginMedium * scaling

              RowLayout {
                Layout.fillWidth: true
                spacing: Style.marginMedium * scaling

                NText {
                  text: "Primary Monitor"
                  font.pointSize: Style.fontSizeLarge * scaling
                  font.weight: Style.fontWeightBold
                  color: Colors.mSecondary
                }

                Item {
                  Layout.fillWidth: true
                }

                NText {
                  text: BrightnessService.currentMethod === "ddcutil" ? "External (DDC)" : "Internal"
                  font.pointSize: Style.fontSizeSmall * scaling
                  color: Colors.mOnSurfaceVariant
                  Layout.alignment: Qt.AlignRight
                }
              }

              RowLayout {
                Layout.fillWidth: true
                spacing: Style.marginMedium * scaling

                NText {
                  text: "Brightness:"
                  font.pointSize: Style.fontSizeMedium * scaling
                  color: Colors.mOnSurface
                }

                NSlider {
                  Layout.fillWidth: true
                  from: 0
                  to: 100
                  value: BrightnessService.brightness
                  stepSize: 1
                  enabled: BrightnessService.available
                  onPressedChanged: {
                    if (!pressed && BrightnessService.available) {
                      BrightnessService.setBrightness(value)
                    }
                  }
                }

                NText {
                  text: BrightnessService.available ? Math.round(BrightnessService.brightness) + "%" : "N/A"
                  font.pointSize: Style.fontSizeMedium * scaling
                  font.weight: Style.fontWeightBold
                  color: BrightnessService.available ? Colors.mPrimary : Colors.mOnSurfaceVariant
                  Layout.alignment: Qt.AlignRight
                }
              }

              RowLayout {
                Layout.fillWidth: true
                spacing: Style.marginMedium * scaling

                NText {
                  text: "Method:"
                  font.pointSize: Style.fontSizeSmall * scaling
                  color: Colors.mOnSurfaceVariant
                }

                NText {
                  text: BrightnessService.currentMethod || "Unknown"
                  font.pointSize: Style.fontSizeSmall * scaling
                  color: Colors.mOnSurface
                  Layout.alignment: Qt.AlignLeft
                }

                Item {
                  Layout.fillWidth: true
                }

                NText {
                  text: BrightnessService.available ? "Available" : "Unavailable"
                  font.pointSize: Style.fontSizeSmall * scaling
                  color: BrightnessService.available ? Colors.mPrimary : Colors.mError
                  Layout.alignment: Qt.AlignRight
                }
              }
            }
          }
        }

        Item {
          Layout.fillHeight: true
        }
      }
    }
  }
}

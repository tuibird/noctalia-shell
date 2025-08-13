import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Services
import qs.Widgets

ColumnLayout {
  id: root

  spacing: 0

  ScrollView {
    id: scrollView

    Layout.fillWidth: true
    Layout.fillHeight: true
    padding: Style.marginMedium * scaling
    clip: true
    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
    ScrollBar.vertical.policy: ScrollBar.AsNeeded

    ColumnLayout {
      width: scrollView.availableWidth
      spacing: 0

      Item {
        Layout.fillWidth: true
        Layout.preferredHeight: 0
      }

      ColumnLayout {
        spacing: Style.marginLarge * scaling
        Layout.fillWidth: true

        NText {
          text: "Directory"
          font.pointSize: Style.fontSizeXL * scaling
          font.weight: Style.fontWeightBold
          color: Colors.textPrimary
          Layout.bottomMargin: Style.marginSmall * scaling
        }

        // Wallpaper Settings Category
        ColumnLayout {
          spacing: Style.marginSmall * scaling
          Layout.fillWidth: true
          Layout.topMargin: Style.marginSmall * scaling

          // Wallpaper Folder
          ColumnLayout {
            spacing: Style.marginSmall * scaling
            Layout.fillWidth: true

            NTextInput {
              label: "Wallpaper Directory"
              description: "Path to your wallpaper directory"
              text: Settings.data.wallpaper.directory
              Layout.fillWidth: true
              onEditingFinished: {
                Settings.data.wallpaper.directory = text
              }
            }
          }
        }
      }

      NDivider {
        Layout.fillWidth: true
        Layout.topMargin: Style.marginLarge * 2 * scaling
        Layout.bottomMargin: Style.marginLarge * scaling
      }

      ColumnLayout {
        spacing: Style.marginLarge * scaling
        Layout.fillWidth: true

        NText {
          text: "Automation"
          font.pointSize: Style.fontSizeXL * scaling
          font.weight: Style.fontWeightBold
          color: Colors.textPrimary
          Layout.bottomMargin: Style.marginSmall * scaling
        }

        // Random Wallpaper
        NToggle {
          label: "Random Wallpaper"
          description: "Automatically select random wallpapers from the folder"
          value: Settings.data.wallpaper.isRandom
          onToggled: function (newValue) {
            Settings.data.wallpaper.isRandom = newValue
          }
        }

        // Use Wallpaper Theme
        NToggle {
          label: "Use Wallpaper Theme"
          description: "Automatically adjust theme colors based on wallpaper"
          value: Settings.data.wallpaper.generateTheme
          onToggled: function (newValue) {
            Settings.data.wallpaper.generateTheme = newValue
          }
        }

        // Interval
        ColumnLayout {
          RowLayout {
            Layout.fillWidth: true

            ColumnLayout {
              NText {
                text: "Wallpaper Interval"
                font.weight: Style.fontWeightBold
                color: Colors.textPrimary
              }

              NText {
                text: "How often to change wallpapers automatically (in seconds)"
                font.pointSize: Style.fontSizeSmall * scaling
                color: Colors.textSecondary
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
              }
            }

            NText {
              text: sliderWpInterval.value + " seconds"
              Layout.alignment: Qt.AlignBottom | Qt.AlignRight
            }
          }

          NSlider {
            id: sliderWpInterval
            Layout.fillWidth: true
            from: 10
            to: 900
            stepSize: 10
            value: Settings.data.wallpaper.randomInterval
            onPressedChanged: Settings.data.wallpaper.randomInterval = Math.round(value)
            cutoutColor: Colors.backgroundPrimary
          }
        }
      }

      NDivider {
        Layout.fillWidth: true
        Layout.topMargin: Style.marginLarge * 2 * scaling
        Layout.bottomMargin: Style.marginLarge * scaling
      }

      // -------------------------------
      // SWWW
      ColumnLayout {
        spacing: Style.marginLarge * scaling
        Layout.fillWidth: true

        NText {
          text: "SWWW"
          font.pointSize: Style.fontSizeXL * scaling
          font.weight: Style.fontWeightBold
          color: Colors.textPrimary
          Layout.bottomMargin: 8
        }

        // Use SWWW
        NToggle {
          label: "Use SWWW"
          description: "Use SWWW daemon for advanced wallpaper management"
          value: Settings.data.wallpaper.swww.enabled
          onToggled: function (newValue) {
            Settings.data.wallpaper.swww.enabled = newValue
          }
        }

        // SWWW Settings (only visible when useSWWW is enabled)
        ColumnLayout {
          spacing: Style.marginSmall * scaling
          Layout.fillWidth: true
          Layout.topMargin: Style.marginSmall * scaling
          visible: Settings.data.wallpaper.swww.enabled

          // Resize Mode
          NComboBox {
            label: "Resize Mode"
            description: "How SWWW should resize wallpapers to fit the screen"
            optionsKeys: ["no", "crop", "fit", "stretch"]
            optionsLabels: ["No", "Crop", "Fit", "Stretch"]
            currentKey: Settings.data.wallpaper.swww.resizeMethod
            onSelected: function (key) {
              Settings.data.wallpaper.swww.resizeMethod = key
            }
          }

          // Transition Type
          NComboBox {
            label: "Transition Type"
            description: "Animation type when switching between wallpapers"
            optionsKeys: ["none", "simple", "fade", "left", "right", "top", "bottom", "wipe", "wave", "grow", "center", "any", "outer", "random"]
            optionsLabels: ["None", "Simple", "Fade", "Left", "Right", "Top", "Bottom", "Wipe", "Wave", "Grow", "Center", "Any", "Outer", "Random"]
            currentKey: Settings.data.wallpaper.swww.transitionType
            onSelected: function (key) {
              Settings.data.wallpaper.swww.transitionType = key
            }
          }

          // Transition FPS
          ColumnLayout {
            RowLayout {
              Layout.fillWidth: true

              ColumnLayout {
                NText {
                  text: "Transition FPS"
                  font.weight: Style.fontWeightBold
                  color: Colors.textPrimary
                }

                NText {
                  text: "Frames per second for transition animations"
                  font.pointSize: Style.fontSizeSmall * scaling
                  color: Colors.textSecondary
                  wrapMode: Text.WordWrap
                  Layout.fillWidth: true
                }
              }

              NText {
                text: sliderWpTransitionFps.value + " FPS"
                Layout.alignment: Qt.AlignBottom | Qt.AlignRight
              }
            }

            NSlider {
              id: sliderWpTransitionFps
              Layout.fillWidth: true
              from: 30
              to: 500
              stepSize: 5
              value: Settings.data.wallpaper.swww.transitionFps
              onPressedChanged: Settings.data.wallpaper.swww.transitionFps = Math.round(value)
              cutoutColor: Colors.backgroundPrimary
            }
          }

          // Transition Duration
          ColumnLayout {
            RowLayout {
              Layout.fillWidth: true

              ColumnLayout {
                NText {
                  text: "Transition Duration"
                  font.weight: Style.fontWeightBold
                  color: Colors.textPrimary
                }

                NText {
                  text: "Duration of transition animations in seconds"
                  font.pointSize: Style.fontSizeSmall * scaling
                  color: Colors.textSecondary
                  wrapMode: Text.WordWrap
                  Layout.fillWidth: true
                }
              }

              NText {
                text: sliderWpTransitionDuration.value.toFixed(2) + "s"
                Layout.alignment: Qt.AlignBottom | Qt.AlignRight
              }
            }

            NSlider {
              id: sliderWpTransitionDuration
              Layout.fillWidth: true
              from: 0.25
              to: 10
              stepSize: 0.05
              value: Settings.data.wallpaper.swww.transitionDuration
              onPressedChanged: Settings.data.wallpaper.swww.transitionDuration = value
              cutoutColor: Colors.backgroundPrimary
            }
          }
        }
      }
    }
  }
}

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
        spacing: 4
        Layout.fillWidth: true

        NText {
          text: "Wallpaper Settings"
          font.pointSize: 18
          font.weight: Style.fontWeightBold
          color: Colors.textPrimary
          Layout.bottomMargin: 8
        }

        // Wallpaper Settings Category
        ColumnLayout {
          spacing: 8
          Layout.fillWidth: true
          Layout.topMargin: 8

          // Wallpaper Folder
          ColumnLayout {
            spacing: 8
            Layout.fillWidth: true

            NText {
              text: "Wallpaper Folder"
              font.pointSize: 13
              font.weight: Style.fontWeightBold
              color: Colors.textPrimary
            }

            NText {
              text: "Path to your wallpaper folder"
              font.pointSize: 12
              color: Colors.textSecondary
              wrapMode: Text.WordWrap
              Layout.fillWidth: true
            }

            NTextInput {
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
        Layout.topMargin: 26
        Layout.bottomMargin: 18
      }

      ColumnLayout {
        spacing: 4
        Layout.fillWidth: true

        NText {
          text: "Automation"
          font.pointSize: 18
          font.weight: Style.fontWeightBold
          color: Colors.textPrimary
          Layout.bottomMargin: 8
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

        // Wallpaper Interval
        // NSlider {
        //   label: "Wallpaper Interval"
        //   description: "How often to change wallpapers automatically (in seconds)"
        //   valueSuffix: "s"
        //   from: 10
        //   to: 900
        //   stepSize: 10
        //   value: Settings.data.wallpaper.randomInterval
        //   onPressedChanged: function (pressed, value) {
        //     Settings.data.wallpaper.randomInterval = Math.round(value)
        //   }
        //   cutoutColor: Colors.backgroundPrimary
        //   Layout.fillWidth: true
        // }
      }

      NDivider {
        Layout.fillWidth: true
        Layout.topMargin: 26
        Layout.bottomMargin: 18
      }

      ColumnLayout {
        spacing: 4
        Layout.fillWidth: true

        NText {
          text: "SWWW"
          font.pointSize: 18
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
          spacing: 8
          Layout.fillWidth: true
          Layout.topMargin: 8
          visible: Settings.data.wallpaper.swww.enabled

          // Resize Mode
          ColumnLayout {
            spacing: 8
            Layout.fillWidth: true

            NText {
              text: "Resize Mode"
              font.pointSize: 13
              font.weight: Style.fontWeightBold
              color: Colors.textPrimary
            }

            NText {
              text: "How SWWW should resize wallpapers to fit the screen"
              font.pointSize: 12
              color: Colors.textSecondary
              wrapMode: Text.WordWrap
              Layout.fillWidth: true
            }

            NComboBox {
              optionsKeys: ["no", "crop", "fit", "stretch"]
              optionsLabels: ["No", "Crop", "Fit", "Stretch"]
              currentKey: Settings.data.wallpaper.swww.resizeMethod
              onSelected: function (key) {
                Settings.data.wallpaper.swww.resizeMethod = key
              }
            }
          }

          // Transition Type
          ColumnLayout {
            spacing: 8
            Layout.fillWidth: true
            Layout.topMargin: 8

            NText {
              text: "Transition Type"
              font.pointSize: 13
              font.weight: Style.fontWeightBold
              color: Colors.textPrimary
            }

            NText {
              text: "Animation type when switching between wallpapers"
              font.pointSize: 12
              color: Colors.textSecondary
              wrapMode: Text.WordWrap
              Layout.fillWidth: true
            }

            NComboBox {
              optionsKeys: ["none", "simple", "fade", "left", "right", "top", "bottom", "wipe", "wave", "grow", "center", "any", "outer", "random"]
              optionsLabels: ["None", "Simple", "Fade", "Left", "Right", "Top", "Bottom", "Wipe", "Wave", "Grow", "Center", "Any", "Outer", "Random"]
              currentKey: Settings.data.wallpaper.swww.transitionType
              onSelected: function (key) {
                Settings.data.wallpaper.swww.transitionType = key
              }
            }
          }

          // Transition FPS
          // NSlider {
          //   label: "Transition FPS"
          //   description: "Frames per second for transition animations"
          //   valueSuffix: " FPS"
          //   from: 30
          //   to: 500
          //   stepSize: 5
          //   value: Settings.data.wallpaper.swww.transitionFps
          //   onPressedChanged: function (pressed, value) {
          //     Settings.data.wallpaper.swww.transitionFps = Math.round(value)
          //   }
          //   cutoutColor: Colors.backgroundPrimary
          //   Layout.fillWidth: true
          // }

          // Transition Duration
          // NSlider {
          //   label: "Transition Duration"
          //   description: "Duration of transition animations in seconds"
          //   valueSuffix: "s"
          //   from: 0.25
          //   to: 10
          //   stepSize: 0.05
          //   value: Settings.data.wallpaper.swww.transitionDuration
          //   onPressedChanged: function (pressed, value) {
          //     Settings.data.wallpaper.swww.transitionDuration = value
          //   }
          //   cutoutColor: Colors.backgroundPrimary
          //   Layout.fillWidth: true
          // }
        }
      }
    }
  }
}

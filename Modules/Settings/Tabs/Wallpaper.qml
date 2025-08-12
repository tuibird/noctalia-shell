import QtQuick
import QtQuick.Layouts
import qs.Services
import qs.Widgets

Item {
  property real scaling: 1
  readonly property string tabIcon: "image"
  readonly property string tabLabel: "Wallpaper"
  readonly property int tabIndex: 6
  Layout.fillWidth: true
  Layout.fillHeight: true

  ColumnLayout {
    anchors.fill: parent
    spacing: Style.marginMedium * scaling

    NText {
      text: "Wallpaper Settings"
      font.weight: Style.fontWeightBold
      color: Colors.accentSecondary
    }

    // Folder
    NText {
      text: "Wallpaper Folder"

      font.weight: Style.fontWeightBold
    }
    NText {
      text: "Path to your wallpaper folder"
      color: Colors.textSecondary
      wrapMode: Text.WordWrap
    }
    NTextInput {
      text: Settings.data.wallpaper.directory
      Layout.fillWidth: true
      onEditingFinished: Settings.data.wallpaper.directory = text
    }

    NDivider {
      Layout.fillWidth: true
    }

    // ----------------------------
    NText {
      text: "Automation"
      font.weight: Style.fontWeightBold
      color: Colors.accentSecondary
    }

    NToggle {
      label: "Random Wallpaper"
      description: "Automatically select random wallpapers from the folder"
      value: Settings.data.wallpaper.isRandom
      onToggled: function (newValue) {
        Settings.data.wallpaper.isRandom = newValue
      }
    }

    NToggle {
      label: "Use Wallpaper Theme"
      description: "Automatically adjust theme colors based on wallpaper"
      value: Settings.data.wallpaper.generateTheme
      onToggled: function (newValue) {
        Settings.data.wallpaper.generateTheme = newValue
      }
    }

    NText {
      text: "Wallpaper Interval"
      color: Colors.textPrimary
      font.weight: Style.fontWeightBold
    }
    NText {
      text: "How often to change wallpapers automatically (in seconds)"
      color: Colors.textSecondary
    }
    RowLayout {
      Layout.fillWidth: true
      NText {
        text: Settings.data.wallpaper.randomInterval + " seconds"
        color: Colors.textPrimary
      }
      Item {
        Layout.fillWidth: true
      }
    }
    NSlider {
      Layout.fillWidth: true
      from: 10
      to: 900
      stepSize: 10
      value: Settings.data.wallpaper.randomInterval
      onMoved: Settings.data.wallpaper.randomInterval = Math.round(value)
      cutoutColor: Colors.backgroundPrimary
    }

    NDivider {
      Layout.fillWidth: true
    }

    NText {
      text: "SWWW"
      font.weight: Style.fontWeightBold
      color: Colors.accentSecondary
    }

    NToggle {
      label: "Use SWWW"
      description: "Use SWWW daemon for advanced wallpaper management"
      value: Settings.data.wallpaper.swww.enabled
      onToggled: function (newValue) {
        Settings.data.wallpaper.swww.enabled = newValue
      }
    }

    // SWWW settings
    ColumnLayout {
      spacing: Style.marginSmall * scaling
      visible: Settings.data.wallpaper.swww.enabled

      NText {
        text: "Resize Mode"
        font.weight: Style.fontWeightBold
      }
      NText {
        text: "How SWWW should resize wallpapers to fit the screen"
        color: Colors.textSecondary
        wrapMode: Text.WordWrap
      }
      NComboBox {
        optionsKeys: ["no", "crop", "fit", "stretch"]
        optionsLabels: ["No", "Crop", "Fit", "Stretch"]
        currentKey: Settings.data.wallpaper.swww.resizeMethod
        onSelected: function (key) {
          Settings.data.wallpaper.swww.resizeMethod = key
        }
      }

      NText {
        text: "Transition Type"
        font.weight: Style.fontWeightBold
      }
      NText {
        text: "Animation type when switching between wallpapers"
        color: Colors.textSecondary
        wrapMode: Text.WordWrap
      }
      NComboBox {
        optionsKeys: ["none", "simple", "fade", "left", "right", "top", "bottom", "wipe", "wave", "grow", "center", "any", "outer", "random"]
        optionsLabels: ["None", "Simple", "Fade", "Left", "Right", "Top", "Bottom", "Wipe", "Wave", "Grow", "Center", "Any", "Outer", "Random"]
        currentKey: Settings.data.wallpaper.swww.transitionType
        onSelected: function (key) {
          Settings.data.wallpaper.swww.transitionType = key
        }
      }

      NText {
        text: "Transition FPS"
        font.weight: Style.fontWeightBold
      }
      RowLayout {
        Layout.fillWidth: true
        NText {
          text: Settings.data.wallpaper.swww.transitionFps + " FPS"
          color: Colors.textPrimary
        }
        Item {
          Layout.fillWidth: true
        }
      }
      NSlider {
        Layout.fillWidth: true
        from: 30
        to: 500
        stepSize: 5
        value: Settings.data.wallpaper.swww.transitionFps
        onMoved: Settings.data.wallpaper.swww.transitionFps = Math.round(value)
        cutoutColor: Colors.backgroundPrimary
      }

      NText {
        text: "Transition Duration"
        color: Colors.textPrimary
        font.weight: Style.fontWeightBold
      }
      RowLayout {
        Layout.fillWidth: true
        NText {
          text: Settings.data.wallpaper.swww.transitionDuration.toFixed(2) + " s"
          color: Colors.textPrimary
        }
        Item {
          Layout.fillWidth: true
        }
      }
      NSlider {
        Layout.fillWidth: true
        from: 0.25
        to: 10
        stepSize: 0.05
        value: Settings.data.wallpaper.swww.transitionDuration
        onMoved: Settings.data.wallpaper.swww.transitionDuration = value
        cutoutColor: Colors.backgroundPrimary
      }
    }

    Item {
      Layout.fillHeight: true
    }
  }
}

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

        // Use Wallpaper Colors
        NToggle {
          label: "Use Wallpaper Colors"
          description: "Automatically generate colors from you active wallpaper (requires Matugen)"
          value: Settings.data.colorSchemes.useWallpaperColors
          onToggled: function (newValue) {
            Settings.data.colorSchemes.useWallpaperColors = newValue
            if (Settings.data.colorSchemes.useWallpaperColors) {
              ColorSchemes.changedWallpaper()
            }
          }
        }

        ColumnLayout {
          spacing: Style.marginTiny * scaling
          Layout.fillWidth: true

          ButtonGroup {
            id: schemesGroup
          }

          Repeater {
            model: ColorSchemes.schemes
            NRadioButton {
              property string schemePath: modelData
              ButtonGroup.group: schemesGroup
              text: {
                // Remove json and the full path
                var chunks = schemePath.replace(".json", "").split("/")
                return chunks[chunks.length - 1]
              }
              checked: Settings.data.colorSchemes.predefinedScheme == schemePath
              onClicked: {
                // Disable useWallpaperColors when picking a predefined color scheme
                Settings.data.colorSchemes.useWallpaperColors = false
                Settings.data.colorSchemes.predefinedScheme = schemePath
                ColorSchemes.applyScheme(schemePath)
              }
            }
          }
        }
      }
    }
  }
}

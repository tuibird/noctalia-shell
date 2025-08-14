pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.Services

Singleton {
  id: root

  // Backgrounds
  property color backgroundPrimary: useMatugen ? matugenTheme.backgroundPrimary : defaultTheme.backgroundPrimary
  property color backgroundSecondary: useMatugen ? matugenTheme.backgroundSecondary : defaultTheme.backgroundSecondary
  property color backgroundTertiary: useMatugen ? matugenTheme.backgroundTertiary : defaultTheme.backgroundTertiary

  // Surfaces & Elevation
  property color surface: useMatugen ? matugenTheme.surface : defaultTheme.surface
  property color surfaceVariant: useMatugen ? matugenTheme.surfaceVariant : defaultTheme.surfaceVariant

  // Text Colors
  property color textPrimary: useMatugen ? matugenTheme.textPrimary : defaultTheme.textPrimary
  property color textSecondary: useMatugen ? matugenTheme.textSecondary : defaultTheme.textSecondary
  property color textDisabled: useMatugen ? matugenTheme.textDisabled : defaultTheme.textDisabled

  // Accent Colors
  property color accentPrimary: useMatugen ? matugenTheme.accentPrimary : defaultTheme.accentPrimary
  property color accentSecondary: useMatugen ? matugenTheme.accentSecondary : defaultTheme.accentSecondary
  property color accentTertiary: useMatugen ? matugenTheme.accentTertiary : defaultTheme.accentTertiary

  // Error/Warning
  property color error: useMatugen ? matugenTheme.error : defaultTheme.error
  property color warning: useMatugen ? matugenTheme.warning : defaultTheme.warning

  // Hover
  property color hover: useMatugen ? matugenTheme.hover : defaultTheme.hover

  // Additional Theme Properties
  property color onAccent: useMatugen ? matugenTheme.onAccent : defaultTheme.onAccent
  property color outline: useMatugen ? matugenTheme.outline : defaultTheme.outline

  // Shadows & Overlays
  property color shadow: applyOpacity(useMatugen ? matugenTheme.shadow : defaultTheme.shadow, "B3")
  property color overlay: applyOpacity(useMatugen ? matugenTheme.overlay : defaultTheme.overlay, "66")

  // Check if we should use Matugen theme
  property bool useMatugen: Settings.data.wallpaper.generateTheme && matugenFile.loaded

  function applyOpacity(color, opacity) {
    // Convert color to string and apply opacity
    return color.toString().replace("#", "#" + opacity)
  }

  // Default theme colors
  QtObject {
    id: defaultTheme

    property color backgroundPrimary: "#191724"
    property color backgroundSecondary: "#1f1d2e"
    property color backgroundTertiary: "#26233a"

    property color surface: "#1b1927"
    property color surfaceVariant: "#262337"

    property color textPrimary: "#e0def4"
    property color textSecondary: "#908caa"
    property color textDisabled: "#6e6a86"

    property color accentPrimary: "#ebbcba"
    property color accentSecondary: "#31748f"
    property color accentTertiary: "#9ccfd8"

    property color error: "#eb6f92"
    property color warning: "#f6c177"

    property color hover: "#c4a7e7"

    property color onAccent: "#191724"
    property color outline: "#44415a"

    property color shadow: "#191724"
    property color overlay: "#191724"
  }

  // Matugen theme colors (loaded from theme.json)
  QtObject {
    id: matugenTheme

    property color backgroundPrimary: matugenData.backgroundPrimary
    property color backgroundSecondary: matugenData.backgroundSecondary
    property color backgroundTertiary: matugenData.backgroundTertiary

    property color surface: matugenData.surface
    property color surfaceVariant: matugenData.surfaceVariant

    property color textPrimary: matugenData.textPrimary
    property color textSecondary: matugenData.textSecondary
    property color textDisabled: matugenData.textDisabled

    property color accentPrimary: matugenData.accentPrimary
    property color accentSecondary: matugenData.accentSecondary
    property color accentTertiary: matugenData.accentTertiary

    property color error: matugenData.error
    property color warning: matugenData.warning

    property color hover: matugenData.hover

    property color onAccent: matugenData.onAccent
    property color outline: matugenData.outline

    property color shadow: matugenData.shadow
    property color overlay: matugenData.overlay
  }

  // FileView to load Matugen theme data from Theme.json
  FileView {
    id: matugenFile
    path: Settings.configDir + "theme.json"
    watchChanges: true
    onFileChanged: reload()
    onAdapterUpdated: writeAdapter()
    onLoadFailed: function (error) {
      if (error.toString().includes("No such file") || error === 2) {
        // File doesn't exist, create it with default values
        writeAdapter()
      }
    }
    JsonAdapter {
      id: matugenData

      // Backgrounds
      property string backgroundPrimary: "#191724"
      property string backgroundSecondary: "#1f1d2e"
      property string backgroundTertiary: "#26233a"

      // Surfaces & Elevation
      property string surface: "#1b1927"
      property string surfaceVariant: "#262337"

      // Text Colors
      property string textPrimary: "#e0def4"
      property string textSecondary: "#908caa"
      property string textDisabled: "#6e6a86"

      // Accent Colors
      property string accentPrimary: "#ebbcba"
      property string accentSecondary: "#31748f"
      property string accentTertiary: "#9ccfd8"

      // Error/Warning
      property string error: "#eb6f92"
      property string warning: "#f6c177"

      // Hover
      property string hover: "#c4a7e7"

      // Additional Theme Properties
      property string onAccent: "#191724"
      property string outline: "#44415a"

      // Shadows & Overlays
      property string shadow: "#191724"
      property string overlay: "#191724"
    }
  }
}

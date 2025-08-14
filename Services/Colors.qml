pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.Services

Singleton {
  id: root

  // Backgrounds
  property color backgroundPrimary: useWallust ? wallustTheme.backgroundPrimary : defaultTheme.backgroundPrimary
  property color backgroundSecondary: useWallust ? wallustTheme.backgroundSecondary : defaultTheme.backgroundSecondary
  property color backgroundTertiary: useWallust ? wallustTheme.backgroundTertiary : defaultTheme.backgroundTertiary

  // Surfaces & Elevation
  property color surface: useWallust ? wallustTheme.surface : defaultTheme.surface
  property color surfaceVariant: useWallust ? wallustTheme.surfaceVariant : defaultTheme.surfaceVariant

  // Text Colors
  property color textPrimary: useWallust ? wallustTheme.textPrimary : defaultTheme.textPrimary
  property color textSecondary: useWallust ? wallustTheme.textSecondary : defaultTheme.textSecondary
  property color textDisabled: useWallust ? wallustTheme.textDisabled : defaultTheme.textDisabled

  // Accent Colors
  property color accentPrimary: useWallust ? wallustTheme.accentPrimary : defaultTheme.accentPrimary
  property color accentSecondary: useWallust ? wallustTheme.accentSecondary : defaultTheme.accentSecondary
  property color accentTertiary: useWallust ? wallustTheme.accentTertiary : defaultTheme.accentTertiary

  // Error/Warning
  property color error: useWallust ? wallustTheme.error : defaultTheme.error
  property color warning: useWallust ? wallustTheme.warning : defaultTheme.warning

  // Hover
  property color hover: useWallust ? wallustTheme.hover : defaultTheme.hover

  // Additional Theme Properties
  property color onAccent: useWallust ? wallustTheme.onAccent : defaultTheme.onAccent
  property color outline: useWallust ? wallustTheme.outline : defaultTheme.outline

  // Shadows & Overlays
  property color shadow: applyOpacity(useWallust ? wallustTheme.shadow : defaultTheme.shadow, "B3")
  property color overlay: applyOpacity(useWallust ? wallustTheme.overlay : defaultTheme.overlay, "66")

  // Check if we should use Wallust theme
  property bool useWallust: Settings.data.wallpaper.generateTheme && wallustFile.loaded

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

  // Wallust theme colors (loaded from theme.json)
  QtObject {
    id: wallustTheme

    property color backgroundPrimary: wallustData.backgroundPrimary
    property color backgroundSecondary: wallustData.backgroundSecondary
    property color backgroundTertiary: wallustData.backgroundTertiary

    property color surface: wallustData.surface
    property color surfaceVariant: wallustData.surfaceVariant

    property color textPrimary: wallustData.textPrimary
    property color textSecondary: wallustData.textSecondary
    property color textDisabled: wallustData.textDisabled

    property color accentPrimary: wallustData.accentPrimary
    property color accentSecondary: wallustData.accentSecondary
    property color accentTertiary: wallustData.accentTertiary

    property color error: wallustData.error
    property color warning: wallustData.warning

    property color hover: wallustData.hover

    property color onAccent: wallustData.onAccent
    property color outline: wallustData.outline

    property color shadow: wallustData.shadow
    property color overlay: wallustData.overlay
  }

  // FileView to load Wallust theme data from Theme.json
  FileView {
    id: wallustFile
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
      id: wallustData

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

pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.Services

Singleton {
  id: root

  // Backgrounds
  property color backgroundPrimary: themeData.backgroundPrimary
  property color backgroundSecondary: themeData.backgroundSecondary
  property color backgroundTertiary: themeData.backgroundTertiary

  // Surfaces & Elevation
  property color surface: themeData.surface
  property color surfaceVariant: themeData.surfaceVariant

  // Text Colors
  property color textPrimary: themeData.textPrimary
  property color textSecondary: themeData.textSecondary
  property color textDisabled: themeData.textDisabled

  // Accent Colors
  property color accentPrimary: themeData.accentPrimary
  property color accentSecondary: themeData.accentSecondary
  property color accentTertiary: themeData.accentTertiary

  // Error/Warning
  property color error: themeData.error
  property color warning: themeData.warning

  // Hover
  property color hover: themeData.hover

  // Additional Theme Properties
  property color onAccent: themeData.onAccent
  property color outline: themeData.outline

  // Shadows & Overlays
  property color shadow: applyOpacity(themeData.shadow, "B3")
  property color overlay: applyOpacity(themeData.overlay, "66")

  function applyOpacity(color, opacity) {
    return color.replace("#", "#" + opacity)
  }

  // FileView to load theme data from JSON file
  FileView {
    id: themeFile
    path: Settings.colorsFile
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
      id: themeData

      // Backgrounds
      property string backgroundPrimary: "#191724"
      property string backgroundSecondary: "#1f1d2e"
      property string backgroundTertiary: "#26233a"

      // Surfaces & Elevation
      property string surface: "#1f1d2e"
      property string surfaceVariant: "#37354c"

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

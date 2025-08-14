pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.Services

// --------------------------------
// Material3 Colors
// We only use a subset of all materials colors to avoid complexity
Singleton {
  id: root

  // --- Key Colors
  property color colorPrimary: useMatugen ? matugenTheme.colorPrimary : defaultTheme.colorPrimary
  property color colorOnPrimary: useMatugen ? matugenTheme.colorOnPrimary : defaultTheme.colorOnPrimary
  property color colorPrimaryContainer: useMatugen ? matugenTheme.colorPrimaryContainer : defaultTheme.colorPrimaryContainer
  property color colorOnPrimaryContainer: useMatugen ? matugenTheme.colorOnPrimaryContainer : defaultTheme.colorOnPrimaryContainer

  property color colorSecondary: useMatugen ? matugenTheme.colorSecondary : defaultTheme.colorSecondary
  property color colorOnSecondary: useMatugen ? matugenTheme.colorOnSecondary : defaultTheme.colorOnSecondary
  property color colorSecondaryContainer: useMatugen ? matugenTheme.colorSecondaryContainer : defaultTheme.colorSecondaryContainer
  property color colorOnSecondaryContainer: useMatugen ? matugenTheme.colorOnSecondaryContainer : defaultTheme.colorOnSecondaryContainer

  property color colorTertiary: useMatugen ? matugenTheme.colorTertiary : defaultTheme.colorTertiary
  property color colorOnTertiary: useMatugen ? matugenTheme.colorOnTertiary : defaultTheme.colorOnTertiary
  property color colorTertiaryContainer: useMatugen ? matugenTheme.colorTertiaryContainer : defaultTheme.colorTertiaryContainer
  property color colorOnTertiaryContainer: useMatugen ? matugenTheme.colorOnTertiaryContainer : defaultTheme.colorOnTertiaryContainer

  // --- Utility Colors
  property color colorError: useMatugen ? matugenTheme.colorError : defaultTheme.colorError
  property color colorOnError: useMatugen ? matugenTheme.colorOnError : defaultTheme.colorOnError
  property color colorErrorContainer: useMatugen ? matugenTheme.colorErrorContainer : defaultTheme.colorErrorContainer
  property color colorOnErrorContainer: useMatugen ? matugenTheme.colorOnErrorContainer : defaultTheme.colorOnErrorContainer

  // --- Surface and Variant Colors
  property color colorSurface: useMatugen ? matugenTheme.colorSurface : defaultTheme.colorSurface
  property color colorOnSurface: useMatugen ? matugenTheme.colorOnSurface : defaultTheme.colorOnSurface
  property color colorSurfaceVariant: useMatugen ? matugenTheme.colorSurfaceVariant : defaultTheme.colorSurfaceVariant
  property color colorOnSurfaceVariant: useMatugen ? matugenTheme.colorOnSurfaceVariant : defaultTheme.colorOnSurfaceVariant
  property color colorInversePrimary: useMatugen ? matugenTheme.colorInversePrimary : defaultTheme.colorInversePrimary
  property color colorOutline: useMatugen ? matugenTheme.colorOutline : defaultTheme.colorOutline
  property color colorOutlineVariant: useMatugen ? matugenTheme.colorOutlineVariant : defaultTheme.colorOutlineVariant
  property color colorShadow: useMatugen ? matugenTheme.colorShadow : defaultTheme.colorShadow


  // -----------
  // Check if we should use Matugen theme
  property bool useMatugen: Settings.data.wallpaper.generateTheme && matugenFile.loaded

  // -----------
  function applyOpacity(color, opacity) {
    // Convert color to string and apply opacity
    return color.toString().replace("#", "#" + opacity)
  }

  // --------------------------------
  // Default theme colors - RosePine
  QtObject {
    id: defaultTheme

    // // --- Key Colors: These are the main accent colors that define your app's theme.
    property color colorPrimary: "#000000" // The main brand color, used most frequently.
    property color colorOnPrimary: "#000000" // Color for text/icons on a Primary background.
    property color colorPrimaryContainer: "#000000" // A lighter/subtler tone of Primary, used for component backgrounds.
    property color colorOnPrimaryContainer: "#000000" // Color for text/icons on a Primary Container background.

    property color colorSecondary: "#000000" // An accent color for less prominent components.
    property color colorOnSecondary: "#000000" // Color for text/icons on a Secondary background.
    property color colorSecondaryContainer: "#000000" // A lighter/subtler tone of Secondary.
    property color colorOnSecondaryContainer: "#000000" // olor for text/icons on a Secondary Container background.

    property color colorTertiary: "#000000" // A contrasting accent color used for things like highlights or special actions.
    property color colorOnTertiary: "#000000" // Color for text/icons on a Tertiary background.
    property color colorTertiaryContainer: "#000000" // A lighter/subtler tone of Tertiary.
    property color colorOnTertiaryContainer: "#000000" // Color for text/icons on a Tertiary Container background.

    // --- Utility colorColors: These colors serve specific, universal purposes like indicating errors or providing neutral backgrounds.
    property color colorError: "#000000" // Indicates an error state.
    property color colorOnError: "#000000" // Color for text/icons on an Error background.
    property color colorErrorContainer: "#000000" // A lighter/subtler tone of Error.
    property color colorOnErrorContainer: "#000000" // Color for text/icons on an Error Container background.

    // --- Surface colorand Variant Colors: These provide additional options for surfaces and their contents, creating visual hierarchy.
    property color colorSurface: "#000000" // The color for component surfaces like cards, sheets, and menus.
    property color colorOnSurface: "#000000" // The primary color for text/icons on a Surface background.
    property color colorSurfaceVariant: "#000000" // A surface color with a slightly different tint for differentiation.
    property color colorOnSurfaceVariant: "#000000" // The color for less prominent text/icons on a Surface.
    property color colorInversePrimary: "#000000" // A primary color legible on an Inverse Surface, often used for call-to-action buttons.
    property color colorOutline: "#000000" // The color for component outlines, like text fields or buttons.
    property color colorOutlineVariant: "#000000" // A subtler outline color for decorative elements or dividers.
    property color colorShadow: "#000000" // The color used for shadows to create elevation.


    //   // property color colorBackground: "#191724"
    //   // property color colorSurface: "#1f1d2e"
    //   // property color colorSurfaceVariant: "#26233a"

    //   // property color surface: "#1b1927"
    //   // property color surfaceVariant: "#262337"

    //   // property color colorOnBackground: "#e0def4"
    //   // property color textSecondary: "#908caa"
    //   // property color textDisabled: "#6e6a86"

    //   // property color colorPrimary: "#ebbcba"
    //   // property color accentSecondary: "#31748f"
    //   // property color accentTertiary: "#9ccfd8"

    //   // property color error: "#eb6f92"
    //   // property color warning: "#f6c177"

    //   // property color hover: "#c4a7e7"

    //   // property color onAccent: "#191724"
    //   // property color outline: "#44415a"

    //   // property color shadow: "#191724"
    //   // property color overlay: "#191724"
  }

  // ----------------------------------------------------------------
  // Matugen theme colors (loaded from theme.json)
  QtObject {
    id: matugenTheme

    // --- Key Colors
    property color colorPrimary: matugenData.colorPrimary
    property color colorOnPrimary: matugenData.colorOnPrimary
    property color colorPrimaryContainer: matugenData.colorPrimaryContainer
    property color colorOnPrimaryContainer: matugenData.colorOnPrimaryContainer

    property color colorSecondary: matugenData.colorSecondary
    property color colorOnSecondary: matugenData.colorOnSecondary
    property color colorSecondaryContainer: matugenData.colorSecondaryContainer
    property color colorOnSecondaryContainer: matugenData.colorOnSecondaryContainer

    property color colorTertiary: matugenData.colorTertiary
    property color colorOnTertiary: matugenData.colorOnTertiary
    property color colorTertiaryContainer: matugenData.colorTertiaryContainer
    property color colorOnTertiaryContainer: matugenData.colorOnTertiaryContainer

    // --- Utility Colors
    property color colorError: matugenData.colorError
    property color colorOnError: matugenData.colorOnError
    property color colorErrorContainer: matugenData.colorErrorContainer
    property color colorOnErrorContainer: matugenData.colorOnErrorContainer

    // --- Surface and Variant Colors
    property color colorSurface: matugenData.colorSurface
    property color colorOnSurface: matugenData.colorOnSurface
    property color colorSurfaceVariant: matugenData.colorSurfaceVariant
    property color colorOnSurfaceVariant: matugenData.colorOnSurfaceVariant
    property color colorInversePrimary: matugenData.colorInversePrimary
    property color colorOutline: matugenData.colorOutline
    property color colorOutlineVariant: matugenData.colorOutlineVariant
    property color colorShadow: matugenData.colorShadow
  }

  // FileView to load Matugen theme data from colors.json
  FileView {
    id: matugenFile
    path: Settings.configDir + "colors.json"
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

      // --- Key Colors
      property color colorPrimary: defaultTheme.colorPrimary
      property color colorOnPrimary: defaultTheme.colorOnPrimary
      property color colorPrimaryContainer: defaultTheme.colorPrimaryContainer
      property color colorOnPrimaryContainer: defaultTheme.colorOnPrimaryContainer

      property color colorSecondary: defaultTheme.colorSecondary
      property color colorOnSecondary: defaultTheme.colorOnSecondary
      property color colorSecondaryContainer: defaultTheme.colorSecondaryContainer
      property color colorOnSecondaryContainer: defaultTheme.colorOnSecondaryContainer

      property color colorTertiary: defaultTheme.colorTertiary
      property color colorOnTertiary: defaultTheme.colorOnTertiary
      property color colorTertiaryContainer: defaultTheme.colorTertiaryContainer
      property color colorOnTertiaryContainer: defaultTheme.colorOnTertiaryContainer

      // --- Utility Colors
      property color colorError: defaultTheme.colorError
      property color colorOnError: defaultTheme.colorOnError
      property color colorErrorContainer: defaultTheme.colorErrorContainer
      property color colorOnErrorContainer: defaultTheme.colorOnErrorContainer

      // --- Surface and Variant Colors
      property color colorSurface: defaultTheme.colorSurface
      property color colorOnSurface: defaultTheme.colorOnSurface
      property color colorSurfaceVariant: defaultTheme.colorSurfaceVariant
      property color colorOnSurfaceVariant: defaultTheme.colorOnSurfaceVariant
      property color colorInversePrimary: defaultTheme.colorInversePrimary
      property color colorOutline: defaultTheme.colorOutline
      property color colorOutlineVariant: defaultTheme.colorOutlineVariant
      property color colorShadow: defaultTheme.colorShadow
    }
  }
}

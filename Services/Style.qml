pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root


  /*
    Preset sizes for font, radii, ?
    */

  // Font size
  property real fontSizeSmall: 9
  property real fontSizeMedium: 11
  property real fontSizeLarge: 13
  property real fontSizeXL: 18

  // Font weight / Unsure if we keep em?
  property int fontWeightRegular: 400
  property int fontWeightMedium: 500
  property int fontWeightBold: 700

  // Radii
  property int radiusLarge: 20
  property int radiusMedium: 16
  property int radiusSmall: 12

  // Border
  property int borderThin: 1
  property int borderMedium: 2
  property int borderThick: 3

  // Spacing
  property int spacingExtraLarge: 20
  property int spacingLarge: 16
  property int spacingMedium: 12
  property int spacingSmall: 8

  // Animation duration (ms)
  property int animationFast: 150
  property int animationNormal: 300
  property int animationSlow: 500

  property int barHeight: 36
  property int baseWidgetSize: 32
  property int sliderWidth: 200

  // Delay
  property int tooltipDelay: 300

  // Margins and spacing
  property int marginTiny: 4
  property int marginSmall: 8
  property int marginMedium: 12
  property int marginLarge: 16
  property int marginXL: 20

  // Opacity
  property real opacityLight: 0.25
  property real opacityMedium: 0.5
  property real opacityHeavy: 0.75
  property real opacityAlmost: 0.95
  property real opacityFull: 1.0
}

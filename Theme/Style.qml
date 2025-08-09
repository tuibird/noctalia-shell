pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root


  /*
    Preset sizes for font, radii, ?
    */

  // Font
  property real fontExtraLarge: 20
  property real fontLarge: 14
  property real fontMedium: 10
  property real fontSmall: 8

  // Font weight
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
  property int baseWidgetHeight: 32
}

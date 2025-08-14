import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import qs.Services

Slider {
  id: root

  readonly property real scaling: Scaling.scale(screen)
  readonly property real knobDiameter: Style.baseWidgetSize * 0.75 * scaling
  readonly property real trackHeight: knobDiameter * 0.5
  readonly property real cutoutExtra: Style.baseWidgetSize * 0.1 * scaling

  // Optional color to cut the track beneath the knob (should match surrounding background)
  property var cutoutColor
  property var screen
  property bool snapAlways: true

  snapMode: snapAlways ? Slider.SnapAlways : Slider.SnapOnRelease
  implicitHeight: Math.max(trackHeight, knobDiameter)

  background: Rectangle {
    x: root.leftPadding
    y: root.topPadding + root.availableHeight / 2 - height / 2
    implicitWidth: Style.sliderWidth
    implicitHeight: trackHeight
    width: root.availableWidth
    height: implicitHeight
    radius: height / 2
    color: Colors.colorSurface

    Rectangle {
      id: activeTrack
      width: root.visualPosition * parent.width
      height: parent.height
      color: Colors.colorPrimary
      radius: parent.radius
    }

    // Circular cutout
    Rectangle {
      id: knobCutout
      width: knobDiameter + cutoutExtra
      height: knobDiameter + cutoutExtra
      radius: width / 2
      color: root.cutoutColor !== undefined ? root.cutoutColor : Colors.colorSurface
      x: Math.max(0, Math.min(parent.width - width,
                              root.visualPosition * (parent.width - root.knobDiameter) - cutoutExtra / 2))
      y: (parent.height - height) / 2
    }
  }

  handle: Item {
    width: knob.implicitWidth
    height: knob.implicitHeight
    x: root.leftPadding + root.visualPosition * (root.availableWidth - width)
    y: root.topPadding + root.availableHeight / 2 - height / 2

    // Subtle shadow for a more polished look (keeps theme colors)
    MultiEffect {
      anchors.fill: knob
      source: knob
      shadowEnabled: true
      shadowColor: Colors.colorShadow
      shadowOpacity: 0.25
      shadowHorizontalOffset: 0
      shadowVerticalOffset: 1
      shadowBlur: 8
    }

    Rectangle {
      id: knob
      implicitWidth: knobDiameter
      implicitHeight: knobDiameter
      radius: width * 0.5
      color: root.pressed ? Colors.colorSurfaceVariant : Colors.colorSurface
      border.color: Colors.colorPrimary
      border.width: Math.max(1, Style.borderThick * scaling)

      // Press feedback halo (using accent color, low opacity)
      Rectangle {
        anchors.centerIn: parent
        width: parent.width + 8 * scaling
        height: parent.height + 8 * scaling
        radius: width / 2
        color: Colors.colorPrimary
        opacity: root.pressed ? 0.16 : 0.0
      }
    }
  }
}

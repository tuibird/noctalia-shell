import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import qs.Services

ColumnLayout {
  id: root

  readonly property real scaling: Scaling.scale(screen)
  readonly property real knobDiameter: Style.baseWidgetSize * 0.75 * scaling
  readonly property real trackHeight: knobDiameter * 0.5
  readonly property real cutoutExtra: Style.baseWidgetSize * 0.1 * scaling

  property string label: ""
  property string description: ""
  property string valueSuffix: ""
  property real from: 0.0
  property real to: 1.0
  property real stepSize: 0.01
  property real value: 0.0

  // Optional color to cut the track beneath the knob (should match surrounding background)
  property var cutoutColor
  property var screen
  property bool snapAlways: true

  signal pressedChanged(bool pressed, real value)
  signal moved(real value)

  Layout.fillWidth: true
  spacing: Style.marginSmall * scaling

  RowLayout {
    Layout.fillWidth: true

    ColumnLayout {
      spacing: Style.marginTiniest * scaling

      NText {
        text: label
        font.pointSize: Style.fontSizeMedium * scaling
        font.weight: Style.fontWeightBold
        color: Colors.textPrimary
        Layout.fillWidth: true
      }

      NText {
        text: description
        font.pointSize: Style.fontSizeSmall * scaling
        color: Colors.textSecondary
        wrapMode: Text.WordWrap
      }
    }

    NText {
      text: {
        var v
        if (Number.isInteger(value)) {
          v = value
        } else {
          v = value.toFixed(2)
        }

        if (valueSuffix != "") {
          return v + valueSuffix
        } else {
          return v
        }
      }
      font.pointSize: Style.fontSizeMedium * scaling
      font.weight: Style.fontWeightBold
      color: Colors.textPrimary
      Layout.alignment: Qt.AlignBottom | Qt.AlignRight
      
    }
  }

  Slider {
    id: slider

    Layout.fillWidth: true
    from: root.from
    to: root.to
    stepSize: root.stepSize
    value: root.value
    snapMode: snapAlways ? Slider.SnapAlways : Slider.SnapOnRelease
    implicitWidth: root.width
    implicitHeight: Math.max(trackHeight, knobDiameter)
    onPressedChanged: {
      root.pressedChanged(slider.pressed, slider.value)
    }
    onMoved: {
      root.value = slider.value
      root.moved(value)
    }

    background: Rectangle {
      x: slider.leftPadding
      y: slider.topPadding + slider.availableHeight / 2 - height / 2
      implicitWidth: Style.sliderWidth
      implicitHeight: trackHeight
      width: slider.availableWidth
      height: implicitHeight
      radius: height / 2
      color: Colors.surfaceVariant

      Rectangle {
        id: activeTrack
        width: slider.visualPosition * parent.width
        height: parent.height
        color: Colors.accentPrimary
        radius: parent.radius
      }

      // Circular cutout
      Rectangle {
        id: knobCutout
        width: knobDiameter + cutoutExtra
        height: knobDiameter + cutoutExtra
        radius: width / 2
        color: slider.cutoutColor !== undefined ? slider.cutoutColor : Colors.backgroundPrimary
        x: Math.max(0, Math.min(parent.width - width,
                                slider.visualPosition * (parent.width - knobDiameter) - cutoutExtra / 2))
        y: (parent.height - height) / 2
      }
    }

    handle: Item {
      width: knob.implicitWidth
      height: knob.implicitHeight
      x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
      y: slider.topPadding + slider.availableHeight / 2 - height / 2

      // Subtle shadow for a more polished look (keeps theme colors)
      MultiEffect {
        anchors.fill: knob
        source: knob
        shadowEnabled: true
        shadowColor: Colors.shadow
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
        color: slider.pressed ? Colors.surfaceVariant : Colors.surface
        border.color: Colors.accentPrimary
        border.width: Math.max(1, Style.borderThick * scaling)

        // Press feedback halo (using accent color, low opacity)
        Rectangle {
          anchors.centerIn: parent
          width: parent.width + 8 * scaling
          height: parent.height + 8 * scaling
          radius: width / 2
          color: Colors.accentPrimary
          opacity: slider.pressed ? 0.16 : 0.0
        }
      }
    }
  }
}

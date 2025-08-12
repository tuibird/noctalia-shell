import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import qs.Services

Rectangle {

  readonly property real scaling: Scaling.scale(screen)
  property string imagePath: ""
  property string fallbackIcon: ""

  anchors.fill: parent
  anchors.margins: Style.marginTiniest * scaling

  Image {
    id: img
    anchors.fill: parent
    source: imagePath
    visible: false
    mipmap: true
    smooth: true
    asynchronous: true
    fillMode: Image.PreserveAspectCrop
  }

  MultiEffect {
    anchors.fill: parent
    source: img
    maskEnabled: true
    maskSource: mask
    visible: imagePath !== ""
  }

  Item {
    id: mask
    anchors.fill: parent
    layer.enabled: true
    visible: false
    Rectangle {
      anchors.fill: parent
      radius: img.width * 0.5
    }
  }

  // Fallback icon
  NText {
    anchors.centerIn: parent
    text: fallbackIcon
    font.family: "Material Symbols Outlined"
    font.pointSize: Style.fontSizeXL * scaling
    visible: fallbackIcon !== undefined && fallbackIcon !== "" && (source === undefined || source === "")
    z: 0
  }
}

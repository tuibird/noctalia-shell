import QtQuick
import qs.Services

Item {
  id: root
  property color fillColor: Colors.accentPrimary
  property color strokeColor: Colors.textPrimary
  property int strokeWidth: 0
  property var values: []

  property real xScale: width / (values.length * 2)

  Repeater {
    model: values.length
    Rectangle {
      property real amp: values[values.length - 1 - index]

      color: fillColor
      border.color: strokeColor
      border.width: strokeWidth
      antialiasing: true

      x: index * xScale
      y: root.height - height

      width: xScale * 0.5
      height: root.height * amp

      Behavior on height {
        SmoothedAnimation {
          duration: 5
        }
      }
    }
  }

  Repeater {
    model: values.length
    Rectangle {
      property real amp: values[index]

      color: fillColor
      border.color: strokeColor
      border.width: strokeWidth
      antialiasing: true

      x: (values.length + index) * xScale
      y: root.height - height

      width: xScale * 0.5
      height: root.height * amp

      Behavior on height {
        SmoothedAnimation {
          duration: 5
        }
      }
    }
  }

}

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Theme

RowLayout {
  id: root

  // Local scale convenience with safe fallback
  readonly property real scale: (typeof screen !== 'undefined'
                                 && screen) ? Theme.scale(screen) : 1.0

  property string label: ""
  property string description: ""
  property bool value: false
  property var onToggled: function () {}

  Layout.fillWidth: true

  ColumnLayout {
    spacing: 4 * scale
    Layout.fillWidth: true

    Text {
      text: label
      font.pixelSize: 13 * scale
      font.bold: true
      color: Theme.textPrimary
    }

    Text {
      text: description
      font.pixelSize: 12 * scale
      color: Theme.textSecondary
      wrapMode: Text.WordWrap
      Layout.fillWidth: true
    }
  }

  Rectangle {
    id: switcher

    width: 52 * scale
    height: 32 * scale
    radius: height / 2
    color: value ? Theme.accentPrimary : Theme.surfaceVariant
    border.color: value ? Theme.accentPrimary : Theme.outline
    border.width: 2 * scale

    Rectangle {
      width: 28 * scale
      height: 28 * scale
      radius: height / 2
      color: Theme.surface
      border.color: Theme.outline
      border.width: 1 * scale
      y: 2 * scale
      x: value ? switcher.width - width - 2 * scale : 2 * scale

      Behavior on x {
        NumberAnimation {
          duration: 200
          easing.type: Easing.OutCubic
        }
      }
    }

    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.PointingHandCursor
      onClicked: {
        root.onToggled()
      }
    }
  }
}

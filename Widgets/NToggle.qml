import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Services

RowLayout {
  id: root

  readonly property real scaling: Scaling.scale(screen)
  property string label: ""
  property string description: ""
  property bool value: false
  property bool hovering: false
  property int baseSize: Style.baseWidgetSize
  property var onToggled: function (value) {}

  Layout.fillWidth: true

  ColumnLayout {
    spacing: 2 * scaling
    Layout.fillWidth: true

    NText {
      text: label
      font.pointSize: Style.fontSizeMedium * scaling
      font.weight: Style.fontWeightBold
      color: Colors.textPrimary
    }

    NText {
      text: description
      font.pointSize: Style.fontSizeSmall * scaling
      color: Colors.textSecondary
      wrapMode: Text.WordWrap
      Layout.fillWidth: true
    }
  }

  Rectangle {
    id: switcher

    implicitWidth: root.baseSize * 1.625 * scaling
    implicitHeight: root.baseSize * scaling
    radius: height * 0.5
    color: value ? Colors.accentPrimary : Colors.surfaceVariant
    border.color: value ? Colors.accentPrimary : Colors.outline
    border.width: Math.max(1, Style.borderMedium * scaling)

    Rectangle {
      implicitWidth: (root.baseSize - 4) * scaling
      implicitHeight: (root.baseSize - 4) * scaling
      radius: height * 0.5
      color: Colors.surface
      border.color: hovering ? Colors.textDisabled : Colors.outline
      border.width: Math.max(1, Style.borderMedium * scaling)
      y: 2 * scaling
      x: value ? switcher.width - width - 2 * scaling : 2 * scaling

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
      hoverEnabled: true
      onEntered: hovering = true
      onExited: hovering = false
      onClicked: {
        value = !value
        root.onToggled(value)
      }
    }
  }
}

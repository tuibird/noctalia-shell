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
  property var onToggled: function (value: bool) {}

  Layout.fillWidth: true

  ColumnLayout {
    spacing: 2 * scaling
    Layout.fillWidth: true

    Text {
      text: label
      font.pointSize: Style.fontMedium * scaling
      font.bold: true
      color: Colors.textPrimary
    }

    Text {
      text: description
      font.pointSize: Style.fontSmall * scaling
      color: Colors.textSecondary
      wrapMode: Text.WordWrap
      Layout.fillWidth: true
    }
  }

  Rectangle {
    id: switcher

    width: Style.baseWidgetHeight * 1.625 * scaling
    height: Style.baseWidgetHeight * scaling
    radius: height * 0.5
    color: value ? Colors.accentPrimary :Colors.surfaceVariant
    border.color: value ? Colors.accentPrimary : Colors.outline
    border.width: Math.max(1, 1.5 * scale)

    Rectangle {
      width: (Style.baseWidgetHeight- 4) * scaling
      height: (Style.baseWidgetHeight - 4) * scaling
      radius: height * 0.5
      color: Colors.surface
      border.color: hovering ? Colors.textDisabled : Colors.outline
      border.width: Math.max(1, 1.5 * scale)
      y: 2 * scaling
      x: value ? switcher.width - width - 2 * scale : 2 * scaling

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
        value = !value;
        root.onToggled(value);
      }
    }
  }
}

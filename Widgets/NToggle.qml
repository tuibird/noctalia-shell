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
      color: Theme.textPrimary
    }

    Text {
      text: description
      font.pointSize: Style.fontSmall * scaling
      color: Theme.textSecondary
      wrapMode: Text.WordWrap
      Layout.fillWidth: true
    }
  }

  Rectangle {
    id: switcher

    width: Style.baseWidgetHeight * 1.625 * scaling
    height: Style.baseWidgetHeight * scaling
    radius: height * 0.5
    color: value ? Theme.accentPrimary :Theme.surfaceVariant
    border.color: value ? Theme.accentPrimary : Theme.outline
    border.width: Math.max(1, 1.5 * scale)

    Rectangle {
      width: (Style.baseWidgetHeight- 4) * scaling
      height: (Style.baseWidgetHeight - 4) * scaling
      radius: height * 0.5
      color: Theme.surface
      border.color: hovering ? Theme.textDisabled : Theme.outline
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

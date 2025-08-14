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

  signal toggled(bool balue)
  signal entered
  signal exited

  Layout.fillWidth: true

  ColumnLayout {
    spacing: Style.marginTiniest * scaling
    Layout.fillWidth: true

    NText {
      text: label
      font.pointSize: Style.fontSizeMedium * scaling
      font.weight: Style.fontWeightBold
      color: Colors.colorOnSurface
    }

    NText {
      text: description
      font.pointSize: Style.fontSizeSmall * scaling
      color: Colors.colorOnSurface
      wrapMode: Text.WordWrap
      Layout.fillWidth: true
    }
  }

  Rectangle {
    id: switcher

    implicitWidth: root.baseSize * 1.625 * scaling
    implicitHeight: root.baseSize * scaling
    radius: height * 0.5
    color: value ? Colors.colorPrimary : Colors.colorSurface
    border.color: value ? Colors.colorPrimary : Colors.colorOutline
    border.width: Math.max(1, Style.borderMedium * scaling)

    Rectangle {
      implicitWidth: (root.baseSize - 5) * scaling
      implicitHeight: (root.baseSize - 5) * scaling
      radius: height * 0.5
      color: value ? Colors.colorOnSurface : Colors.colorPrimary //Colors.onBackground : Colors.colorSecondary
      border.color: value ? Colors.colorSurface : Colors.colorSurface
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
      onEntered: {
        hovering = true
        root.entered()
      }
      onExited: {
        hovering = false
        root.exited()
      }
      onClicked: {
        value = !value
        root.toggled(value)
      }
    }
  }
}

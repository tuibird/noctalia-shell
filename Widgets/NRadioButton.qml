import QtQuick
import QtQuick.Controls
import qs.Services
import qs.Widgets

RadioButton {
  id: root

  indicator: Rectangle {
    id: outerCircle

    implicitWidth: 20 * scaling
    implicitHeight: 20 * scaling
    radius: width * 0.5
    color: "transparent"
    border.color: root.checked ? Colors.accentPrimary : Colors.textPrimary
    border.width: 2
    anchors.verticalCenter: parent.verticalCenter

    Rectangle {
      anchors.centerIn: parent
      implicitWidth: Style.marginSmall * scaling
      implicitHeight: Style.marginSmall * scaling

      radius: width * 0.5
      color: Qt.alpha(Colors.accentPrimary, root.checked ? 1 : 0)
    }

    Behavior on border.color {
      ColorAnimation {
        duration: Style.animationNormal
        easing.type: Easing.InQuad
      }
    }
  }

  contentItem: NText {
    text: root.text
    font.pointSize: Style.fontSizeMedium * scaling
    anchors.verticalCenter: parent.verticalCenter
    anchors.left: outerCircle.right
    anchors.leftMargin: Style.marginSmall * scaling
  }
}

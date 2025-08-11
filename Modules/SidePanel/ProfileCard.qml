import QtQuick
import QtQuick.Layouts
import Quickshell
import QtQuick.Effects
import qs.Services
import qs.Widgets

// Header card with avatar, user and quick actions
NBox {
  id: root

  readonly property real scaling: Scaling.scale(screen)

  Layout.fillWidth: true
  // Height driven by content
  implicitHeight: content.implicitHeight + Style.marginMedium * 2 * scaling

  RowLayout {
    id: content
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.margins: Style.marginMedium * scaling
    spacing: Style.marginMedium * scaling

    Item {
      id: avatarBox
      width: Style.baseWidgetSize * 1.25 * scaling
      height: Style.baseWidgetSize * 1.25 * scaling

      Image {
        id: avatarImage
        anchors.fill: parent
        source: Settings.data.general.avatarImage
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
      }

      // Ensure rounded corners consistently across renderers
      MultiEffect {
        anchors.fill: avatarImage
        source: avatarImage
        maskEnabled: true
        maskSource: Rectangle {
          anchors.fill: parent
          color: "white"
          radius: Style.radiusMedium * scaling
        }
      }
    }

    ColumnLayout {
      Layout.fillWidth: true
      spacing: 2 * scaling
      NText {
        text: Quickshell.env("USER") || "user"
        font.weight: Style.fontWeightBold
      }
      NText {
        text: "System Uptime: —"
        color: Colors.textSecondary
      }
    }

    RowLayout {
      spacing: Style.marginSmall * scaling
      Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
      Item {
        Layout.fillWidth: true
      }
      NIconButton {
        icon: "settings"
        sizeMultiplier: 0.9
      }
      NIconButton {
        icon: "power_settings_new"
        sizeMultiplier: 0.9
      }
    }
  }
}

import QtQuick
import Quickshell
import QtQuick.Controls
import QtQuick.Layouts
import qs.Widgets
import qs.Services

PanelWindow {
  id: root

  readonly property real scaling: Scaling.scale(screen)
  property var modelData

  screen: modelData
  implicitHeight: Style.barHeight * scaling
  color: "transparent"
  visible: Settings.settings.barMonitors.includes(modelData.name)
           || (Settings.settings.barMonitors.length === 0)

  anchors {
    top: true
    left: true
    right: true
  }

  Item {
    anchors.fill: parent
    clip: true

    // Background fill
    Rectangle {
      id: bar
      anchors.fill: parent
      color: Colors.backgroundPrimary
      layer.enabled: true
    }

    Row {
      id: leftSection
      height: parent.height
      anchors.left: parent.left
      anchors.leftMargin: Style.marginMedium * scaling
      anchors.verticalCenter: parent.verticalCenter
      spacing: Style.marginMedium * scaling

      NText {
        text: "Left"
      }
    }

    Row {
      id: centerSection
      height: parent.height
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.verticalCenter: parent.verticalCenter
      spacing: Style.marginMedium * scaling

      NText {
        text: "Center"
      }
    }

    Row {
      id: rightSection
      height: parent.height
      anchors.right: bar.right
      anchors.rightMargin: Style.marginMedium * scaling
      anchors.verticalCenter: bar.verticalCenter
      spacing: Style.marginMedium * scaling

      NText {
        text: "Right"
        Layout.alignment: Qt.AlignVCenter
      }

      Clock {}

      NIconButton {
        id: demoPanelToggler
        icon: "experiment"
        onClicked: function () {
          demoPanel.visible ? demoPanel.hide() : demoPanel.show()
        }
      }
    }
  }
}

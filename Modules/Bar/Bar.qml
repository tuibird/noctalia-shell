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
  visible: Settings.data.bar.monitors.includes(modelData.name)
           || (Settings.data.bar.monitors.length === 0)

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
      anchors.leftMargin: Style.marginSmall * scaling
      anchors.verticalCenter: parent.verticalCenter
      spacing: Style.marginSmall * scaling

      NText {
        text: screen.name
        anchors.verticalCenter: parent.verticalCenter
      }
    }

    Row {
      id: centerSection
      height: parent.height
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.verticalCenter: parent.verticalCenter
      spacing: Style.marginSmall * scaling

      Workspace {}
    }

    Row {
      id: rightSection
      height: parent.height
      anchors.right: bar.right
      anchors.rightMargin: Style.marginSmall * scaling
      anchors.verticalCenter: bar.verticalCenter
      spacing: Style.marginSmall * scaling

      NText {
        text: "Right"
        anchors.verticalCenter: parent.verticalCenter
      }

      Clock {
        anchors.verticalCenter: parent.verticalCenter
      }

      NIconButton {
        id: demoPanelToggle
        icon: "experiment"
        fontPointSize: Style.fontSizeMedium
        anchors.verticalCenter: parent.verticalCenter
        onClicked: function () {
          demoPanel.isLoaded = !demoPanel.isLoaded
        }
      }

      NIconButton {
        id: sidePanelToggle
        icon: "widgets"
        fontPointSize: Style.fontSizeMedium
        anchors.verticalCenter: parent.verticalCenter
        onClicked: function () {
          sidePanel.isLoaded = !demoPanel.isLoaded
        }
      }
    }
  }
}

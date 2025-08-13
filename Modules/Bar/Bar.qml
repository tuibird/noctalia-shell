import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.Services
import qs.Widgets
import qs.Modules.Notification

Variants {
  model: Quickshell.screens

  delegate: PanelWindow {
    id: root

    required property ShellScreen modelData
    readonly property real scaling: Scaling.scale(screen)

    property var settingsPanel: null

    screen: modelData
    implicitHeight: Style.barHeight * scaling
    color: "transparent"
    visible: modelData ? (Settings.data.bar.monitors.includes(modelData.name)
                          || (Settings.data.bar.monitors.length === 0)) : false

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

      // Left
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
          font.weight: Style.fontWeightBold
        }
      }

      // Center
      Row {
        id: centerSection

        height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        spacing: Style.marginSmall * scaling

        Workspace {}
      }

      // Right
      Row {
        id: rightSection

        height: parent.height
        anchors.right: bar.right
        anchors.rightMargin: Style.marginSmall * scaling
        anchors.verticalCenter: bar.verticalCenter
        spacing: Style.marginSmall * scaling

        Tray {
          anchors.verticalCenter: parent.verticalCenter
        }

        // TODO: Notification Icon
        NotificationHistory {
          anchors.verticalCenter: parent.verticalCenter
        }

        WiFi {
          anchors.verticalCenter: parent.verticalCenter
        }

        // Bluetooth {
        //     anchors.verticalCenter: parent.verticalCenter
        // }
        Battery {
          anchors.verticalCenter: parent.verticalCenter
        }

        Volume {
          anchors.verticalCenter: parent.verticalCenter
        }

        Clock {
          anchors.verticalCenter: parent.verticalCenter
        }

        NIconButton {
          id: demoPanelToggle
          icon: "experiment"
          tooltipText: "Open demo panel"
          sizeMultiplier: 0.8
          showBorder: false
          anchors.verticalCenter: parent.verticalCenter
          onClicked: {
            demoPanel.isLoaded = !demoPanel.isLoaded
          }
        }

        NIconButton {
          id: sidePanelToggle
          icon: "widgets"
          tooltipText: "Open side panel"
          sizeMultiplier: 0.8
          showBorder: false
          anchors.verticalCenter: parent.verticalCenter
          onClicked: {
            // Map this button's center to the screen and open the side panel below it
            const localCenterX = width / 2
            const localCenterY = height / 2
            const globalPoint = mapToItem(null, localCenterX, localCenterY)
            if (sidePanel.isLoaded)
              sidePanel.isLoaded = false
            else if (sidePanel.openAt)
              sidePanel.openAt(globalPoint.x, screen)
            else
              // Fallback: toggle if API unavailable
              sidePanel.isLoaded = true
          }
        }
      }
    }
  }
}

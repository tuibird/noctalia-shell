import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import qs.Services
import qs.Widgets

Row {
  readonly property real scaling: Scaling.scale(screen)
  property bool containsMouse: false
  property var systemTray: SystemTray

  spacing: 8
  Layout.alignment: Qt.AlignVCenter

  Repeater {
    model: systemTray.items
    delegate: Item {
      width: 24 * scaling
      height: 24 * scaling

      visible: modelData
      property bool isHovered: trayMouseArea.containsMouse

      // No animations - static display
      Rectangle {
        anchors.centerIn: parent
        width: 16 * scaling
        height: 16 * scaling
        radius: 6
        color: "transparent"
        clip: true

        IconImage {
          id: trayIcon
          anchors.centerIn: parent
          width: 16 * scaling
          height: 16 * scaling
          smooth: false
          asynchronous: true
          backer.fillMode: Image.PreserveAspectFit
          source: {
            let icon = modelData?.icon || ""
            if (!icon) {
              return ""
            }

            // Process icon path
            if (icon.includes("?path=")) {
              const chunks = icon.split("?path=")
              const name = chunks[0]
              const path = chunks[1]
              const fileName = name.substring(name.lastIndexOf("/") + 1)
              return `file://${path}/${fileName}`
            }
            return icon
          }
          opacity: status === Image.Ready ? 1 : 0
        }
      }

      MouseArea {
        id: trayMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        onClicked: mouse => {
                     if (!modelData)
                     return

                     if (mouse.button === Qt.LeftButton) {
                       // Close any open menu first
                       if (trayMenu && trayMenu.visible) {
                         trayMenu.hideMenu()
                       }

                       if (!modelData.onlyMenu) {
                         modelData.activate()
                       }
                     } else if (mouse.button === Qt.MiddleButton) {
                       // Close any open menu first
                       if (trayMenu && trayMenu.visible) {
                         trayMenu.hideMenu()
                       }

                       modelData.secondaryActivate && modelData.secondaryActivate()
                     } else if (mouse.button === Qt.RightButton) {
                       trayTooltip.tooltipVisible = false
                       // If menu is already visible, close it
                       if (trayMenu && trayMenu.visible) {
                         trayMenu.hideMenu()
                         return
                       }

                       if (modelData.hasMenu && modelData.menu && trayMenu) {
                         // Anchor the menu to the tray icon item (parent) and position it below the icon
                         const menuX = (width / 2) - (trayMenu.width / 2)
                         const menuY = height + 20 * scaling
                         trayMenu.menu = modelData.menu
                         trayMenu.showAt(parent, menuX, menuY)
                       } else {

                         console.log("Tray: no menu available for", modelData.id, "or trayMenu not set")
                       }
                     }
                   }
        onEntered: trayTooltip.show()
        onExited: trayTooltip.hide()
      }

      NTooltip {
        id: trayTooltip
        target: trayIcon
        text: modelData.tooltipTitle || modelData.name || modelData.id || "Tray Item"
      }
    }
  }
}

import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import qs.Services
import qs.Widgets

Item {
  readonly property real scaling: Scaling.scale(screen)
  readonly property real itemSize: 24 * scaling

  width: tray.width
  height: itemSize

  Row {
    id: tray

    spacing: Style.marginSmall * scaling
    Layout.alignment: Qt.AlignVCenter

    Repeater {
      id: repeater
      model: SystemTray.items
      delegate: Item {
        width: itemSize
        height: itemSize
        visible: modelData

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
              // Seems qmlfmt does not support the following ES6 syntax: const[name, path] = icon.split
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

        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
          onClicked: mouse => {
                       if (!modelData) {
                         return
                       }

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
                         trayTooltip.hide()
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

  // Attached TrayMenu
  TrayMenu {
    id: trayMenu
  }
}

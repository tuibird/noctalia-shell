import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import qs.Services
import qs.Widgets

NLoader {
  isLoaded: Settings.data.general.showDock
  content: Component {
    Variants {
      model: Quickshell.screens

      Item {
        property var modelData
        readonly property real scaling: Scaling.scale(modelData)

        // Auto-hide properties
        property bool autoHide: Settings.data.general.dockAutoHide
        property bool hidden: autoHide // Start hidden only if auto-hide is enabled
        property int hideDelay: 500
        property int showDelay: 100
        property int hideAnimationDuration: 200
        property int showAnimationDuration: 150
        property int peekHeight: 2
        property int fullHeight: dockContainer.height

        // Track hover state
        property bool dockHovered: false
        property bool anyAppHovered: false

        // Context menu properties
        property bool contextMenuVisible: false
        property var contextMenuTarget: null
        property var contextMenuToplevel: null

        PanelWindow {
          id: dockWindow
          visible: true
          screen: modelData
          exclusionMode: ExclusionMode.Ignore
          anchors.bottom: true
          anchors.left: true
          anchors.right: true
          focusable: false
          color: "transparent"
          implicitHeight: 60

          // Timer for auto-hide delay
          Timer {
            id: hideTimer
            interval: hideDelay
            onTriggered: if (autoHide && !dockHovered && !anyAppHovered)
                           hidden = true
          }

          // Timer for show delay
          Timer {
            id: showTimer
            interval: showDelay
            onTriggered: hidden = false
          }

          // Behavior for smooth hide/show animations
          Behavior on margins.bottom {
            NumberAnimation {
              duration: hidden ? hideAnimationDuration : showAnimationDuration
              easing.type: Easing.InOutQuad
            }
          }

          // Mouse area at screen bottom to detect entry and keep dock visible
          MouseArea {
            id: screenEdgeMouseArea
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 10
            hoverEnabled: true
            propagateComposedEvents: true

            onEntered: if (autoHide && hidden)
                         showTimer.start()
            onExited: if (autoHide && !hidden && !dockHovered && !anyAppHovered)
                        hideTimer.start()
          }

          margins.bottom: hidden ? -(fullHeight - peekHeight) : 0

          MouseArea {
            anchors.fill: parent
            enabled: contextMenuVisible
            onClicked: {
              contextMenuVisible = false
              contextMenuTarget = null
              contextMenuToplevel = null
            }
          }

          Rectangle {
            id: dockContainer
            width: dock.width + 40
            height: 50
            color: Colors.colorSurface
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            topLeftRadius: 20
            topRightRadius: 20

            MouseArea {
              id: dockMouseArea
              anchors.fill: parent
              hoverEnabled: true
              propagateComposedEvents: true

              onEntered: {
                dockHovered = true
                if (autoHide) {
                  showTimer.stop()
                  hideTimer.stop()
                  hidden = false
                }
              }
              onExited: {
                dockHovered = false
                if (autoHide && !anyAppHovered && !contextMenuVisible)
                  hideTimer.start()
              }
            }

            Item {
              id: dock
              width: runningAppsRow.width
              height: parent.height - 10
              anchors.centerIn: parent

              NTooltip {
                id: appTooltip
                visible: false
                positionAbove: true
              }

              function getAppIcon(toplevel: Toplevel): string {
                if (!toplevel)
                  return ""
                let icon = Quickshell.iconPath(toplevel.appId?.toLowerCase(), true)
                if (!icon)
                  icon = Quickshell.iconPath(toplevel.appId, true)
                if (!icon)
                  icon = Quickshell.iconPath(toplevel.title?.toLowerCase(), true)
                if (!icon)
                  icon = Quickshell.iconPath(toplevel.title, true)
                return icon || Quickshell.iconPath("application-x-executable", true)
              }

              Row {
                id: runningAppsRow
                spacing: 8
                height: parent.height
                anchors.centerIn: parent

                Repeater {
                  model: ToplevelManager ? ToplevelManager.toplevels : null

                  delegate: Rectangle {
                    id: appButton
                    width: 36
                    height: 36
                    radius: 18
                    color: "transparent"

                    property bool isActive: ToplevelManager.activeToplevel
                                            && ToplevelManager.activeToplevel === modelData
                    property bool hovered: appMouseArea.containsMouse
                    property string appId: modelData ? modelData.appId : ""
                    property string appTitle: modelData ? modelData.title : ""

                    Behavior on color {
                      ColorAnimation {
                        duration: 150
                      }
                    }

                    Image {
                      id: appIcon
                      width: 28
                      height: 28
                      anchors.centerIn: parent
                      source: dock.getAppIcon(modelData)
                      visible: source.toString() !== ""
                      smooth: false
                      mipmap: false
                      antialiasing: false
                      fillMode: Image.PreserveAspectFit
                    }

                    Text {
                      anchors.centerIn: parent
                      visible: !appIcon.visible
                      text: appButton.appId ? appButton.appId.charAt(0).toUpperCase() : "?"
                      font.pixelSize: 14
                      font.bold: true
                      color: appButton.isActive ? Colors.colorPrimary : Colors.colorOnSurface
                    }

                    MouseArea {
                      id: appMouseArea
                      anchors.fill: parent
                      hoverEnabled: true
                      cursorShape: Qt.PointingHandCursor
                      acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

                      onEntered: {
                        anyAppHovered = true
                        const appName = appButton.appTitle || appButton.appId || "Unknown"
                        appTooltip.text = appName.length > 40 ? appName.substring(0, 37) + "..." : appName
                        appTooltip.target = appButton
                        appTooltip.isVisible = true
                        if (autoHide) {
                          showTimer.stop()
                          hideTimer.stop()
                          hidden = false
                        }
                      }

                      onExited: {
                        anyAppHovered = false
                        appTooltip.hide()
                        if (autoHide && !dockHovered && !contextMenuVisible)
                          hideTimer.start()
                      }

                      onClicked: function (mouse) {
                        if (mouse.button === Qt.MiddleButton && modelData?.close) {
                          modelData.close()
                        }
                        if (mouse.button === Qt.LeftButton && modelData?.activate) {
                          modelData.activate()
                        }
                        if (mouse.button === Qt.RightButton) {
                          appTooltip.hide()
                          contextMenuTarget = appButton
                          contextMenuToplevel = modelData
                          contextMenuVisible = true
                        }
                      }
                    }

                    Rectangle {
                      visible: isActive
                      width: 20
                      height: 3
                      color: Colors.colorPrimary
                      radius: 1.5
                      anchors.bottom: parent.bottom
                      anchors.horizontalCenter: parent.horizontalCenter
                      anchors.bottomMargin: 2
                    }
                  }
                }
              }
            }
          }

          // Context Menu
          PanelWindow {
            id: contextMenuWindow
            visible: contextMenuVisible
            screen: dockWindow.screen
            exclusionMode: ExclusionMode.Ignore
            anchors.bottom: true
            anchors.left: true
            anchors.right: true
            color: "transparent"
            focusable: false

            MouseArea {
              anchors.fill: parent
              onClicked: {
                contextMenuVisible = false
                contextMenuTarget = null
                contextMenuToplevel = null
                hidden = true // Hide dock when context menu closes
              }
            }

            Rectangle {
              id: contextMenuContainer
              width: 80
              height: 32
              radius: 8
              color: closeMouseArea.containsMouse ? Colors.colorTertiary : Colors.colorSurface
              border.color: Colors.colorOutline
              border.width: 1

              x: {
                if (!contextMenuTarget)
                  return 0
                const pos = contextMenuTarget.mapToItem(null, 0, 0)
                let xPos = pos.x + (contextMenuTarget.width - width) / 2
                return Math.max(0, Math.min(xPos, dockWindow.width - width))
              }

              y: {
                if (!contextMenuTarget)
                  return 0
                const pos = contextMenuTarget.mapToItem(null, 0, 0)
                return pos.y - height + 32
              }

              Text {
                anchors.centerIn: parent
                text: "Close"
                font.pixelSize: 14
                color: Colors.colorOnSurface
              }

              MouseArea {
                id: closeMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                  if (contextMenuToplevel?.close)
                    contextMenuToplevel.close()
                  contextMenuVisible = false
                  hidden = true
                }
              }

              // Animation
              scale: contextMenuVisible ? 1 : 0.9
              opacity: contextMenuVisible ? 1 : 0
              transformOrigin: Item.Bottom

              Behavior on scale {
                NumberAnimation {
                  duration: 150
                  easing.type: Easing.OutBack
                }
              }

              Behavior on opacity {
                NumberAnimation {
                  duration: 100
                }
              }
            }
          }
        }
      }
    }
  }
}

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import qs.Commons
import qs.Services
import qs.Widgets

NLoader {
  isLoaded: (Settings.data.dock.monitors.length > 0)
  content: Component {
    Variants {
      model: Quickshell.screens

      PanelWindow {
        id: dockWindow

        required property ShellScreen modelData
        readonly property real scaling: ScalingService.scale(screen)
        screen: modelData

        // Auto-hide properties - make reactive to settings changes
        property bool autoHide: Settings.data.dock.autoHide
        property bool hidden: autoHide
        property int hideDelay: 500
        property int showDelay: 100
        property int hideAnimationDuration: Style.animationFast
        property int showAnimationDuration: Style.animationFast
        property int peekHeight: 2
        property int fullHeight: dockContainer.height
        property int iconSize: 36

        // Track hover state
        property bool dockHovered: false
        property bool anyAppHovered: false

        // Context menu properties
        property bool contextMenuVisible: false
        property var contextMenuTarget: null
        property var contextMenuToplevel: null

        // Dock is only shown if explicitely toggled
        visible: modelData ? Settings.data.dock.monitors.includes(modelData.name) : false

        exclusionMode: ExclusionMode.Ignore

        anchors.bottom: true
        anchors.left: true
        anchors.right: true
        focusable: false
        color: "transparent"
        implicitHeight: iconSize * 1.4 * scaling

        // Watch for autoHide setting changes
        onAutoHideChanged: {
          if (!autoHide) {
            // If auto-hide is disabled, show the dock
            hidden = false
            hideTimer.stop()
            showTimer.stop()
          } else {
            // If auto-hide is enabled, start hidden
            hidden = true
          }
        }

        // Timer for auto-hide delay
        Timer {
          id: hideTimer
          interval: hideDelay
          onTriggered: {
            if (autoHide && !dockHovered && !anyAppHovered) {
              hidden = true
            }
          }
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

        MouseArea {
          id: screenEdgeMouseArea
          x: 0
          y: modelData.geometry.height - (fullHeight + 10 * scaling)
          width: screen.width
          height: fullHeight + 10 * scaling
          hoverEnabled: true
          propagateComposedEvents: true

          onEntered: {
            if (autoHide && hidden) {
              showTimer.start()
            }
          }
          onExited: {
            if (autoHide && !hidden && !dockHovered && !anyAppHovered && !contextMenuVisible) {
              hideTimer.start()
            }
          }
        }

        margins.bottom: hidden ? -(fullHeight - peekHeight) : 0

        // Global click handler to close context menu
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
          width: dock.width + 48 * scaling
          height: iconSize * 1.4 * scaling
          color: Colors.mSurface
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.bottom: parent.bottom
          topLeftRadius: Style.radiusLarge * scaling
          topRightRadius: Style.radiusLarge * scaling

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
              // Only start hide timer if we're not hovering over any app or context menu
              if (autoHide && !anyAppHovered && !contextMenuVisible) {
                hideTimer.start()
              }
            }
          }

          Item {
            id: dock
            width: runningAppsRow.width
            height: parent.height - (20 * scaling)
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
              spacing: Style.marginLarge * scaling
              height: parent.height
              anchors.centerIn: parent

              Repeater {
                model: ToplevelManager ? ToplevelManager.toplevels : null

                delegate: Rectangle {
                  id: appButton
                  width: iconSize * scaling
                  height: iconSize * scaling
                  color: "transparent"
                  radius: Style.radiusMedium * scaling

                  property bool isActive: ToplevelManager.activeToplevel && ToplevelManager.activeToplevel === modelData
                  property bool hovered: appMouseArea.containsMouse
                  property string appId: modelData ? modelData.appId : ""
                  property string appTitle: modelData ? modelData.title : ""

                  // Hover background
                  Rectangle {
                    id: hoverBackground
                    anchors.fill: parent
                    color: appButton.hovered ? Colors.mSurfaceVariant : "transparent"
                    radius: parent.radius
                    opacity: appButton.hovered ? 0.8 : 0
                    
                    Behavior on opacity {
                      NumberAnimation {
                        duration: Style.animationFast
                        easing.type: Easing.OutQuad
                      }
                    }
                  }

                  // The icon
                  Image {
                    id: appIcon
                    width: iconSize * scaling
                    height: iconSize * scaling
                    anchors.centerIn: parent
                    source: dock.getAppIcon(modelData)
                    visible: source.toString() !== ""
                    smooth: true
                    mipmap: false
                    antialiasing: false
                    fillMode: Image.PreserveAspectFit
                    
                    scale: appButton.hovered ? 1.1 : 1.0
                    
                    Behavior on scale {
                      NumberAnimation {
                        duration: Style.animationFast
                        easing.type: Easing.OutBack
                      }
                    }
                  }

                  // Fall back if no icon
                  NText {
                    anchors.centerIn: parent
                    visible: !appIcon.visible
                    text: "question_mark"
                    font.family: "Material Symbols Rounded"
                    font.pointSize: iconSize * 0.7 * scaling
                    color: appButton.isActive ? Colors.mPrimary : Colors.mOnSurfaceVariant
                    
                    scale: appButton.hovered ? 1.1 : 1.0
                    
                    Behavior on scale {
                      NumberAnimation {
                        duration: Style.animationFast
                        easing.type: Easing.OutBack
                      }
                    }
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
                      // Only start hide timer if we're not hovering over the dock or context menu
                      if (autoHide && !dockHovered && !contextMenuVisible) {
                        hideTimer.start()
                      }
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
                    width: iconSize * 0.75
                    height: 4 * scaling
                    color: Colors.mPrimary
                    radius: Style.radiusTiny
                    anchors.top: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.topMargin: Style.marginTiniest * scaling
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
              if (autoHide) {
                // Stop any pending show/hide timers to prevent flickering
                showTimer.stop()
                hideTimer.stop()
                // Add a small delay before hiding to prevent immediate show/hide cycle
                Qt.callLater(function() {
                  if (autoHide && !dockHovered && !anyAppHovered) {
                    hidden = true
                  }
                })
              }
            }
          }

          Rectangle {
            id: contextMenuContainer
            width: Style.baseWidgetSize * 2.5 * scaling
            height: Style.baseWidgetSize * scaling
            radius: Style.radiusTiny * scaling
            color: closeMouseArea.containsMouse ? Colors.mTertiary : Colors.mSurface
            border.color: Colors.mOutline
            border.width: Math.max(1, Style.borderThin * scaling)

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
              font.pointSize: Style.fontSizeMedium * scaling
              color: closeMouseArea.containsMouse ? Colors.mOnTertiary : Colors.mOnSurface
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
                contextMenuTarget = null
                contextMenuToplevel = null
                if (autoHide) {
                  // Stop any pending show/hide timers to prevent flickering
                  showTimer.stop()
                  hideTimer.stop()
                  // Add a small delay before hiding to prevent immediate show/hide cycle
                  Qt.callLater(function() {
                    if (autoHide && !dockHovered && !anyAppHovered) {
                      hidden = true
                    }
                  })
                }
              }
            }

            // Animation
            scale: contextMenuVisible ? 1 : 0.9
            opacity: contextMenuVisible ? 1 : 0
            transformOrigin: Item.Bottom

            Behavior on scale {
              NumberAnimation {
                duration: Style.animationFast
                easing.type: Easing.OutBack
              }
            }

            Behavior on opacity {
              NumberAnimation {
                duration: Style.animationFast
              }
            }
          }
        }
      }
    }
  }
}

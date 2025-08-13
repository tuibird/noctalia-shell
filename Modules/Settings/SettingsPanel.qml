import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.Modules.Settings.Tabs as Tabs
import qs.Services
import qs.Widgets

NLoader {
  id: root

  property var tabsIds: null
  property var requestedTab: null

  Component.onCompleted: {
    // Fill up our ideads
    tabsIds = Object.freeze({
                              "GENERAL": 0,
                              "BAR": 1,
                              "TIME_WEATHER": 2,
                              "SCREEN_RECORDER": 3,
                              "NETWORK": 4,
                              "AUDIO": 5,
                              "DISPLAY": 6,
                              "WALLPAPER": 7,
                              "WALLPAPER_SELECTOR": 8,
                              "MISC": 9,
                              "ABOUT": 10
                            })
  }

  content: Component {
    NPanel {
      id: panel

      readonly property real scaling: Scaling.scale(screen)
      property int currentTabIndex: 0

      // Override hide function to animate first
      function hide() {
        // Start hide animation
        bgRect.scaleValue = 0.8
        bgRect.opacityValue = 0.0

        // Hide after animation completes
        hideTimer.start()
      }

      // Connect to NPanel's dismissed signal to handle external close events
      Connections {
        target: panel
        function onDismissed() {
          // Start hide animation
          bgRect.scaleValue = 0.8
          bgRect.opacityValue = 0.0

          // Hide after animation completes
          hideTimer.start()
        }
      }

      // Timer to hide panel after animation
      Timer {
        id: hideTimer
        interval: Style.animationSlow
        repeat: false
        onTriggered: {
          panel.visible = false
          panel.dismissed()
        }
      }

      WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

      property var tabsModel: [{
          "id": root.tabsIds.GENERAL,
          "label": "General",
          "icon": "tune",
          "source": "Tabs/General.qml"
        }, {
          "id": root.tabsIds.BAR,
          "label": "Bar",
          "icon": "web_asset",
          "source": "Tabs/Bar.qml"
        }, {
          "id": root.tabsIds.TIME_WEATHER,
          "label": "Time & Weather",
          "icon": "schedule",
          "source": "Tabs/TimeWeather.qml"
        }, {
          "id": root.tabsIds.SCREEN_RECORDER,
          "label": "Screen Recorder",
          "icon": "videocam",
          "source": "Tabs/ScreenRecorder.qml"
        }, {
          "id": root.tabsIds.NETWORK,
          "label": "Network",
          "icon": "lan",
          "source": "Tabs/Network.qml"
        }, {
          "id": root.tabsIds.AUDIO,
          "label": "Audio",
          "icon": "volume_up",
          "source": "Tabs/Audio.qml"
        }, {
          "id": root.tabsIds.DISPLAY,
          "label": "Display",
          "icon": "monitor",
          "source": "Tabs/Display.qml"
        }, {
          "id": root.tabsIds.WALLPAPER,
          "label": "Wallpaper",
          "icon": "image",
          "source": "Tabs/Wallpaper.qml"
        }, {
          "id": root.tabsIds.WALLPAPER_SELECTOR,
          "label": "Wallpaper Selector",
          "icon": "wallpaper_slideshow",
          "source": "Tabs/WallpaperSelector.qml"
        }, // {
        //   "id": root.tabsIds.MISC,
        //   "label": "Misc",
        //   "icon": "more_horiz",
        //   "source": "Tabs/Misc.qml"
        // },
        {
          "id": root.tabsIds.ABOUT,
          "label": "About",
          "icon": "info",
          "source": "Tabs/About.qml"
        }]

      // Combined visibility change handler
      onVisibleChanged: {
        if (visible) {
          // Default to first tab
          currentTabIndex = 0

          // Find the request tab if necessary
          if (requestedTab != null) {
            for (var i = 0; i < tabsModel.length; i++) {
              if (tabsModel[i].id == requestedTab) {
                currentTabIndex = i
                break
              }
            }
          }
        } else if (bgRect.opacityValue > 0) {
          // Start hide animation
          bgRect.scaleValue = 0.8
          bgRect.opacityValue = 0.0

          // Hide after animation completes
          hideTimer.start()
        }
      }

      Component.onCompleted: show()

      Rectangle {
        id: bgRect
        color: Colors.backgroundPrimary
        radius: Style.radiusLarge * scaling
        border.color: Colors.backgroundTertiary
        border.width: Math.max(1, Style.borderMedium * scaling)
        layer.enabled: true
        width: (screen.width * 0.5) * scaling
        height: (screen.height * 0.5) * scaling
        anchors.centerIn: parent

        // Animation properties
        property real scaleValue: 0.8
        property real opacityValue: 0.0

        scale: scaleValue
        opacity: opacityValue

        // Animate in when component is completed
        Component.onCompleted: {
          scaleValue = 1.0
          opacityValue = 1.0
        }

        MouseArea {
          anchors.fill: parent
        }

        // Animation behaviors
        Behavior on scale {
          NumberAnimation {
            duration: Style.animationSlow
            easing.type: Easing.OutExpo
          }
        }

        Behavior on opacity {
          NumberAnimation {
            duration: Style.animationNormal
            easing.type: Easing.OutQuad
          }
        }

        RowLayout {
          anchors.fill: parent
          anchors.margins: Style.marginLarge * scaling
          spacing: Style.marginLarge * scaling

          // Sidebar with tighter spacing
          Rectangle {
            id: sidebar
            Layout.preferredWidth: 260 * scaling
            Layout.fillHeight: true
            radius: Style.radiusMedium * scaling
            color: Colors.backgroundSecondary
            border.color: Colors.outline
            border.width: Math.max(1, Style.borderThin * scaling)

            Column {
              anchors.fill: parent
              anchors.margins: Style.marginSmall * scaling
              spacing: Style.marginTiny * 1.5 * scaling // Minimal spacing between tabs

              Repeater {
                id: sections
                model: panel.tabsModel

                delegate: Rectangle {
                  id: tabItem

                  width: parent.width
                  height: 32 * scaling // Back to original height
                  radius: Style.radiusSmall * scaling
                  color: selected ? Colors.accentPrimary : (tabItem.hovering ? Colors.hover : "transparent")
                  border.color: "transparent"
                  border.width: 0

                  readonly property bool selected: index === currentTabIndex

                  // Subtle hover effect: only icon/text color tint on hover
                  property bool hovering: false

                  RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Style.marginSmall * scaling
                    anchors.rightMargin: Style.marginSmall * scaling
                    spacing: Style.marginSmall * scaling
                    NText {
                      text: modelData.icon
                      font.family: "Material Symbols Outlined"
                      font.variableAxes: {
                        "wght": (Font.Normal + Font.Bold) / 2.0
                      }
                      font.pointSize: Style.fontSizeLarge * scaling
                      color: selected ? Colors.onAccent : (tabItem.hovering ? Colors.onAccent : Colors.textSecondary)
                    }
                    // Tab label on the left side
                    NText {
                      text: modelData.label
                      color: selected ? Colors.onAccent : (tabItem.hovering ? Colors.onAccent : Colors.textPrimary)
                      font.pointSize: Style.fontSizeMedium * scaling
                      font.weight: Style.fontWeightBold
                      Layout.fillWidth: true
                    }
                  }
                  MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton
                    onEntered: tabItem.hovering = true
                    onExited: tabItem.hovering = false
                    onCanceled: tabItem.hovering = false
                    onClicked: currentTabIndex = index
                  }
                }
              }
            }
          }

          // Content
          Rectangle {
            id: contentPane
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: Style.radiusMedium * scaling
            color: Colors.surface
            border.color: Colors.outline
            border.width: Math.max(1, Style.borderThin * scaling)
            clip: true

            ColumnLayout {
              id: contentLayout
              anchors.fill: parent
              anchors.margins: Style.marginLarge * scaling
              spacing: Style.marginSmall * scaling

              RowLayout {
                id: headerRow
                Layout.fillWidth: true
                spacing: Style.marginSmall * scaling

                // Tab label on the main right
                NText {
                  text: panel.tabsModel[currentTabIndex].label
                  font.pointSize: Style.fontSizeLarge * scaling
                  font.weight: Style.fontWeightBold
                  color: Colors.accentPrimary
                  Layout.fillWidth: true
                }
                NIconButton {
                  icon: "close"
                  tooltipText: "Close"
                  Layout.alignment: Qt.AlignVCenter
                  onClicked: {
                    panel.hide()
                  }
                }
              }

              NDivider {
                Layout.fillWidth: true
              }

              StackLayout {
                id: stack
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: currentTabIndex

                Tabs.General {}
                Tabs.Bar {}
                Tabs.TimeWeather {}
                Tabs.ScreenRecorder {}
                Tabs.Network {}
                Tabs.Audio {}
                Tabs.Display {}
                Tabs.Wallpaper {}
                Tabs.WallpaperSelector {}
                //Tabs.Misc {}
                Tabs.About {}
              }
            }
          }
        }
      }
    }
  }
}

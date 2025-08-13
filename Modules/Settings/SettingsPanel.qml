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

  content: Component {
    NPanel {
      id: panel

      WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

      readonly property real scaling: Scaling.scale(screen)
      property int currentTabIndex: 0
      property var tabsModel: [{
          "label": "General",
          "icon": "tune",
          "source": "Tabs/General.qml"
        }, {
          "label": "Bar",
          "icon": "web_asset",
          "source": "Tabs/Bar.qml"
        }, {
          "label": "Time & Weather",
          "icon": "schedule",
          "source": "Tabs/TimeWeather.qml"
        }, {
          "label": "Screen Recorder",
          "icon": "videocam",
          "source": "Tabs/ScreenRecorder.qml"
        }, {
          "label": "Network",
          "icon": "wifi",
          "source": "Tabs/Network.qml"
        }, {
          "label": "Display",
          "icon": "monitor",
          "source": "Tabs/Display.qml"
        }, {
          "label": "Wallpaper",
          "icon": "image",
          "source": "Tabs/Wallpaper.qml"
        }, {
          "label": "Wallpaper Selector",
          "icon": "wallpaper_slideshow",
          "source": "Tabs/WallpaperSelector.qml"
        }, {
          "label": "Misc",
          "icon": "more_horiz",
          "source": "Tabs/Misc.qml"
        }, {
          "label": "About",
          "icon": "info",
          "source": "Tabs/About.qml"
        }]

      onVisibleChanged: {
        if (visible)
          currentTabIndex = 0
      }

      Component.onCompleted: show()

      Rectangle {
        id: bgRect
        color: Colors.backgroundPrimary
        radius: Style.radiusLarge * scaling
        border.color: Colors.backgroundTertiary
        border.width: Math.max(1, Style.borderMedium * scaling)
        layer.enabled: true
        width: (screen.width / 2) * scaling
        height: (screen.height / 2) * scaling
        anchors.centerIn: parent

        MouseArea {
          anchors.fill: parent
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
                  readonly property bool selected: index === panel.currentTabIndex
                  width: parent.width
                  height: 32 * scaling // Back to original height
                  radius: Style.radiusSmall * scaling
                  color: selected ? Colors.accentPrimary : (tabItem.hovering ? Colors.hover : "transparent")
                  border.color: "transparent"
                  border.width: 0

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
                    NText {
                      text: modelData.label
                      color: selected ? Colors.onAccent : (tabItem.hovering ? Colors.onAccent : Colors.textPrimary)
                      font.pointSize: Style.fontSizeInter * scaling
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
                    onClicked: panel.currentTabIndex = index
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
                NText {
                  text: panel.tabsModel[panel.currentTabIndex].label
                  font.pointSize: Style.fontSizeLarge * scaling
                  font.weight: Style.fontWeightBold
                  color: Colors.textPrimary
                  Layout.fillWidth: true
                }
                NIconButton {
                  icon: "close"
                  tooltipText: "Close"
                  Layout.alignment: Qt.AlignVCenter
                  onClicked: {
                    settingsPanel.isLoaded = !settingsPanel.isLoaded
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
                currentIndex: panel.currentTabIndex

                Tabs.General {}
                Tabs.Bar {}
                Tabs.TimeWeather {}
                Tabs.ScreenRecorder {}
                Tabs.Network {}
                Tabs.Display {}
                Tabs.Wallpaper {}
                Tabs.WallpaperSelector {}
                Tabs.Misc {}
                Tabs.About {}
              }
            }
          }
        }
      }
    }
  }
}

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.Services
import qs.Widgets
import "Tabs" as Tabs

NLoader {
  id: root

  content: Component {
    NPanel {
      id: settingsPanel

      WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

      readonly property real scaling: Scaling.scale(screen)
      property int currentTabIndex: 0
      property var tabsModel: [{
          "icon": "tune",
          "label": "General",
          "source": "Tabs/General.qml"
        }, {
          "icon": "web_asset",
          "label": "Bar",
          "source": "Tabs/Bar.qml"
        }, {
          "icon": "schedule",
          "label": "Time & Weather",
          "source": "Tabs/TimeWeather.qml"
        }, {
          "icon": "videocam",
          "label": "Screen Recorder",
          "source": "Tabs/ScreenRecorder.qml"
        }, {
          "icon": "wifi",
          "label": "Network",
          "source": "Tabs/Network.qml"
        }, {
          "icon": "monitor",
          "label": "Display",
          "source": "Tabs/Display.qml"
        }, {
          "icon": "image",
          "label": "Wallpaper",
          "source": "Tabs/Wallpaper.qml"
        }, {
          "icon": "more_horiz",
          "label": "Misc",
          "source": "Tabs/Misc.qml"
        }, {
          "icon": "info",
          "label": "About",
          "source": "Tabs/About.qml"
        }]

      onVisibleChanged: function () {
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
        width: 1040 * scaling
        height: 640 * scaling
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
              spacing: 2 * scaling // Minimal spacing between tabs

              Repeater {
                id: sections
                model: settingsPanel.tabsModel

                delegate: Rectangle {
                  id: tabItem
                  readonly property bool selected: index === settingsPanel.currentTabIndex
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
                    spacing: Style.marginTiny * scaling
                    NText {
                      text: modelData.icon
                      font.family: "Material Symbols Outlined"
                      font.variableAxes: {
                        "wght": (Font.Normal + Font.Bold) / 2.0
                      }
                      color: selected ? Colors.onAccent : (tabItem.hovering ? Colors.onAccent : Colors.textSecondary)
                    }
                    NText {
                      text: modelData.label
                      color: selected ? Colors.onAccent : (tabItem.hovering ? Colors.onAccent : Colors.textPrimary)
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
                    onClicked: settingsPanel.currentTabIndex = index
                  }
                }
              }
            }
          }

          // Content (unchanged)
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
                  text: settingsPanel.tabsModel[settingsPanel.currentTabIndex].label
                  font.weight: Style.fontWeightBold
                  color: Colors.textPrimary
                  Layout.fillWidth: true
                }
                NIconButton {
                  id: demoPanelToggle
                  icon: "close"
                  tooltipText: "Close settings panel"
                  Layout.alignment: Qt.AlignVCenter
                  onClicked: function () {
                    settingsWindow.isLoaded = !settingsWindow.isLoaded
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
                currentIndex: settingsPanel.currentTabIndex

                Repeater {
                  model: settingsPanel.tabsModel
                  delegate: Loader {
                    active: index === settingsPanel.currentTabIndex
                    visible: active
                    source: modelData.source
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

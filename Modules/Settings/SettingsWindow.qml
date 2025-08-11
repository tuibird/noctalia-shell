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
      // Active tab index unified for sidebar, header, and content stack
      property int currentTabIndex: 0
      // Single source of truth for tabs (explicit icon/label here)
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

      // Always default to the first tab (General) when the panel becomes visible
      onVisibleChanged: function () {
        if (visible)
          currentTabIndex = 0
      }

      // Ensure panel shows itself once created
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

        // Prevent closing when clicking in the panel bg
        MouseArea {
          anchors.fill: parent
        }

        // Main two-pane layout
        RowLayout {
          anchors.fill: parent
          anchors.margins: Style.marginLarge * scaling
          spacing: Style.marginLarge * scaling

          // Sidebar
          Rectangle {
            id: sidebar
            Layout.preferredWidth: 260 * scaling
            Layout.fillHeight: true
            radius: Style.radiusMedium * scaling
            color: Colors.backgroundSecondary
            border.color: Colors.outline
            border.width: Math.max(1, Style.borderThin * scaling)

            ColumnLayout {
              anchors.fill: parent
              anchors.margins: Style.marginSmall * scaling
              spacing: Style.marginSmall * scaling

              Repeater {
                id: sections
                model: settingsPanel.tabsModel

                delegate: Rectangle {
                  readonly property bool selected: index === settingsPanel.currentTabIndex
                  Layout.fillWidth: true
                  height: 44 * scaling
                  radius: Style.radiusSmall * scaling
                  color: selected ? Colors.highlight : "transparent"
                  border.color: Colors.outline
                  border.width: Math.max(1, Style.borderThin * scaling)

                  RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Style.marginMedium * scaling
                    anchors.rightMargin: Style.marginMedium * scaling
                    spacing: Style.marginSmall * scaling
                    NText {
                      text: modelData.icon
                      font.family: "Material Symbols Outlined"
                      font.variableAxes: {
                        "wght": (Font.Normal + Font.Bold) / 2.0
                      }
                      color: selected ? Colors.onAccent : Colors.textSecondary
                    }
                    NText {
                      text: modelData.label
                      color: selected ? Colors.onAccent : Colors.textPrimary
                      Layout.fillWidth: true
                    }
                  }
                  MouseArea {
                    anchors.fill: parent
                    onClicked: settingsPanel.currentTabIndex = index
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

            // Content layout: header + divider + pages
            ColumnLayout {
              id: contentLayout
              anchors.fill: parent
              anchors.margins: Style.marginLarge * scaling
              spacing: Style.marginSmall * scaling

              // Header row
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

              // Stacked pages
              StackLayout {
                id: stack
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: settingsPanel.currentTabIndex

                // Pages generated from tabsModel
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

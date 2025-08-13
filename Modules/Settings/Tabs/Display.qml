import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import qs.Services
import qs.Widgets

Item {
  property real scaling: 1
  readonly property string tabIcon: "monitor"
  readonly property string tabLabel: "Display"
  readonly property int tabIndex: 5
  Layout.fillWidth: true
  Layout.fillHeight: true

  // Helper functions to update arrays immutably
  function addMonitor(list, name) {
    const arr = (list || []).slice()
    if (!arr.includes(name))
      arr.push(name)
    return arr
  }
  function removeMonitor(list, name) {
    return (list || []).filter(function (n) {
      return n !== name
    })
  }

  ScrollView {
    anchors.fill: parent
    clip: true
    ScrollBar.vertical.policy: ScrollBar.AsNeeded
    ScrollBar.horizontal.policy: ScrollBar.AsNeeded
    contentWidth: parent.width

    ColumnLayout {
      width: parent.width
      ColumnLayout {
        spacing: Style.marginLarge * scaling
        Layout.margins: Style.marginLarge * scaling
        Layout.fillWidth: true

        NText {
          text: "Per‑monitor configuration"
          font.pointSize: Style.fontSizeXL * scaling
          font.weight: Style.fontWeightBold
          color: Colors.textPrimary
        }

        Repeater {
          model: Quickshell.screens || []
          delegate: Rectangle {
            Layout.fillWidth: true
            radius: Style.radiusMedium * scaling
            color: Colors.surface
            border.color: Colors.outline
            border.width: Math.max(1, Style.borderThin * scaling)
            implicitHeight: contentCol.implicitHeight + Style.marginXL * 2 * scaling

            ColumnLayout {
              id: contentCol
              anchors.fill: parent
              anchors.margins: Style.marginLarge * scaling
              spacing: Style.marginTiniest * scaling

              NText {
                text: (modelData.name || "Unknown")
                font.pointSize: Style.fontSizeLarge * scaling
                font.weight: Style.fontWeightBold
                color: Colors.accentSecondary
              }

              NText {
                text: `Resolution: ${modelData.width}x${modelData.height} - Position: (${modelData.x}, ${modelData.y})`
                font.pointSize: Style.fontSizeSmall * scaling
                color: Colors.textSecondary
              }

              ColumnLayout {
                spacing: Style.marginLarge * scaling

                NToggle {
                  label: "Bar"
                  description: "Display the top bar on this monitor"
                  value: (Settings.data.bar.monitors || []).indexOf(modelData.name) !== -1
                  onToggled: function (newValue) {
                    if (newValue) {
                      Settings.data.bar.monitors = addMonitor(Settings.data.bar.monitors, modelData.name)
                    } else {
                      Settings.data.bar.monitors = removeMonitor(Settings.data.bar.monitors, modelData.name)
                    }
                  }
                }

                NToggle {
                  label: "Dock"
                  description: "Display the dock on this monitor"
                  value: (Settings.data.dock.monitors || []).indexOf(modelData.name) !== -1
                  onToggled: function (newValue) {
                    if (newValue) {
                      Settings.data.dock.monitors = addMonitor(Settings.data.dock.monitors, modelData.name)
                    } else {
                      Settings.data.dock.monitors = removeMonitor(Settings.data.dock.monitors, modelData.name)
                    }
                  }
                }

                NToggle {
                  label: "Notifications"
                  description: "Display notifications on this monitor"
                  value: (Settings.data.notifications.monitors || []).indexOf(modelData.name) !== -1
                  onToggled: function (newValue) {
                    if (newValue) {
                      Settings.data.notifications.monitors = addMonitor(Settings.data.notifications.monitors,
                                                                        modelData.name)
                    } else {
                      Settings.data.notifications.monitors = removeMonitor(Settings.data.notifications.monitors,
                                                                           modelData.name)
                    }
                  }
                }
              }
            }
          }
        }

        Item {
          Layout.fillHeight: true
        }
      }
    }
  }
}

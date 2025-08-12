import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Services
import qs.Widgets

ColumnLayout {
  id: root

  spacing: 0

  ScrollView {
    id: scrollView

    Layout.fillWidth: true
    Layout.fillHeight: true
    padding: 16
    rightPadding: 12
    clip: true
    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
    ScrollBar.vertical.policy: ScrollBar.AsNeeded

    ColumnLayout {
      width: scrollView.availableWidth
      spacing: 0

      Item {
        Layout.fillWidth: true
        Layout.preferredHeight: 0
      }

      ColumnLayout {
        spacing: 4
        Layout.fillWidth: true

        NText {
          text: "Bar Settings"
          font.pointSize: 18
          font.weight: Style.fontWeightBold
          color: Colors.textPrimary
          Layout.bottomMargin: 8
        }

        // Elements section
        ColumnLayout {
          spacing: 8
          Layout.fillWidth: true
          Layout.topMargin: 8

          NText {
            text: "Elements"
            font.pointSize: 13
            font.weight: Style.fontWeightBold
            color: Colors.textPrimary
          }

          NToggle {
            label: "Show Active Window"
            description: "Display the title of the currently focused window below the bar"
            value: Settings.data.bar.showActiveWindow
            onToggled: function (newValue) {
              Settings.data.bar.showActiveWindow = newValue
            }
          }

          NToggle {
            label: "Show Active Window Icon"
            description: "Display the icon of the currently focused window"
            value: Settings.data.bar.showActiveWindowIcon
            onToggled: function (newValue) {
              Settings.data.bar.showActiveWindowIcon = newValue
            }
          }

          NToggle {
            label: "Show System Info"
            description: "Display system information (CPU, RAM, Temperature)"
            value: Settings.data.bar.showSystemInfo
            onToggled: function (newValue) {
              Settings.data.bar.showSystemInfo = newValue
            }
          }

          NToggle {
            label: "Show Taskbar"
            description: "Display a taskbar showing currently open windows"
            value: Settings.data.bar.showTaskbar
            onToggled: function (newValue) {
              Settings.data.bar.showTaskbar = newValue
            }
          }

          NToggle {
            label: "Show Media"
            description: "Display media controls and information"
            value: Settings.data.bar.showMedia
            onToggled: function (newValue) {
              Settings.data.bar.showMedia = newValue
            }
          }
        }
      }
    }
  }
}

import QtQuick
import QtQuick.Layouts
import qs.Services
import qs.Widgets

Item {
  // Optional scaling prop to match other tabs
  property real scaling: 1
  // Tab metadata
  readonly property string tabIcon: "web_asset"
  readonly property string tabLabel: "Bar"
  readonly property int tabIndex: 1
  Layout.fillWidth: true
  Layout.fillHeight: true

  ColumnLayout {
    anchors.fill: parent
    spacing: Style.marginMedium * scaling

    NText {
      text: "Elements"
      font.weight: Style.fontWeightBold
      color: Colors.accentSecondary
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

    Item {
      Layout.fillHeight: true
    }
  }
}

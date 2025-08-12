import QtQuick
import QtQuick.Layouts
import qs.Services
import qs.Widgets

Item {
  property real scaling: 1
  readonly property string tabIcon: "schedule"
  readonly property string tabLabel: "Time & Weather"
  readonly property int tabIndex: 2
  anchors.fill: parent

  ColumnLayout {
    anchors.fill: parent
    spacing: Style.marginMedium * scaling

    NText {
      text: "Time"
      font.weight: Style.fontWeightBold
      color: Colors.accentSecondary
    }

    NToggle {
      label: "Use 12 Hour Clock"
      description: "Display time in 12-hour format (e.g., 2:30 PM) instead of 24-hour format"
      value: Settings.data.location.use12HourClock
      onToggled: function (newValue) {
        Settings.data.location.use12HourClock = newValue
      }
    }

    NToggle {
      label: "US Style Date"
      description: "Display dates in MM/DD/YYYY format instead of DD/MM/YYYY"
      value: Settings.data.location.reverseDayMonth
      onToggled: function (newValue) {
        Settings.data.location.reverseDayMonth = newValue
      }
    }

    NDivider {
      Layout.fillWidth: true
    }

    NText {
      text: "Weather"
      font.weight: Style.fontWeightBold
      color: Colors.accentSecondary
    }

    NText {
      text: "City"
      color: Colors.textPrimary
      font.weight: Style.fontWeightBold
    }
    NText {
      text: "Your city name for weather information"
      color: Colors.textSecondary
    }
    NTextBox {
      text: Settings.data.location.name
      Layout.fillWidth: true
      onEditingFinished: Settings.data.location.name = text
    }

    RowLayout {
      Layout.fillWidth: true
      spacing: Style.marginSmall * scaling
      ColumnLayout {
        Layout.fillWidth: true
        spacing: 2 * scaling
        NText {
          text: "Temperature Unit"
          color: Colors.textPrimary
          font.weight: Style.fontWeightBold
        }
        NText {
          text: "Choose between Celsius and Fahrenheit"
          color: Colors.textSecondary
          wrapMode: Text.WordWrap
        }
      }
      NComboBox {
        optionsKeys: ["c", "f"]
        optionsLabels: ["Celsius", "Fahrenheit"]
        currentKey: Settings.data.location.useFahrenheit ? "f" : "c"
        onSelected: function (key) {
          Settings.data.location.useFahrenheit = (key === "f")
        }
      }
    }

    Item {
      Layout.fillHeight: true
    }
  }
}

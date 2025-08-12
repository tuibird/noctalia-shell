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
    padding: Style.marginMedium * scaling
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
        spacing: Style.marginTiny * scaling
        Layout.fillWidth: true

        NText {
          text: "Location"
          font.pointSize: Style.fontSizeXL * scaling
          font.weight: Style.fontWeightBold
          color: Colors.textPrimary
          Layout.bottomMargin: Style.marginSmall * scaling
        }

        // Location section
        ColumnLayout {
          spacing: Style.marginMedium * scaling
          Layout.fillWidth: true
          Layout.topMargin: Style.marginSmall * scaling

          NTextInput {
            text: Settings.data.location.name
            placeholderText: "Enter city name"
            Layout.fillWidth: true
            onEditingFinished: {
              Settings.data.location.name = text
            }
          }
        }

        NDivider {
          Layout.fillWidth: true
          Layout.topMargin: Style.marginLarge * 2 * scaling
          Layout.bottomMargin: Style.marginLarge * scaling
        }

        // Time section
        ColumnLayout {
          spacing: Style.marginMedium * scaling
          Layout.fillWidth: true

          NText {
            text: "Time Format"
            font.pointSize: Style.fontSizeXL * scaling
            font.weight: Style.fontWeightBold
            color: Colors.textPrimary
            Layout.bottomMargin: 8
          }

          NToggle {
            label: "Use 12-Hour Clock"
            description: "Display time in 12-hour format (AM/PM) instead of 24-hour"
            value: Settings.data.location.use12HourClock
            onToggled: function (newValue) {
              Settings.data.location.use12HourClock = newValue
            }
          }

          NToggle {
            label: "Reverse Day/Month"
            description: "Display date as DD/MM instead of MM/DD"
            value: Settings.data.location.reverseDayMonth
            onToggled: function (newValue) {
              Settings.data.location.reverseDayMonth = newValue
            }
          }
        }

        NDivider {
          Layout.fillWidth: true
          Layout.topMargin: Style.marginLarge * 2 * scaling
          Layout.bottomMargin: Style.marginLarge * scaling
        }

        // Weather section
        ColumnLayout {
          spacing: Style.marginMedium * scaling
          Layout.fillWidth: true

          NText {
            text: "Weather"
            font.pointSize: Style.fontSizeXL * scaling
            font.weight: Style.fontWeightBold
            color: Colors.textPrimary
            Layout.bottomMargin: Style.marginSmall * scaling
          }

          NToggle {
            label: "Use Fahrenheit"
            description: "Display temperature in Fahrenheit instead of Celsius"
            value: Settings.data.location.useFahrenheit
            onToggled: function (newValue) {
              Settings.data.location.useFahrenheit = newValue
            }
          }
        }
      }
    }
  }
}

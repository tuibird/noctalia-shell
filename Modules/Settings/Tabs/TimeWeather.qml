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
          text: "Time & Weather Settings"
          font.pointSize: 18
          font.weight: Style.fontWeightBold
          color: Colors.textPrimary
          Layout.bottomMargin: 8
        }

        // Location section
        ColumnLayout {
          spacing: 8
          Layout.fillWidth: true
          Layout.topMargin: 8

          NText {
            text: "Location"
            font.pointSize: 13
            font.weight: Style.fontWeightBold
            color: Colors.textPrimary
          }

          NTextInput {
            text: Settings.data.location.name
            placeholderText: "Enter city name"
            Layout.fillWidth: true
            onEditingFinished: function () {
              Settings.data.location.name = text
            }
          }
        }

        NDivider {
          Layout.fillWidth: true
          Layout.topMargin: 26
          Layout.bottomMargin: 18
        }

        // Time section
        ColumnLayout {
          spacing: 4
          Layout.fillWidth: true

          NText {
            text: "Time Format"
            font.pointSize: 18
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
          Layout.topMargin: 26
          Layout.bottomMargin: 18
        }

        // Weather section
        ColumnLayout {
          spacing: 4
          Layout.fillWidth: true

          NText {
            text: "Weather"
            font.pointSize: 18
            font.weight: Style.fontWeightBold
            color: Colors.textPrimary
            Layout.bottomMargin: 8
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

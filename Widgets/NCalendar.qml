import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.Services

import "../Helpers/Holidays.js" as Holidays

NPanel {
  id: calendarOverlay

  readonly property real scaling: Scaling.scale(screen)

  Rectangle {
    color: Theme.backgroundPrimary
    radius: 12
    border.color: Theme.backgroundTertiary
    border.width: 1
    width: 340 * scaling
    height: 380
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.topMargin: 4 * scaling
    anchors.rightMargin: 4 * scaling

    // Prevent closing when clicking in the panel bg
    MouseArea {
      anchors.fill: parent
    }

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: 16
      spacing: 12

      // Month/Year header with navigation
      RowLayout {
        Layout.fillWidth: true
        spacing: 8

        NIconButton {
          icon: "chevron_left"
          onClicked: function () {
            let newDate = new Date(calendar.year, calendar.month - 1, 1)
            calendar.year = newDate.getFullYear()
            calendar.month = newDate.getMonth()
          }
        }

        Text {
          Layout.fillWidth: true
          horizontalAlignment: Text.AlignHCenter
          text: calendar.title
          color: Theme.textPrimary
          opacity: 0.7
          font.pointSize: Style.fontSmall * scaling
          font.family: Theme.fontFamily
          font.bold: true
        }

        NIconButton {
          icon: "chevron_right"
          onClicked: function () {
            let newDate = new Date(calendar.year, calendar.month + 1, 1)
            calendar.year = newDate.getFullYear()
            calendar.month = newDate.getMonth()
          }
        }
      }

      DayOfWeekRow {
        Layout.fillWidth: true
        spacing: 0
        Layout.leftMargin: 8 // Align with grid
        Layout.rightMargin: 8

        delegate: Text {
          text: shortName
          color: Theme.textPrimary
          opacity: 0.8
          font.pointSize: Style.fontSmall * scaling
          font.family: Theme.fontFamily
          font.bold: true
          horizontalAlignment: Text.AlignHCenter
          width: 32
        }
      }

      MonthGrid {
        id: calendar

        property var holidays: []

        // Fetch holidays when calendar is opened or month/year changes
        function updateHolidays() {
          Holidays.getHolidaysForMonth(calendar.year, calendar.month,
                                       function (holidays) {
                                         calendar.holidays = holidays
                                       })
        }

        Layout.fillWidth: true
        Layout.leftMargin: 8
        Layout.rightMargin: 8
        spacing: 0
        month: Time.date.getMonth()
        year: Time.date.getFullYear()
        onMonthChanged: updateHolidays()
        onYearChanged: updateHolidays()
        Component.onCompleted: updateHolidays()

        // Optionally, update when the panel becomes visible
        Connections {
          function onVisibleChanged() {
            if (calendarOverlay.visible) {
              calendar.month = Time.date.getMonth()
              calendar.year = Time.date.getFullYear()
              calendar.updateHolidays()
            }
          }

          target: calendarOverlay
        }

        delegate: Rectangle {
          property var holidayInfo: calendar.holidays.filter(function (h) {
            var d = new Date(h.date)
            return d.getDate() === model.day && d.getMonth() === model.month
                && d.getFullYear() === model.year
          })
          property bool isHoliday: holidayInfo.length > 0

          width: 32
          height: 32
          radius: 8
          color: {
            if (model.today)
              return Theme.accentPrimary

            if (mouseArea2.containsMouse)
              return Theme.backgroundTertiary

            return "transparent"
          }

          // Holiday dot indicator
          Rectangle {
            visible: isHoliday
            width: 4
            height: 4
            radius: 4
            color: Theme.accentTertiary
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 4
            anchors.rightMargin: 4
            z: 2
          }

          Text {
            anchors.centerIn: parent
            text: model.day
            color: model.today ? Theme.onAccent : Theme.textPrimary
            opacity: model.month === calendar.month ? (mouseArea2.containsMouse ? 1 : 0.7) : 0.3
            font.pointSize: Style.fontSmall * scaling
            font.family: Theme.fontFamily
            font.bold: model.today ? true : false
          }

          MouseArea {
            id: mouseArea2

            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
              if (isHoliday) {
                holidayTooltip.text = holidayInfo.map(function (h) {
                  return h.localName + (h.name !== h.localName ? " (" + h.name + ")" : "")
                      + (h.global ? " [Global]" : "")
                }).join(", ")
                holidayTooltip.target = parent;
                holidayTooltip.show();
              }
            }
            onExited: holidayTooltip.hide()
          }

          NTooltip {
            id: holidayTooltip
            text: ""
          }

          Behavior on color {
            ColorAnimation {
              duration: 150
            }
          }
        }
      }
    }
  }
}

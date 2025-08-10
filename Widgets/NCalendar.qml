import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.Services

import "../Helpers/Holidays.js" as Holidays

NPanel {
  id: root

  readonly property real scaling: Scaling.scale(screen)

  Rectangle {
    color: Colors.backgroundSecondary
    radius: Style.radiusMedium * scaling
    border.color: Colors.backgroundTertiary
    border.width: Math.min(1, Style.borderMedium * scaling)
    width: 340 * scaling
    height: 300
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.topMargin: Style.marginTiny * scaling
    anchors.rightMargin: Style.marginTiny * scaling

    // Prevent closing when clicking in the panel bg
    MouseArea {
      anchors.fill: parent
    }

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: Style.marginMedium * scaling
      spacing: Style.marginMedium * scaling

      // Month/Year header with navigation
      RowLayout {
        Layout.fillWidth: true
        spacing: Style.marginSmall * scaling

        NIconButton {
          icon: "chevron_left"
          onClicked: function () {
            let newDate = new Date(calendar.year, calendar.month - 1, 1)
            calendar.year = newDate.getFullYear()
            calendar.month = newDate.getMonth()
          }
        }

        NText {
          text: calendar.title
          Layout.fillWidth: true
          horizontalAlignment: Text.AlignHCenter
          font.pointSize: Style.fontSizeMedium * scaling
          color: Colors.accentPrimary
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
        Layout.leftMargin: Style.marginSmall * scaling // Align with grid
        Layout.rightMargin: Style.marginSmall * scaling

        delegate: NText {
          text: shortName
          color: Colors.accentSecondary
          font.pointSize: Style.fontSizeMedium * scaling
          horizontalAlignment: Text.AlignHCenter
          width: Style.baseWidgetSize * scaling
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
        Layout.leftMargin: Style.marginSmall * scaling
        Layout.rightMargin: Style.marginSmall * scaling
        spacing: 0
        month: Time.date.getMonth()
        year: Time.date.getFullYear()
        onMonthChanged: updateHolidays()
        onYearChanged: updateHolidays()
        Component.onCompleted: updateHolidays()

        // Optionally, update when the panel becomes visible
        Connections {
          function onVisibleChanged() {
            if (root.visible) {
              calendar.month = Time.date.getMonth()
              calendar.year = Time.date.getFullYear()
              calendar.updateHolidays()
            }
          }

          target: root
        }

        delegate: Rectangle {
          property var holidayInfo: calendar.holidays.filter(function (h) {
            var d = new Date(h.date)
            return d.getDate() === model.day && d.getMonth() === model.month
                && d.getFullYear() === model.year
          })
          property bool isHoliday: holidayInfo.length > 0

          width: Style.baseWidgetSize * scaling
          height: Style.baseWidgetSize * scaling
          radius: Style.radiusSmall * scaling
          color: {
            if (model.today)
              return Colors.accentPrimary

            if (mouseArea2.containsMouse)
              return Colors.backgroundTertiary

            return "transparent"
          }

          // Holiday dot indicator
          Rectangle {
            visible: isHoliday
            width: Style.baseWidgetSize / 8 * scaling
            height: Style.baseWidgetSize / 8 * scaling
            radius: Style.radiusSmall * scaling
            color: Colors.accentTertiary
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: Style.marginTiny * scaling
            anchors.rightMargin: Style.marginTiny * scaling
            z: 2
          }

          NText {
            anchors.centerIn: parent
            text: model.day
            color: model.today ? Colors.onAccent : Colors.textPrimary
            opacity: model.month === calendar.month ? (mouseArea2.containsMouse ? Style.opacityFull : Style.opacityHeavy) : Style.opacityLight
            font.pointSize: Style.fontSizeMedium * scaling
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
                holidayTooltip.target = parent
                holidayTooltip.show()
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

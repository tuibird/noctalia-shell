import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.Services
import qs.Widgets

NLoader {
  id: root

  content: Component {
    NPanel {
      id: calendarPanel

      readonly property real scaling: Scaling.scale(screen)

      Rectangle {
        color: Colors.backgroundSecondary
        radius: Style.radiusMedium * scaling
        border.color: Colors.backgroundTertiary
        border.width: Math.max(1, Style.borderMedium * scaling)
        width: 340 * scaling
        height: 380 * scaling  // Scale the height and make it larger
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: Style.marginTiny * scaling
        anchors.rightMargin: Style.marginTiny * scaling

        // Prevent closing when clicking in the panel bg
        MouseArea {
          anchors.fill: parent
        }

        // Main Column
        ColumnLayout {
          anchors.fill: parent
          anchors.margins: Style.marginMedium * scaling
          spacing: Style.marginMedium * scaling

          // Header: Month/Year with navigation
          RowLayout {
            Layout.fillWidth: true
            spacing: Style.marginSmall * scaling

            NIconButton {
              icon: "chevron_left"
              onClicked: function () {
                let newDate = new Date(grid.year, grid.month - 1, 1)
                grid.year = newDate.getFullYear()
                grid.month = newDate.getMonth()
              }
            }

            NText {
              text: grid.title
              Layout.fillWidth: true
              horizontalAlignment: Text.AlignHCenter
              font.pointSize: Style.fontSizeMedium * scaling
              font.weight: Style.fontWeightBold
              color: Colors.accentPrimary
            }

            NIconButton {
              icon: "chevron_right"
              onClicked: function () {
                let newDate = new Date(grid.year, grid.month + 1, 1)
                grid.year = newDate.getFullYear()
                grid.month = newDate.getMonth()
              }
            }
          }

          NDivider {
            Layout.fillWidth: true
          }

          // Columns label (respects locale's first day of week)
          RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: Style.marginSmall * scaling // Align with grid
            Layout.rightMargin: Style.marginSmall * scaling
            spacing: 0

            Repeater {
              model: 7
              
              NText {
                text: {
                  // Use the locale's first day of week setting
                  let firstDay = Qt.locale().firstDayOfWeek
                  let dayIndex = (firstDay + index) % 7
                  return Qt.locale().dayName(dayIndex, Locale.ShortFormat)
                }
                color: Colors.accentSecondary
                font.pointSize: Style.fontSizeMedium * scaling
                font.weight: Style.fontWeightBold
                horizontalAlignment: Text.AlignHCenter
                Layout.fillWidth: true
                Layout.preferredWidth: Style.baseWidgetSize * scaling
              }
            }
          }

          // Grids: days
          MonthGrid {
            id: grid

            Layout.fillWidth: true
            Layout.leftMargin: Style.marginSmall * scaling
            Layout.rightMargin: Style.marginSmall * scaling
            spacing: 0
            month: Time.date.getMonth()
            year: Time.date.getFullYear()
            locale: Qt.locale() // Use system locale

            // Optionally, update when the panel becomes visible
            Connections {
              target: calendarPanel
              function onVisibleChanged() {
                if (calendarPanel.visible) {
                  grid.month = Time.date.getMonth()
                  grid.year = Time.date.getFullYear()
                }
              }
            }

            delegate: Rectangle {
              width: (Style.baseWidgetSize * scaling)
              height: (Style.baseWidgetSize * scaling)
              radius: Style.radiusSmall * scaling
              color: model.today ? Colors.accentPrimary : "transparent"

              NText {
                anchors.centerIn: parent
                text: model.day
                color: model.today ? Colors.onAccent : Colors.textPrimary
                opacity: model.month === grid.month ? Style.opacityHeavy : Style.opacityLight
                font.pointSize: (Style.fontSizeMedium * scaling)
                font.weight: model.today ? Style.fontWeightBold : Style.fontWeightRegular
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
  }
}
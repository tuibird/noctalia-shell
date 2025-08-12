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
          text: "General Settings"
          font.pointSize: 18
          font.weight: Style.fontWeightBold
          color: Colors.textPrimary
          Layout.bottomMargin: 8
        }

        // Profile section
        ColumnLayout {
          spacing: 8
          Layout.fillWidth: true
          Layout.topMargin: 8

          NText {
            text: "Profile"
            font.pointSize: 13
            font.weight: Style.fontWeightBold
            color: Colors.textPrimary
          }

          RowLayout {
            Layout.fillWidth: true
            spacing: 16

            // Avatar preview
            NImageRounded {
              width: 64
              height: 64
              imagePath: Settings.data.general.avatarImage
              fallbackIcon: "person"
              borderColor: Colors.accentPrimary
              borderWidth: Math.max(1, Style.borderMedium)
            }
            ColumnLayout {
              Layout.fillWidth: true
              spacing: 4
              NText {
                text: "Profile Image"
                color: Colors.textPrimary
                font.weight: Style.fontWeightBold
              }
              NText {
                text: "Your profile picture displayed in various places throughout the shell"
                color: Colors.textSecondary
                font.pointSize: 12
              }
              NTextInput {
                text: Settings.data.general.avatarImage
                placeholderText: "/home/user/.face"
                Layout.fillWidth: true
                onEditingFinished: function () {
                  Settings.data.general.avatarImage = text
                }
              }
            }
          }
        }
      }

      NDivider {
        Layout.fillWidth: true
        Layout.topMargin: 26
        Layout.bottomMargin: 18
      }

      ColumnLayout {
        spacing: 4
        Layout.fillWidth: true

        NText {
          text: "User Interface"
          font.pointSize: 18
          font.weight: Style.fontWeightBold
          color: Colors.textPrimary
          Layout.bottomMargin: 8
        }

        NToggle {
          label: "Show Corners"
          description: "Display rounded corners on the edge of the screen"
          value: Settings.data.general.showScreenCorners
          onToggled: function (v) {
            Settings.data.general.showScreenCorners = v
          }
        }

        NToggle {
          label: "Show Dock"
          description: "Display a dock at the bottom of the screen for quick access to applications"
          value: Settings.data.general.showDock
          onToggled: function (v) {
            Settings.data.general.showDock = v
          }
        }

        NToggle {
          label: "Dim Desktop"
          description: "Dim the desktop when panels or menus are open"
          value: Settings.data.general.dimDesktop
          onToggled: function (v) {
            Settings.data.general.dimDesktop = v
          }
        }
      }
    }
  }
}

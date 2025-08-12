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
          text: "General Settings"
          font.pointSize: Style.fontSizeXL * scaling
          font.weight: Style.fontWeightBold
          color: Colors.textPrimary
          Layout.bottomMargin: Style.marginSmall * scaling
        }

        // Profile section
        ColumnLayout {
          spacing: Style.marginSmall * scaling
          Layout.fillWidth: true
          Layout.topMargin: Style.marginSmall * scaling

          RowLayout {
            Layout.fillWidth: true
            spacing: Style.marginLarge * scaling

            // Avatar preview
            NImageRounded {
              width: 64 * scaling
              height: 64 * scaling
              imagePath: Settings.data.general.avatarImage
              fallbackIcon: "person"
              borderColor: Colors.accentPrimary
              borderWidth: Math.max(1, Style.borderMedium)
            }
            ColumnLayout {
              Layout.fillWidth: true
              spacing: Style.marginTiny * scaling
              NText {
                text: "Profile Picture"
                color: Colors.textPrimary
                font.weight: Style.fontWeightBold
              }
              NText {
                text: "Your profile picture displayed in various places throughout the shell"
                color: Colors.textSecondary
                font.pointSize: Style.fontSizeSmall * scaling
              }
              NTextInput {
                text: Settings.data.general.avatarImage
                placeholderText: "/home/user/.face"
                Layout.fillWidth: true
                onEditingFinished: {
                  Settings.data.general.avatarImage = text
                }
              }
            }
          }
        }
      }

      NDivider {
        Layout.fillWidth: true
        Layout.topMargin: Style.marginLarge * 2 * scaling
        Layout.bottomMargin: Style.marginLarge * scaling
      }

      ColumnLayout {
        spacing: Style.marginMedium * scaling
        Layout.fillWidth: true

        NText {
          text: "User Interface"
          font.pointSize: Style.fontSizeXL * scaling
          font.weight: Style.fontWeightBold
          color: Colors.textPrimary
          Layout.bottomMargin: Style.marginSmall * scaling
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

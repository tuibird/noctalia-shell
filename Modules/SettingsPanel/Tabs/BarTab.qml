import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Commons
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
        spacing: Style.marginLarge * scaling
        Layout.fillWidth: true

        NText {
          text: "Components"
          font.pointSize: Style.fontSizeXL * scaling
          font.weight: Style.fontWeightBold
          color: Colors.mOnSurface
        }

        NToggle {
          label: "Show Active Window"
          description: "Display the title of the currently focused window below the bar"
          checked: Settings.data.bar.showActiveWindow
          onToggled: checked => {
                       Settings.data.bar.showActiveWindow = checked
                     }
        }

        NToggle {
          label: "Show System Info"
          description: "Display system information (CPU, RAM, Temperature)"
          checked: Settings.data.bar.showSystemInfo
          onToggled: checked => {
                       Settings.data.bar.showSystemInfo = checked
                     }
        }

        NToggle {
          label: "Show Media"
          description: "Display media controls and information"
          checked: Settings.data.bar.showMedia
          onToggled: checked => {
                       Settings.data.bar.showMedia = checked
                     }
        }
      }
    }
  }
}

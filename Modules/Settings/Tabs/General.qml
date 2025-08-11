import QtQuick
import QtQuick.Layouts
import qs.Services
import qs.Widgets

Item {
  id: generalPage

  // Public API
  // Scaling factor provided by the parent settings window
  property real scaling: 1

  anchors.fill: parent
  implicitWidth: parent ? parent.width : 0
  implicitHeight: parent ? parent.height : 0

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: 0
    spacing: Style.marginMedium * scaling

    // Profile section
    NText { text: "Profile"; font.weight: Style.fontWeightBold; color: Colors.accentSecondary }

    RowLayout {
      Layout.fillWidth: true
      spacing: Style.marginMedium * scaling

      // Avatar preview
      Rectangle {
        width: 40 * scaling
        height: 40 * scaling
        radius: 20 * scaling
        color: Colors.surfaceVariant
        border.color: Colors.outline
        border.width: Math.max(1, Style.borderThin * scaling)
        Image {
          anchors.fill: parent
          anchors.margins: 2 * scaling
          source: Settings.data.general.avatarImage
          fillMode: Image.PreserveAspectCrop
          asynchronous: true
        }
      }

      ColumnLayout {
        Layout.fillWidth: true
        spacing: 2 * scaling
        NText { text: "Profile Image"; color: Colors.textPrimary; font.weight: Style.fontWeightBold }
        NText { text: "Your profile picture displayed in various places throughout the shell"; color: Colors.textSecondary }
        NTextBox {
          text: Settings.data.general.avatarImage
          placeholderText: "/home/user/.face"
          Layout.fillWidth: true
          onEditingFinished: Settings.data.general.avatarImage = text
        }
      }
    }

    NDivider { Layout.fillWidth: true; Layout.topMargin: Style.marginSmall * scaling; Layout.bottomMargin: Style.marginSmall * scaling }

    // UI section
    NText { text: "User Interface"; font.weight: Style.fontWeightBold; color: Colors.accentSecondary }

    NToggle {
      label: "Show Corners"
      description: "Display rounded corners on the edge of the screen"
      value: Settings.data.general.showScreenCorners
      onToggled: function (v) { Settings.data.general.showScreenCorners = v }
    }

    NToggle {
      label: "Show Dock"
      description: "Display a dock at the bottom of the screen for quick access to applications"
      value: Settings.data.general.showDock
      onToggled: function (v) { Settings.data.general.showDock = v }
    }

    NToggle {
      label: "Dim Desktop"
      description: "Dim the desktop when panels or menus are open"
      value: Settings.data.general.dimDesktop
      onToggled: function (v) { Settings.data.general.dimDesktop = v }
    }

    Item { Layout.fillHeight: true }
  }
}


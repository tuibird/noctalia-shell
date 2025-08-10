import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.Services
import qs.Widgets

/*
  An experiment/demo panel to tweaks widgets
*/

NLoader {
  id: root

  panel: Component {
    NPanel {
      id: sidePanel

      readonly property real scaling: Scaling.scale(screen)

      // Ensure panel shows itself once created
      Component.onCompleted: show()

      Rectangle {
        color: Colors.backgroundPrimary
        radius: Style.radiusMedium * scaling
        border.color: Colors.backgroundTertiary
        border.width: Math.min(1, Style.borderMedium * scaling)
        width: 500 * scaling
        height: 400
        anchors.centerIn: parent

        // Prevent closing when clicking in the panel bg
        MouseArea { anchors.fill: parent }

      }
    }
  }
}

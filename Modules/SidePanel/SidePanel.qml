import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.Services
import qs.Widgets

NLoader {
  id: root

  // X coordinate on screen (in pixels) where the panel should align its center.
  // Set via openAt(x) from the bar button.
  property real anchorX: 0
  // Target screen to open on
  property var targetScreen: null

  // Public API to open the panel aligned under a given x coordinate.
  function openAt(x, screen) {
    anchorX = x
    targetScreen = screen
    isLoaded = true
    // If the panel is already instantiated, update immediately
    if (item) {
      if (item.anchorX !== undefined)
        item.anchorX = anchorX
      if (item.screen !== undefined)
        item.screen = targetScreen
    }
  }

  panel: Component {
    NPanel {
      id: sidePanel

      readonly property real scaling: Scaling.scale(screen)
      // X coordinate from the bar to align this panel under
      property real anchorX: root.anchorX
      // Ensure this panel attaches to the intended screen
      screen: root.targetScreen

      // Ensure panel shows itself once created
      Component.onCompleted: show()

      Rectangle {
        color: Colors.backgroundPrimary
        radius: Style.radiusLarge * scaling
        border.color: Colors.backgroundTertiary
        border.width: Math.min(1, Style.borderMedium * scaling)
        width: 500 * scaling
        height: 400
        // Place the panel just below the bar (overlay content starts below bar due to topMargin)
        y: Style.marginSmall * scaling
        // Center horizontally under the anchorX, clamped to the screen bounds
        x: Math.max(
             Style.marginSmall * scaling,
             Math.min(parent.width - width - Style.marginSmall * scaling,
                      Math.round(anchorX - width / 2)))

        // Prevent closing when clicking in the panel bg
        MouseArea { anchors.fill: parent }

      }
    }
  }
}

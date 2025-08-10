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

  content: Component {
    NPanel {
      id: sidePanel

      readonly property real scaling: Scaling.scale(screen)
      // Single source of truth for spacing between cards (both axes)
      property real cardSpacing: Style.spacingLarge * scaling
      // X coordinate from the bar to align this panel under
      property real anchorX: root.anchorX
      // Ensure this panel attaches to the intended screen
      screen: root.targetScreen

      // Ensure panel shows itself once created
      Component.onCompleted: show()

      // Inline helpers moved to dedicated widgets: NCard and NCircleStat
      Rectangle {
        id: panelBackground
        color: Colors.backgroundPrimary
        radius: Style.radiusLarge * scaling
        border.color: Colors.backgroundTertiary
        border.width: Math.min(1, Style.borderMedium * scaling)
        layer.enabled: true
        width: 460 * scaling
        property real innerMargin: sidePanel.cardSpacing
        // Height scales to content plus vertical padding
        height: content.implicitHeight + innerMargin * 2
        // Place the panel just below the bar (overlay content starts below bar due to topMargin)
        y: Style.marginSmall * scaling
        // Center horizontally under the anchorX, clamped to the screen bounds
        x: Math.max(Style.marginSmall * scaling, Math.min(parent.width - width - Style.marginSmall * scaling,
                                                          Math.round(anchorX - width / 2)))

        // Prevent closing when clicking in the panel bg
        MouseArea {
          anchors.fill: parent
        }

        // Content wrapper to ensure childrenRect drives implicit height
        Item {
          id: content
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.top: parent.top
          anchors.margins: panelBackground.innerMargin
          implicitHeight: layout.implicitHeight

          // Layout content (not vertically anchored so implicitHeight is valid)
          ColumnLayout {
            id: layout
            // Use the same spacing value horizontally and vertically
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            spacing: sidePanel.cardSpacing

            // Cards (consistent inter-card spacing via ColumnLayout spacing)
            ProfileCard {
              Layout.topMargin: 0
              Layout.bottomMargin: 0
            }
            WeatherCard {
              Layout.topMargin: 0
              Layout.bottomMargin: 0
            }

            // Middle section: media + stats column
            RowLayout {
              Layout.fillWidth: true
              Layout.topMargin: 0
              Layout.bottomMargin: 0
              spacing: sidePanel.cardSpacing

              // Media card
              MediaCard {
                id: mediaCard
                Layout.fillWidth: true
                implicitHeight: statsCard.implicitHeight
              }

              // System monitors combined in one card
              SystemCard {
                id: statsCard
              }
            }

            // Bottom actions (two grouped rows of round buttons)
            RowLayout {
              Layout.fillWidth: true
              Layout.topMargin: 0
              Layout.bottomMargin: 0
              spacing: sidePanel.cardSpacing

              // Power Profiles: performance, balanced, eco
              NBox {
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                implicitHeight: powerRow.implicitHeight + Style.marginSmall * 2 * scaling
                RowLayout {
                  id: powerRow
                  anchors.fill: parent
                  anchors.margins: Style.marginSmall * scaling
                  spacing: sidePanel.cardSpacing
                  Item {
                    Layout.fillWidth: true
                  }
                  // Performance
                  NIconButton {
                    icon: "speed"
                    sizeMultiplier: 1.0
                    onClicked: function () {/* TODO: hook to power profile */ }
                  }
                  // Balanced
                  NIconButton {
                    icon: "balance"
                    sizeMultiplier: 1.0
                    onClicked: function () {/* TODO: hook to power profile */ }
                  }
                  // Eco
                  NIconButton {
                    icon: "eco"
                    sizeMultiplier: 1.0
                    onClicked: function () {/* TODO: hook to power profile */ }
                  }
                  Item {
                    Layout.fillWidth: true
                  }
                }
              }

              // Utilities: record & wallpaper
              NBox {
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                implicitHeight: utilRow.implicitHeight + Style.marginSmall * 2 * scaling
                RowLayout {
                  id: utilRow
                  anchors.fill: parent
                  anchors.margins: Style.marginSmall * scaling
                  spacing: sidePanel.cardSpacing
                  Item {
                    Layout.fillWidth: true
                  }
                  // Record
                  NIconButton {
                    icon: "fiber_manual_record"
                    sizeMultiplier: 1.0
                  }
                  // Wallpaper
                  NIconButton {
                    icon: "image"
                    sizeMultiplier: 1.0
                  }
                  Item {
                    Layout.fillWidth: true
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

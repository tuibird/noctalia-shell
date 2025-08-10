import QtQuick
import qs.Services

// Rounded group container using the variant surface color.
// To be used in side panels and settings panes to group fields or buttons.
Rectangle {
  id: root

  readonly property real scaling: Scaling.scale(screen)

  implicitWidth: childrenRect.width
  implicitHeight: childrenRect.height

  color: Colors.surfaceVariant
  radius: Style.radiusMedium * scaling
  border.color: Colors.backgroundTertiary
  border.width: Math.min(1, Style.borderThin * scaling)
  clip: true
}


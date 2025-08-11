import QtQuick
import qs.Services

// Generic themed card container
Rectangle {
  id: root

  readonly property real scaling: Scaling.scale(screen)

  implicitWidth: childrenRect.width
  implicitHeight: childrenRect.height

  color: Colors.backgroundSecondary
  radius: Style.radiusMedium * scaling
  border.color: Colors.backgroundTertiary
  border.width: Math.max(1, Style.borderThin * scaling)
}

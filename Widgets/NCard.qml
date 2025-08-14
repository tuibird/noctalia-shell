import QtQuick
import qs.Services

// Generic themed card container
Rectangle {
  id: root

  readonly property real scaling: Scaling.scale(screen)

  implicitWidth: childrenRect.width
  implicitHeight: childrenRect.height

  color: Colors.colorSurface
  radius: Style.radiusMedium * scaling
  border.color: Colors.colorSurfaceVariant
  border.width: Math.max(1, Style.borderThin * scaling)
}

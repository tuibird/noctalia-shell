import QtQuick
import qs.Services

// Generic card container
Rectangle {
  id: root

  readonly property real scaling: Scaling.scale(screen)

  implicitWidth: childrenRect.width
  implicitHeight: childrenRect.height

  color: Colors.mSurface
  radius: Style.radiusMedium * scaling
  border.color: Colors.mSurfaceVariant
  border.width: Math.max(1, Style.borderThin * scaling)
}

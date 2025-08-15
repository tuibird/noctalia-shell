import QtQuick
import qs.Services

// Generic card container
Rectangle {
  id: root

  implicitWidth: childrenRect.width
  implicitHeight: childrenRect.height

  color: Colors.mSurface
  radius: Style.radiusMedium * scaling
  border.color: Colors.mOutline
  border.width: Math.max(1, Style.borderThin * scaling)
}

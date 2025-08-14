import QtQuick
import qs.Services
import qs.Widgets

Text {
  id: root

  readonly property real scaling: Scaling.scale(screen)

  font.family: Settings.data.ui.fontFamily
  font.pointSize: Style.fontSizeMedium * scaling
  font.weight: Style.fontWeightRegular
  color: Colors.mOnSurface
}

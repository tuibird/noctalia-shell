import QtQuick
import qs.Services
import qs.Widgets

Text {
  id: root

  readonly property real scaling: Scaling.scale(screen)

  font.family: Settings.settings.fontFamily
  font.pointSize: Style.fontSizeMedium * scaling
  font.weight: Font.Bold
  color: Colors.textPrimary
}

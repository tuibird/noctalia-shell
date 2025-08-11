import QtQuick
import QtQuick.Layouts
import qs.Services
import qs.Widgets

Item {
  property real scaling: 1
  readonly property string tabIcon: "more_horiz"
  readonly property string tabLabel: "Misc"
  readonly property int tabIndex: 7
  anchors.fill: parent

  ColumnLayout {
    anchors.fill: parent
    spacing: Style.marginMedium * scaling
    NText {
      text: "Misc"
      font.weight: Style.fontWeightBold
      color: Colors.accentSecondary
    }
    NText {
      text: "Coming soon"
      color: Colors.textSecondary
    }
    Item {
      Layout.fillHeight: true
    }
  }
}

import QtQuick
import QtQuick.Layouts
import qs.Services
import qs.Widgets

Item {
  property real scaling: 1
  readonly property string tabIcon: "wifi"
  readonly property string tabLabel: "Network"
  readonly property int tabIndex: 4
  anchors.fill: parent

  ColumnLayout {
    anchors.fill: parent
    spacing: Style.marginMedium * scaling
    NText {
      text: "Network"
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

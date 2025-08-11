import QtQuick
import QtQuick.Layouts
import qs.Services
import qs.Widgets

Item {
  // Optional scaling prop to match other tabs
  property real scaling: 1
  // Tab metadata
  readonly property string tabIcon: "web_asset"
  readonly property string tabLabel: "Bar"
  readonly property int tabIndex: 1
  anchors.fill: parent

  ColumnLayout {
    anchors.fill: parent
    spacing: Style.marginMedium * scaling
    NText {
      text: "Bar"
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

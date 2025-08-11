import QtQuick
import QtQuick.Layouts
import qs.Services
import qs.Widgets

Item {
  property real scaling: 1
  readonly property string tabIcon: "videocam"
  readonly property string tabLabel: "Screen Recorder"
  readonly property int tabIndex: 3
  anchors.fill: parent

  ColumnLayout {
    anchors.fill: parent
    spacing: Style.marginMedium * scaling
    NText { text: "Screen Recorder"; font.weight: Style.fontWeightBold; color: Colors.accentSecondary }
    NText { text: "Coming soon"; color: Colors.textSecondary }
    Item { Layout.fillHeight: true }
  }
}


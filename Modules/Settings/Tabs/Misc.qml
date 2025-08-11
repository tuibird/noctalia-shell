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
      text: "Media"
      font.weight: Style.fontWeightBold
      color: Colors.accentSecondary
    }

    NText { text: "Visualizer Type"; color: Colors.textPrimary; font.weight: Style.fontWeightBold }
    NText { text: "Choose the style of the audio visualizer"; color: Colors.textSecondary }

    NComboBox {
      id: visualizerTypeComboBox
      optionsKeys: ["radial", "fire", "diamond"]
      optionsLabels: ["Radial", "Fire", "Diamond"]
      currentKey: Settings.data.audioVisualizer.type
      onSelected: function (key) { Settings.data.audioVisualizer.type = key }
    }

    Item { Layout.fillHeight: true }
  }
}

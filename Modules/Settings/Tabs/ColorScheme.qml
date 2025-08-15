import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Services
import qs.Widgets

ColumnLayout {
  id: root

  spacing: 0

  // property var colorSchemes: [{
  //     "label": "Generated from Wallpaper (Matugen required)"
  //   }, {
  //     "label": "Catppuccin"
  //   }, {
  //     "label": "Dracula"
  //   }, {
  //     "label": "Gruvbox"
  //   }, {
  //     "label": "Nord"
  //     "file": "nord.json"
  //   }, , {
  //     "label": "Rosé Pine",
  //     "file": "rosepine.json"
  //   }]

  ScrollView {
    id: scrollView

    Layout.fillWidth: true
    Layout.fillHeight: true
    padding: Style.marginMedium * scaling
    clip: true
    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
    ScrollBar.vertical.policy: ScrollBar.AsNeeded

    ColumnLayout {
      width: scrollView.availableWidth
      spacing: 0

      Item {
        Layout.fillWidth: true
        Layout.preferredHeight: 0
      }

      ColumnLayout {
        spacing: Style.marginLarge * scaling
        Layout.fillWidth: true

        NText {
          text: "TODO"
          font.pointSize: Style.fontSizeXL * scaling
          font.weight: Style.fontWeightBold
          color: Colors.mOnSurface
        }

        ButtonGroup {
          id: schemes
        }

        // Repeater {
        //   model: root.colorSchemes
        //   ButtonGroup.group: schemes
        //   NRadioButton {
        //     // checked: Audio.sink?.id === modelData.id
        //     //onClicked: Audio.setAudioSink(modelData)
        //     text: modelData.label
        //   }
        // }
      }
    }
  }
}

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Services
import qs.Widgets

ColumnLayout {
  id: root

  readonly property real scaling: Scaling.scale(screen)
  readonly property real preferredHeight: Style.baseWidgetSize * 1.25 * scaling

  property string label: ""
  property string description: ""
  property list<string> optionsKeys: []
  property list<string> optionsLabels: []
  property string currentKey: ''

  signal selected(string key)

  spacing: Style.marginSmall * scaling
  Layout.fillWidth: true

  ColumnLayout {
    spacing: Style.marginTiniest * scaling
    Layout.fillWidth: true

    NText {
      text: label
      font.pointSize: Style.fontSizeMedium * scaling
      font.weight: Style.fontWeightBold
      color: Colors.colorOnSurface
    }

    NText {
      text: description
      font.pointSize: Style.fontSizeSmall * scaling
      color: Colors.colorOnSurface
      wrapMode: Text.WordWrap
    }
  }

  ComboBox {
    id: combo

    Layout.fillWidth: true
    Layout.preferredHeight: height

    model: optionsKeys
    currentIndex: model.indexOf(currentKey)
    onActivated: {
      root.selected(model[combo.currentIndex])
    }

    // Rounded background
    background: Rectangle {
      implicitWidth: 120 * scaling
      implicitHeight: preferredHeight
      color: Colors.colorSurface
      border.color: combo.activeFocus ? Colors.colorTertiary : Colors.colorOutline
      border.width: Math.max(1, Style.borderThin * scaling)
      radius: Style.radiusMedium * scaling
    }

    // Label (currently selected)
    contentItem: NText {
      leftPadding: Style.marginLarge * scaling
      rightPadding: combo.indicator.width + Style.marginLarge * scaling
      font.pointSize: Style.fontSizeMedium * scaling
      verticalAlignment: Text.AlignVCenter
      elide: Text.ElideRight
      text: (combo.currentIndex >= 0
             && combo.currentIndex < root.optionsLabels.length) ? root.optionsLabels[combo.currentIndex] : ""
    }

    // Drop down indicator
    indicator: NText {
      x: combo.width - width - Style.marginMedium * scaling
      y: combo.topPadding + (combo.availableHeight - height) / 2
      text: "arrow_drop_down"
      font.family: "Material Symbols Outlined"
      font.pointSize: Style.fontSizeXL * scaling
    }

    popup: Popup {
      y: combo.height
      width: combo.width
      implicitHeight: Math.min(160 * scaling, contentItem.implicitHeight + Style.marginMedium * scaling * 2)
      padding: Style.marginMedium * scaling

      contentItem: ListView {
        clip: true
        implicitHeight: contentHeight
        model: combo.popup.visible ? combo.delegateModel : null
        currentIndex: combo.highlightedIndex
        ScrollIndicator.vertical: ScrollIndicator {}
      }

      background: Rectangle {
        color: Colors.colorSurfaceVariant
        border.color: Colors.colorOutline
        border.width: Math.max(1, Style.borderThin * scaling)
        radius: Style.radiusMedium * scaling
      }
    }

    delegate: ItemDelegate {
      width: combo.width
      highlighted: combo.highlightedIndex === index

      contentItem: NText {
        text: (combo.model.indexOf(modelData) >= 0 && combo.model.indexOf(
                 modelData) < root.optionsLabels.length) ? root.optionsLabels[combo.model.indexOf(modelData)] : ""
        font.pointSize: Style.fontSizeMedium * scaling
        color: highlighted ? Colors.colorSurface : Colors.colorOnSurface
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
      }

      background: Rectangle {
        width: combo.width - Style.marginMedium * scaling * 3
        color: highlighted ? Colors.colorTertiary : "transparent"
        radius: Style.radiusSmall * scaling
      }
    }
  }
}

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Services
import qs.Widgets

ComboBox {
  id: root

  readonly property real scaling: Scaling.scale(screen)

  property list<string> optionsKeys: []
  property list<string> optionsLabels: []
  property string currentKey: ''
  property var onSelected: function (string) {}

  Layout.fillWidth: true
  Layout.preferredHeight: Style.baseWidgetSize * scaling

  model: optionsKeys
  currentIndex: model.indexOf(currentKey)
  onActivated: {
    root.onSelected(model[currentIndex])
  }

  // Rounded background
  background: Rectangle {
    implicitWidth: 120 * scaling
    implicitHeight: Style.baseWidgetSize * scaling
    color: Colors.surfaceVariant
    border.color: root.activeFocus ? Colors.hover : Colors.outline
    border.width: Math.max(1, Style.borderThin * scaling)
    radius: Style.radiusMedium * scaling
  }

  // Label (currently selected)
  contentItem: NText {
    leftPadding: Style.spacingLarge * scaling
    rightPadding: root.indicator.width + Style.spacingLarge * scaling
    font.pointSize: Style.fontSizeMedium * scaling
    font.weight: Style.fontWeightBold
    verticalAlignment: Text.AlignVCenter
    elide: Text.ElideRight
    text: {
      return root.optionsLabels[root.currentIndex]
    }
  }

  // Drop down indicator
  indicator: NText {
    x: root.width - width - Style.spacingMedium * scaling
    y: root.topPadding + (root.availableHeight - height) / 2
    text: "arrow_drop_down"
    font.family: "Material Symbols Outlined"
    font.pointSize: Style.fontSizeXL * scaling
  }

  popup: Popup {
    y: root.height
    width: root.width
    implicitHeight: Math.min(160 * scaling, contentItem.implicitHeight + Style.spacingMedium * scaling * 2)
    padding: Style.spacingMedium * scaling

    contentItem: ListView {
      clip: true
      implicitHeight: contentHeight
      model: root.popup.visible ? root.delegateModel : null
      currentIndex: root.highlightedIndex
      ScrollIndicator.vertical: ScrollIndicator {}
    }

    background: Rectangle {
      color: Colors.surfaceVariant
      border.color: Colors.outline
      border.width: Math.max(1, Style.borderThin * scaling)
      radius: Style.radiusMedium * scaling
    }
  }

  delegate: ItemDelegate {
    width: root.width
    highlighted: root.highlightedIndex === index

    contentItem: NText {
      text: {
        return root.optionsLabels[root.model.indexOf(modelData)]
      }
      font.pointSize: Style.fontSizeMedium * scaling
      color: highlighted ? Colors.backgroundPrimary : Colors.textPrimary
      verticalAlignment: Text.AlignVCenter
      elide: Text.ElideRight
    }

    background: Rectangle {
      width: root.width - Style.spacingMedium * scaling * 3
      color: highlighted ? Colors.hover : "transparent"
      radius: Style.radiusSmall * scaling
    }
  }
}

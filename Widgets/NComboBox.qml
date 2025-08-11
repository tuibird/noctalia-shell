import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Services
import qs.Widgets

ComboBox {
  id: root

  readonly property real scaling: Scaling.scale(screen)
  property list<string> optionsKeys: ['cat', 'dog', 'bird']
  property list<string> optionsLabels: ['Cat ', 'Dog', 'Bird']
  property string currentKey: "cat"
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
    implicitHeight: 40 * scaling
    color: Colors.surfaceVariant
    border.color: root.activeFocus ? Colors.highlight : Colors.outline
    border.width: Math.max(1, Style.borderThin * scaling)
    radius: Style.radiusMedium * scaling
  }

  // Label (currently selected)
  contentItem: NText {
    leftPadding: Style.spacingLarge * scaling
    rightPadding: root.indicator.width + Style.spacingLarge * scaling
    font.pointSize: Style.fontSizeMedium * scaling
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
    implicitHeight: contentItem.implicitHeight
    padding: 1

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

    contentItem: Text {
      text: {
        return root.optionsLabels[root.model.indexOf(modelData)]
      }
      font.pointSize: Style.fontSizeSmall * scaling
      color: highlighted ? Colors.backgroundPrimary : Colors.textPrimary
      verticalAlignment: Text.AlignVCenter
      elide: Text.ElideRight
    }

    background: Rectangle {
      color: highlighted ? Colors.highlight : "transparent"
    }
  }
}

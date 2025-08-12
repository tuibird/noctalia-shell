import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Services

Item {
  id: root

  readonly property real scaling: Scaling.scale(screen)
  property string label: ""
  property string description: ""
  property bool readOnly: false
  property bool enabled: true

  property alias text: input.text
  property alias placeholderText: input.placeholderText

  signal editingFinished

  // Sizing
  implicitWidth: 320 * scaling
  implicitHeight: Style.baseWidgetSize * 2.75 * scaling

  ColumnLayout {
    spacing: Style.marginTiniest * scaling
    Layout.fillWidth: true

    NText {
      text: label
      font.pointSize: Style.fontSizeMedium * scaling
      font.weight: Style.fontWeightBold
      color: Colors.textPrimary
    }

    NText {
      text: description
      font.pointSize: Style.fontSizeSmall * scaling
      color: Colors.textSecondary
      wrapMode: Text.WordWrap
      Layout.fillWidth: true
    }

    // Container
    Rectangle {
      id: frame
      Layout.topMargin: Style.marginTiny * scaling
      implicitWidth: root.width
      implicitHeight: Style.baseWidgetSize * 1.35 * scaling
      radius: Style.radiusMedium * scaling
      color: Colors.surfaceVariant
      border.color: Colors.outline
      border.width: Math.max(1, Style.borderThin * scaling)

      // Focus ring
      Rectangle {
        anchors.fill: parent
        radius: frame.radius
        color: "transparent"
        border.color: input.activeFocus ? Colors.hover : "transparent"
        border.width: input.activeFocus ? Math.max(1, Style.borderThin * scaling) : 0
      }

      RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Style.marginMedium * scaling
        anchors.rightMargin: Style.marginMedium * scaling
        spacing: Style.marginSmall * scaling

        // Optional leading icon slot in the future
        // Item { Layout.preferredWidth: 0 }
        TextField {
          id: input
          Layout.fillWidth: true
          echoMode: TextInput.Normal
          readOnly: root.readOnly
          enabled: root.enabled
          color: Colors.textPrimary
          placeholderTextColor: Colors.textSecondary
          background: null
          font.pointSize: Style.fontSizeSmall * scaling
          onEditingFinished: root.editingFinished()
          // Text changes are observable via the aliased 'text' property (root.text) and its 'textChanged' signal.
          // No additional callback is invoked here to avoid conflicts with QML's onTextChanged handler semantics.
        }
      }
    }
  }
}

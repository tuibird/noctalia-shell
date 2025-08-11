import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Services

Item {
  id: root

  readonly property real scaling: Scaling.scale(screen)

  // API
  property alias text: input.text
  property alias placeholderText: input.placeholderText
  property bool readOnly: false
  property bool enabled: true
  property var onEditingFinished: function () {}

  // Sizing
  implicitHeight: Style.baseWidgetSize * 1.25 * scaling
  implicitWidth: 320 * scaling

  // Container
  Rectangle {
    id: frame
    anchors.fill: parent
    radius: Style.radiusMedium * scaling
    color: Colors.surfaceVariant
    border.color: Colors.outline
    border.width: Math.max(1, Style.borderThin * scaling)

    // Focus ring
    Rectangle {
      anchors.fill: parent
      radius: frame.radius
      color: "transparent"
      border.color: input.activeFocus ? Colors.accentPrimary : "transparent"
      border.width: input.activeFocus ? Math.max(1, Style.borderMedium * scaling) : 0
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
        font.pointSize: Colors.fontSizeSmall * scaling
        onEditingFinished: root.onEditingFinished()
        // Text changes are observable via the aliased 'text' property (root.text) and its 'textChanged' signal.
        // No additional callback is invoked here to avoid conflicts with QML's onTextChanged handler semantics.
      }
    }
  }
}


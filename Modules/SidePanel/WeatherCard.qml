import QtQuick
import QtQuick.Layouts
import qs.Services
import qs.Widgets

// Weather overview card (placeholder data)
NBox {
  id: root

  readonly property real scaling: Scaling.scale(screen)

  Layout.fillWidth: true
  // Height driven by content
  implicitHeight: content.implicitHeight + Style.marginLarge * 2 * scaling

  ColumnLayout {
    id: content
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.margins: Style.marginMedium * scaling
    spacing: Style.marginMedium * scaling

    RowLayout {
      spacing: Style.marginSmall * scaling
      Text {
        text: "sunny"
        font.family: "Material Symbols Outlined"
        font.pointSize: Style.fontSizeXXL * 1.25 * scaling
        color: Colors.accentSecondary
      }
      ColumnLayout {
        NText {
          text: "Dinslaken (GMT+2)"
        }
        NText {
          text: "26°C"
          font.pointSize: (Style.fontSizeXL + 6) * scaling
          font.weight: Style.fontWeightBold
        }
      }
    }

    Rectangle {
      height: 1
      width: parent.width
      color: Colors.backgroundTertiary
    }

    RowLayout {
      Layout.fillWidth: true
      spacing: Style.marginMedium * scaling
      Repeater {
        model: 5
        delegate: ColumnLayout {
          spacing: 2 * scaling
          NText {
            text: ["Sun", "Mon", "Tue", "Wed", "Thu"][index]
            font.weight: Style.fontWeightBold
          }
          NText {
            text: index % 2 === 0 ? "wb_sunny" : "cloud"
            font.family: "Material Symbols Outlined"
            font.weight: Style.fontWeightBold
            color: Colors.textSecondary
          }
          NText {
            text: "26° / 14°"
            color: Colors.textSecondary
          }
        }
      }
    }
  }
}

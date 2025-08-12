import QtQuick
import QtQuick.Layouts
import qs.Services
import qs.Widgets

// Media player area (placeholder until MediaPlayer service is wired)
NBox {
  id: root

  readonly property real scaling: Scaling.scale(screen)

  Layout.fillWidth: true
  // Let content dictate the height (no hardcoded height here)
  // Height can be overridden by parent layout (SidePanel binds it to stats card)
  implicitHeight: content.implicitHeight + Style.marginLarge * 2 * scaling

  Column {
    id: content
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.margins: Style.marginMedium * scaling
    spacing: Style.marginMedium * scaling

    Item {
      height: Style.marginLarge * scaling
    }

    Text {
      text: "music_note"
      font.family: "Material Symbols Outlined"
      font.pointSize: 28 * scaling
      color: Colors.textSecondary
      anchors.horizontalCenter: parent.horizontalCenter
    }
    NText {
      text: "No music player detected"
      color: Colors.textSecondary
      horizontalAlignment: Text.AlignHCenter
      anchors.horizontalCenter: parent.horizontalCenter
    }

    Item {
      height: Style.marginLarge * scaling
    }
  }
}

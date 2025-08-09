import QtQuick
import Quickshell
import QtQuick.Controls
import QtQuick.Layouts
import qs.Widgets
import qs.Theme

PanelWindow {
  id: root

  property var modelData

  screen: modelData
  implicitHeight: 36
  color: "transparent"

  anchors {
    top: true
    left: true
    right: true
  }

  Item {
    anchors.fill: parent

    Rectangle {
      anchors.fill: parent
      color: Theme.backgroundPrimary
      layer.enabled: true
    }

    RowLayout {
      // Just testing
      NoctaliaToggle {
        label: "Label"
        description: "Description"
      }

      NoctaliaIconButton {
        icon: "refresh"
      }
    }
  }
}

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.Services
import qs.Widgets

// Utilities: record & wallpaper
NBox {
  Layout.fillWidth: true
  Layout.preferredWidth: 1
  implicitHeight: utilRow.implicitHeight + Style.marginMedium * 2 * scaling
  RowLayout {
    id: utilRow
    anchors.fill: parent
    anchors.margins: Style.marginSmall * scaling
    spacing: sidePanel.cardSpacing
    Item {
      Layout.fillWidth: true
    }
    // Record
    NIconButton {
      icon: "fiber_manual_record"
    }
    // Wallpaper
    NIconButton {
      icon: "image"
    }
    Item {
      Layout.fillWidth: true
    }
  }
}

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.Services
import qs.Widgets

// Power Profiles: performance, balanced, eco
NBox {
  Layout.fillWidth: true
  Layout.preferredWidth: 1
  implicitHeight: powerRow.implicitHeight + Style.marginMedium * 2 * scaling
  RowLayout {
    id: powerRow
    anchors.fill: parent
    anchors.margins: Style.marginSmall * scaling
    spacing: sidePanel.cardSpacing
    Item {
      Layout.fillWidth: true
    }
    // Performance
    NIconButton {
      icon: "speed"
      onClicked: function () {/* TODO: hook to power profile */ }
    }
    // Balanced
    NIconButton {
      icon: "balance"
      onClicked: function () {/* TODO: hook to power profile */ }
    }
    // Eco
    NIconButton {
      icon: "eco"
      onClicked: function () {/* TODO: hook to power profile */ }
    }
    Item {
      Layout.fillWidth: true
    }
  }
}

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower
import qs.Services
import qs.Widgets

// Power Profiles: performance, balanced, eco
NBox {
  Layout.fillWidth: true
  Layout.preferredWidth: 1
  implicitHeight: powerRow.implicitHeight + Style.marginMedium * 2 * scaling

  // PowerProfiles service
  property var powerProfiles: PowerProfiles

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
      enabled: powerProfiles.hasPerformanceProfile
      opacity: enabled ? 1.0 : 0.3
      showFilled: powerProfiles.profile === PowerProfile.Performance
      showBorder: powerProfiles.profile !== PowerProfile.Performance
      onClicked: {
        if (powerProfiles.hasPerformanceProfile) {
          powerProfiles.profile = PowerProfile.Performance
        }
      }
    }
    // Balanced
    NIconButton {
      icon: "balance"
      showFilled: powerProfiles.profile === PowerProfile.Balanced
      showBorder: powerProfiles.profile !== PowerProfile.Balanced
      onClicked: {
        powerProfiles.profile = PowerProfile.Balanced
      }
    }
    // Eco
    NIconButton {
      icon: "eco"
      showFilled: powerProfiles.profile === PowerProfile.PowerSaver
      showBorder: powerProfiles.profile !== PowerProfile.PowerSaver
      onClicked: {
        powerProfiles.profile = PowerProfile.PowerSaver
      }
    }
    Item {
      Layout.fillWidth: true
    }
  }
}

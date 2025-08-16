import QtQuick
import Quickshell
import qs.Commons
import qs.Modules.SettingsPanel
import qs.Services
import qs.Widgets

Item {
  id: root

  width: pill.width
  height: pill.height
  visible: !Settings.data.bar.hideBrightness

  // Used to avoid opening the pill on Quickshell startup
  property bool firstBrightnessReceived: false
  property real lastBrightness: -1

  function getIcon() {
    if (!BrightnessService.available) {
      return "brightness_auto"
    }
    var brightness = BrightnessService.brightness
    return brightness <= 0 ? "brightness_1" : brightness < 33 ? "brightness_low" : brightness < 66 ? "brightness_medium" : "brightness_high"
  }

  // Connection used to open the pill when brightness changes
  Connections {
    target: BrightnessService.focusedMonitor
    function onBrightnessUpdated() {
      var currentBrightness = BrightnessService.brightness

      // Ignore if this is the first time or if brightness hasn't actually changed
      if (!firstBrightnessReceived) {
        firstBrightnessReceived = true
        lastBrightness = currentBrightness
        return
      }

      // Only show pill if brightness actually changed (not just loaded from settings)
      if (Math.abs(currentBrightness - lastBrightness) > 0.1) {
        pill.show()
      }

      lastBrightness = currentBrightness
    }
  }

  NPill {
    id: pill
    icon: getIcon()
    iconCircleColor: Colors.mPrimary
    collapsedIconColor: Colors.mOnSurface
    autoHide: false // Important to be false so we can hover as long as we want
    text: Math.round(BrightnessService.brightness) + "%"
    tooltipText: "Brightness: " + Math.round(
                   BrightnessService.brightness) + "%\nMethod: " + BrightnessService.currentMethod
                 + "\nLeft click for advanced settings.\nScroll up/down to change brightness."

    onWheel: function (angle) {
      if (!BrightnessService.available)
        return

      if (angle > 0) {
        BrightnessService.increaseBrightness()
      } else if (angle < 0) {
        BrightnessService.decreaseBrightness()
      }
    }
    onClicked: {
      settingsPanel.requestedTab = SettingsPanel.Tab.Brightness
      settingsPanel.isLoaded = true
    }
  }
}

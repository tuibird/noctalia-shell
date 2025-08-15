import QtQuick
import Quickshell
import qs.Modules.Settings
import qs.Services
import qs.Widgets

Item {
  id: root

  width: pill.width
  height: pill.height

  // Used to avoid opening the pill on Quickshell startup
  property bool firstBrightnessReceived: false

  function getIcon() {
    if (!BrightnessService.available) {
      return "brightness_auto"
    }
    var brightness = BrightnessService.brightness
    return brightness <= 0 ? "brightness_1" : 
           brightness < 33 ? "brightness_low" : 
           brightness < 66 ? "brightness_medium" : "brightness_high"
  }

  // Connection used to open the pill when brightness changes
  Connections {
    target: Brightness
    function onBrightnessUpdated() {
      // console.log("[Bar:Brightness] onBrightnessUpdated")
      if (!firstBrightnessReceived) {
        // Ignore the first brightness change
        firstBrightnessReceived = true
      } else {
        pill.show()
      }
    }
  }

  NPill {
    id: pill
    icon: getIcon()
    iconCircleColor: Colors.mPrimary
    collapsedIconColor: Colors.mOnSurface
    autoHide: true
    text: Math.round(BrightnessService.brightness) + "%"
    tooltipText: "Brightness: " + Math.round(BrightnessService.brightness) + "%\nMethod: " + BrightnessService.currentMethod + "\nLeft click for advanced settings.\nScroll up/down to change BrightnessService."

    onWheel: function (angle) {
      if (!BrightnessService.available) return
      
      if (angle > 0) {
        BrightnessService.increaseBrightness(1)
      } else if (angle < 0) {
        BrightnessService.decreaseBrightness(1)
      }
    }
    onClicked: {
      settingsPanel.requestedTab = SettingsPanel.Tab.Display
      settingsPanel.isLoaded = true
    }
  }
} 
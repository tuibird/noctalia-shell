import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import qs.Modules.Settings
import qs.Services
import qs.Widgets

Item {
  id: root

  width: pill.width
  height: pill.height

  // Used to avoid opening the pill on Quickshell startup
  property bool firstVolumeReceived: false

  function getIcon() {
    if (Audio.muted) {
      return "volume_off"
    }
    return Audio.volume <= Number.EPSILON ? "volume_off" : (Audio.volume < 0.33 ? "volume_down" : "volume_up")
  }

  // Connection used to open the pill when volume changes
  Connections {
    target: Audio.sink?.audio ? Audio.sink?.audio : null
    function onVolumeChanged() {
      // console.log("[Bar:Volume] onVolumeChanged")
      if (!firstVolumeReceived) {
        // Ignore the first volume change
        firstVolumeReceived = true
      } else {
        pill.show()
        externalHideTimer.restart()
      }
    }
  }

  Timer {
    id: externalHideTimer
    running: false
    interval: 1500
    onTriggered: {
      pill.hide()
    }
  }

  NPill {
    id: pill
    icon: getIcon()
    iconCircleColor: Colors.mPrimary
    collapsedIconColor: Colors.mOnSurface
    autoHide: false // Important to be false so we can hover as long as we want
    text: Math.floor(Audio.volume * 100) + "%"
    tooltipText: "Volume: " + Math.round(
                   Audio.volume * 100) + "%\nLeft click for advanced settings.\nScroll up/down to change volume."

    onWheel: function (angle) {
      if (angle > 0) {
        Audio.increaseVolume()
      } else if (angle < 0) {
        Audio.decreaseVolume()
      }
    }
    onClicked: {
      settingsPanel.requestedTab = SettingsPanel.Tab.Audio
      settingsPanel.isLoaded = true
    }
  }
}

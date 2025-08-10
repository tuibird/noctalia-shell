import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import qs.Services
import qs.Modules.Audio
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
    return Audio.volume === 0 ? "volume_off" : (Audio.volume < 0.33 ? "volume_down" : "volume_up")
  }

  function getIconColor() {
    return (Audio.volume <= 1.0) ? Colors.textPrimary : getVolumeColor()
  }

  function getVolumeColor() {
    if (Audio.volume <= 1.0) {
      return Colors.accentPrimary
    }

    // Indicate that the volume is over 100%
    // Calculate interpolation factor (0 at 100%, 1.0 at 200%)
    let factor = (Audio.volume - 1.0)

    // Blend between accent and warning colors
    return Qt.rgba(Colors.accentPrimary.r + (Colors.error.r - Colors.accentPrimary.r) * factor,
                   Colors.accentPrimary.g + (Colors.error.g - Colors.accentPrimary.g) * factor,
                   Colors.accentPrimary.b + (Colors.error.b - Colors.accentPrimary.b) * factor, 1)
  }

  NPill {
    id: pill
    icon: getIcon()
    iconCircleColor: getVolumeColor()
    collapsedIconColor: getIconColor()
    autoHide: true
    text: Math.round(Audio.volume * 100) + "%"
    tooltipText: "Volume: " + Math.round(
                   Audio.volume * 100) + "%\nLeft click for advanced settings.\nScroll up/down to change volume."
    onClicked: function () {
      console.log("onClicked")
      // if (ioSelector.visible) {
      //   ioSelector.dismiss()
      // } else {
      //   ioSelector.show()
      // }
    }
    onWheel: function (angle) {
      if (angle > 0) {
        Audio.volumeIncrement()
      } else if (angle < 0) {
        Audio.volumeDecrement()
      }
    }
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
      }
    }
  }

  AudioDeviceSelector {
    id: ioSelector
    //     onPanelClosed: ioSelector.dismiss()
  }
}

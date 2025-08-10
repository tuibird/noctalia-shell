import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import qs.Services
import qs.Modules.Audio
import qs.Widgets

Item {
  id: volumeDisplay

  width: pillIndicator.width
  height: pillIndicator.height

  function getIcon() {
    if (Audio.muted) {
      return "volume_off"
    }
    return Audio.volume === 0 ? "volume_off" : (Audio.volume < 0.33 ? "volume_down" : "volume_up")
  }

  function getIconColor() {
    return (Audio.volume <= 1.0) ? Colors.textPrimary : getVolumeColor();
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
    id: pillIndicator
    icon: getIcon()
    iconCircleColor: getVolumeColor()
    collapsedIconColor: getIconColor()
    autoHide: true
    text: Math.round(Audio.volume * 100) + "%"
    tooltipText: "Volume: " + Math.round(
                   Audio.volume * 100) + "%\nLeft click for advanced settings.\nScroll up/down to change volume."
    onClicked: function () {
      console.log("onClicked")
      //if (ioSelector.visible) {
      //             ioSelector.dismiss();
      //         } else {
      //             ioSelector.show();
      //         }
    }
  }

  Connections {
    target: Pipewire.defaultAudioSink?.audio ? Pipewire.defaultAudioSink?.audio : null

    function onVolumeChanged() {
      console.log("[Bar:Volume] onVolumeChanged")
    }
  }

  AudioDeviceSelector {
    id: ioSelector
    //     onPanelClosed: ioSelector.dismiss()
  }

  //     Connections {
  //       target: Audio
  //     function onVolumeChanged() {
  //       console.log("onVolumeChanged")
  //     }

  //     function onSinkChanged() {
  // console.log("onSinkChanged")
  //     }

  //   }

  // MouseArea {
  //   anchors.fill: parent
  //   hoverEnabled: true
  //   acceptedButtons: Qt.NoButton
  //   propagateComposedEvents: true
  //   onEntered: {
  //     volumeDisplay.containsMouse = true
  //     pillIndicator.autoHide = false
  //     pillIndicator.showDelayed()
  //   }
  //   onExited: {
  //     volumeDisplay.containsMouse = false
  //     pillIndicator.autoHide = true
  //     pillIndicator.hide()
  //   }
  //   cursorShape: Qt.PointingHandCursor
  //   onWheel: wheel => {
  //              if (!shell)
  //              return
  //              let step = 5
  //              if (wheel.angleDelta.y > 0) {
  //                shell.updateVolume(Math.min(200, shell.volume + step))
  //              } else if (wheel.angleDelta.y < 0) {
  //                shell.updateVolume(Math.max(0, shell.volume - step))
  //              }
  //            }
  // }
}

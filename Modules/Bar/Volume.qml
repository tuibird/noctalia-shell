import QtQuick
import Quickshell
import qs.Services
import qs.Modules.Audio
import qs.Widgets

Item {
  id: volumeDisplay

  width: pillIndicator.width
  height: pillIndicator.height

  function getIcon() {
    if (PipeWireAudio.muted) {
      return "volume_off"
    }
    return PipeWireAudio.volume === 0 ? "volume_off" : (PipeWireAudio.volume < 0.33 ? "volume_down" : "volume_up")
  }

  function getIconColor() {
    if (PipeWireAudio.volume <= 1.0) {
      return Colors.textPrimary
    }

    // Indicate that the volume is over 100%
    // Calculate interpolation factor (0 at 100%, 1.0 at 200%)
    let factor = (PipeWireAudio.volume - 1)

    // Blend between accent and warning colors
    return Qt.rgba(Colors.textPrimary.r + (Colors.warning.r - Colors.textPrimary.r) * factor,
                   Colors.textPrimary.g + (Colors.warning.g - Colors.textPrimary.g) * factor,
                   Colors.textPrimary.b + (Colors.warning.b - Colors.textPrimary.b) * factor, 1)
  }

  NPill {
    id: pillIndicator
    icon: getIcon()
    text: Math.round(PipeWireAudio.volume * 100) + "%"
    tooltipText: "Volume: " + Math.round(
                   PipeWireAudio.volume * 100) + "%\nLeft click for advanced settings.\nScroll up/down to change volume."
    onClicked: function () {
      console.log("onClicked")
      //if (ioSelector.visible) {
      //             ioSelector.dismiss();
      //         } else {
      //             ioSelector.show();
      //         }
    }

    // pillColor: Colors.surfaceVariant
    // iconCircleColor: Colors.// getVolumeColor()
    // iconTextColor: Colors.backgroundPrimary
    // textColor: Colors.textPrimary
    // collapsedIconColor: getIconColor()
    // autoHide: true
  }

  AudioDeviceSelector {
    id: ioSelector
    //     onPanelClosed: ioSelector.dismiss()
  }

  //     Connections {
  //       target: PipeWireAudio
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

  // property bool containsMouse: false
}

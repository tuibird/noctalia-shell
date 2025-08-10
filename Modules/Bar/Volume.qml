import QtQuick
import Quickshell
import qs.Services
import qs.Modules.Audio
import qs.Widgets

Item {
  id: volumeDisplay
  property var shell
  property int volume: 0
  property bool firstChange: true

  width: pillIndicator.width
  height: pillIndicator.height

  function getVolumeColor() {
    if (volume <= 100)
      return Colors.accentPrimary
    // Calculate interpolation factor (0 at 100%, 1 at 200%)
    var factor = (volume - 100) / 100
    // Blend between accent and warning colors
    return Qt.rgba(Colors.accentPrimary.r + (Colors.warning.r - Colors.accentPrimary.r) * factor,
                   Colors.accentPrimary.g + (Colors.warning.g - Colors.accentPrimary.g) * factor,
                   Colors.accentPrimary.b + (Colors.warning.b - Colors.accentPrimary.b) * factor, 1)
  }

  function getIconColor() {
    if (volume <= 100)
      return Colors.textPrimary
    return getVolumeColor() // Only use warning blend when >100%
  }

  NPill {
    id: pillIndicator
    icon: shell && shell.defaultAudioSink && shell.defaultAudioSink.audio
          && shell.defaultAudioSink.audio.muted ? "volume_off" : (volume === 0 ? "volume_off" : (volume < 30 ? "volume_down" : "volume_up"))
    text: volume + "%"

    pillColor: Colors.surfaceVariant
    iconCircleColor: getVolumeColor()
    iconTextColor: Colors.backgroundPrimary
    textColor: Colors.textPrimary
    collapsedIconColor: getIconColor()
    autoHide: true

    // StyledTooltip {
    //     id: volumeTooltip
    //     text: "Volume: " + volume + "%\nLeft click for advanced settings.\nScroll up/down to change volume."
    //     positionAbove: false
    //     tooltipVisible: !ioSelector.visible && volumeDisplay.containsMouse
    //     targetItem: pillIndicator
    //     delay: 1500
    // }

    // MouseArea {
    //     anchors.fill: parent
    //     hoverEnabled: true
    //     cursorShape: Qt.PointingHandCursor
    //     onClicked: {
    //         if (ioSelector.visible) {
    //             ioSelector.dismiss();
    //         } else {
    //             ioSelector.show();
    //         }
    //     }
    // }
  }

  Connections {
    target: shell ?? null
    function onVolumeChanged() {
      if (shell) {
        const clampedVolume = Math.max(0, Math.min(200, shell.volume))
        if (clampedVolume !== volume) {
          volume = clampedVolume
          pillIndicator.text = volume + "%"
          pillIndicator.icon = shell.defaultAudioSink && shell.defaultAudioSink.audio
              && shell.defaultAudioSink.audio.muted ? "volume_off" : (volume === 0 ? "volume_off" : (volume
                                                                                                     < 30 ? "volume_down" : "volume_up"))

          if (firstChange) {
            firstChange = false
          } else {
            pillIndicator.show()
          }
        }
      }
    }
  }

  Component.onCompleted: {
    if (shell && shell.volume !== undefined) {
      volume = Math.max(0, Math.min(200, shell.volume))
    }
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    acceptedButtons: Qt.NoButton
    propagateComposedEvents: true
    onEntered: {
      volumeDisplay.containsMouse = true
      pillIndicator.autoHide = false
      pillIndicator.showDelayed()
    }
    onExited: {
      volumeDisplay.containsMouse = false
      pillIndicator.autoHide = true
      pillIndicator.hide()
    }
    cursorShape: Qt.PointingHandCursor
    onWheel: wheel => {
               if (!shell)
               return
               let step = 5
               if (wheel.angleDelta.y > 0) {
                 shell.updateVolume(Math.min(200, shell.volume + step))
               } else if (wheel.angleDelta.y < 0) {
                 shell.updateVolume(Math.max(0, shell.volume - step))
               }
             }
  }

  // AudioDeviceSelector {
  //     id: ioSelector
  //     onPanelClosed: ioSelector.dismiss()
  // }
  property bool containsMouse: false
}

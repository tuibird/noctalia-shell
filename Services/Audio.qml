pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

Singleton {
  id: root

  readonly property PwNode sink: Pipewire.defaultAudioSink
  readonly property PwNode source: Pipewire.defaultAudioSource

  // Volume [0..1] is readonly from outside
  readonly property alias volume: root._volume
  property real _volume: sink?.audio?.volume ?? 0

  readonly property alias muted: root._muted
  property bool _muted: !!sink?.audio?.muted

  readonly property real step: 0.05

  function volumeIncrement() {
    volumeSet(volume + step)
  }

  function volumeDecrement() {
    volumeSet(volume - step)
  }

  function volumeSet(newVolume) {
    // Clamp volume to 200%
    if (sink?.ready && sink?.audio) {
      sink.audio.muted = false
      sink.audio.volume = Math.max(0, Math.min(2, newVolume))
    }
  }

  PwObjectTracker {
    objects: [Pipewire.defaultAudioSink]
  }

  Connections {
    target: sink?.audio ? sink?.audio : null

    function onVolumeChanged() {
      root._volume = (sink?.audio.volume ?? 0)
      console.log("[Audio] onVolumeChanged: " + volume)
    }

    function onMutedChanged() {
      root._muted = (sink?.audio.muted ?? true)
      console.log("[Audio] onMuteChanged " + muted)
    }
  }
}

pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

Singleton {
  id: root

  // Ensure the volume is readonly from outside
  readonly property alias volume: root._volume
  property real _volume: 0

  readonly property alias muted: root._muted
  property bool _muted: false

  PwObjectTracker {
    objects: [Pipewire.defaultAudioSink]
  }

  Connections {
    target: Pipewire.defaultAudioSink?.audio ? Pipewire.defaultAudioSink?.audio : null

    function onVolumeChanged() {
      root._volume = (Pipewire.defaultAudioSink?.audio.volume ?? 0)
      console.log("[Audio] onVolumeChanged: " + volume)
    }

    function onMutedChanged() {
      root._muted = (Pipewire.defaultAudioSink?.audio.muted ?? true)
      console.log("[Audio] onMuteChanged " + muted)
    }
  }
}

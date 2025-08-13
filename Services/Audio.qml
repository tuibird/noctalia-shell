pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

Singleton {
  id: root

  readonly property var nodes: Pipewire.nodes.values.reduce((acc, node) => {
                                                              if (!node.isStream) {
                                                                if (node.isSink) {
                                                                  acc.sinks.push(node)
                                                                } else if (node.audio) {
                                                                  acc.sources.push(node)
                                                                }
                                                              }
                                                              return acc
                                                            }, {
                                                              "sources": [],
                                                              "sinks": []
                                                            })

  readonly property PwNode sink: Pipewire.defaultAudioSink
  readonly property PwNode source: Pipewire.defaultAudioSource
  readonly property list<PwNode> sinks: nodes.sinks
  readonly property list<PwNode> sources: nodes.sources

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
    if (sink?.ready && sink?.audio) {
      // Clamp it accordingly
      sink.audio.muted = false
      sink.audio.volume = Math.max(0, Math.min(1, newVolume))
      //console.log("[Audio] volumeSet", sink.audio.volume);
    } else {
      console.warn("[Audio] No sink available")
    }
  }

  function setAudioSink(newSink: PwNode): void {
    Pipewire.preferredDefaultAudioSink = newSink
  }

  function setAudioSource(newSource: PwNode): void {
    Pipewire.preferredDefaultAudioSource = newSource
  }

  PwObjectTracker {
    objects: [...root.sinks, ...root.sources]
  }

  Connections {
    target: sink?.audio ? sink?.audio : null

    function onVolumeChanged() {
      var vol = (sink?.audio.volume ?? 0)
      if (isNaN(vol)) {
        vol = 0
      }
      root._volume = vol
    }

    function onMutedChanged() {
      root._muted = (sink?.audio.muted ?? true)
      console.log("[Audio] onMuteChanged:", root._muted)
    }
  }
}

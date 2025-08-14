pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property var values: Array(barsCount).fill(0)
  property int barsCount: 20

  property var config: ({
                          "general": {
                            "bars": barsCount,
                            "mode": "normal",
                            "framerate": 60,
                            "autosens": 0,
                            "overshoot": 0,
                            "sensitivity": 200,
                            "lower_cutoff_freq": 50,
                            "higher_cutoff_freq": 12000
                          },
                          "smoothing": {
                            "monstercat": 1,
                            "gravity": 100,
                            "noise_reduction": 77
                          },
                          "output": {
                            "method": "raw",
                            "bit_format": 8,
                            "channels": "mono",
                            "mono_option": "average"
                          }
                        })

  Process {
    id: process
    property int fillIndex: 0
    stdinEnabled: true
    running: MediaPlayer.isPlaying
    command: ["cava", "-p", "/dev/stdin"]
    onExited: {
      stdinEnabled = true
      fillIndex = 0
      values = Array(barsCount).fill(0)
    }
    onStarted: {

      for (const k in config) {
        if (typeof config[k] !== "object") {
          write(k + "=" + config[k] + "\n")
          continue
        }
        write("[" + k + "]\n")
        const obj = config[k]
        for (const k2 in obj) {
          write(k2 + "=" + obj[k2] + "\n")
        }
      }
      stdinEnabled = false
      fillIndex = 0
      values = Array(barsCount).fill(0)
    }
    stdout: SplitParser {
      splitMarker: ""
      onRead: data => {
        if (process.fillIndex + data.length >= barsCount) {
          process.fillIndex = 0
        }

        // copy array
        var newValues = values.slice(0)

        for (var i = 0; i < data.length; i++) {
          var amp = Math.min(data.charCodeAt(i), 128) / 128
          newValues[process.fillIndex] = amp * amp
          process.fillIndex = (process.fillIndex + 1) % barsCount
        }
        values = newValues
      }
    }
  }
}

pragma Singleton

pragma ComponentBehavior

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property list<var> ddcMonitors: []
  readonly property list<Monitor> monitors: variants.instances
  property bool appleDisplayPresent: false

  // Public properties for backward compatibility
  readonly property real brightness: focusedMonitor ? focusedMonitor.brightness * 100 : Settings.data.brightness.lastBrightness
  readonly property bool available: focusedMonitor !== null
  readonly property string currentMethod: focusedMonitor ? focusedMonitor.method : Settings.data.brightness.lastMethod
  readonly property var detectedDisplays: monitors.map(m => ({
                                                               "name": m.modelData.name,
                                                               "type": m.isDdc ? "external" : "internal",
                                                               "method": m.method,
                                                               "index": m.busNum
                                                             }))

  // Get the currently focused monitor
  readonly property Monitor focusedMonitor: {
    if (monitors.length === 0)
    return null
    // For now, return the first monitor. Could be enhanced to detect focused monitor
    return monitors[0]
  }

  function getMonitorForScreen(screen: ShellScreen): var {
    return monitors.find(m => m.modelData === screen)
  }

  function increaseBrightness(step = null): void {
    if (focusedMonitor) {
      var stepSize = step !== null ? step : Settings.data.brightness.brightnessStep
      focusedMonitor.setBrightness(focusedMonitor.brightness + (stepSize / 100))
    }
  }

  function decreaseBrightness(step = null): void {
    if (focusedMonitor) {
      var stepSize = step !== null ? step : Settings.data.brightness.brightnessStep
      focusedMonitor.setBrightness(focusedMonitor.brightness - (stepSize / 100))
    }
  }

  function setBrightness(newBrightness: real): void {
    if (focusedMonitor) {
      focusedMonitor.setBrightness(newBrightness / 100)
    }
  }

  function setBrightnessDebounced(newBrightness: real): void {
    if (focusedMonitor) {
      focusedMonitor.setBrightnessDebounced(newBrightness / 100)
    }
  }

  // Backward compatibility functions
  function updateBrightness(): void {// No longer needed with the new architecture
  }

  function setDisplay(displayIndex: int): bool {
    // No longer needed with the new architecture
    return true
  }

  function getDisplayInfo(): var {
    return focusedMonitor ? {
                              "name": focusedMonitor.modelData.name,
                              "type": focusedMonitor.isDdc ? "external" : "internal",
                              "method": focusedMonitor.method,
                              "index": focusedMonitor.busNum
                            } : null
  }

  function getAvailableMethods(): list<string> {
    var methods = []
    if (monitors.some(m => m.isDdc))
      methods.push("ddcutil")
    if (monitors.some(m => !m.isDdc))
      methods.push("internal")
    if (appleDisplayPresent)
      methods.push("apple")
    return methods
  }

  function getDetectedDisplays(): list<var> {
    return detectedDisplays
  }

  reloadableId: "brightness"

  onMonitorsChanged: {
    ddcMonitors = []
    ddcProc.running = true
  }

  Variants {
    id: variants
    model: Quickshell.screens
    Monitor {}
  }

  // Check for Apple Display support
  Process {
    running: true
    command: ["sh", "-c", "which asdbctl >/dev/null 2>&1 && asdbctl get || echo ''"]
    stdout: StdioCollector {
      onStreamFinished: root.appleDisplayPresent = text.trim().length > 0
    }
  }

  // Detect DDC monitors
  Process {
    id: ddcProc
    command: ["ddcutil", "detect", "--brief"]
    stdout: StdioCollector {
      onStreamFinished: {
        var displays = text.trim().split("\n\n").filter(d => d.startsWith("Display "))
        root.ddcMonitors = displays.map(d => {
                                          var modelMatch = d.match(/Monitor:.*:(.*):.*/)
                                          var busMatch = d.match(/I2C bus:[ ]*\/dev\/i2c-([0-9]+)/)
                                          return {
                                            "model": modelMatch ? modelMatch[1] : "",
                                            "busNum": busMatch ? busMatch[1] : ""
                                          }
                                        })
      }
    }
  }

  component Monitor: QtObject {
    id: monitor

    required property ShellScreen modelData
    readonly property bool isDdc: root.ddcMonitors.some(m => m.model === modelData.model)
    readonly property string busNum: root.ddcMonitors.find(m => m.model === modelData.model)?.busNum ?? ""
    readonly property bool isAppleDisplay: root.appleDisplayPresent && modelData.model.startsWith("StudioDisplay")
    readonly property string method: isAppleDisplay ? "apple" : (isDdc ? "ddcutil" : "internal")

    property real brightness: getStoredBrightness()
    property real queuedBrightness: NaN

    // Signal for brightness changes
    signal brightnessUpdated(real newBrightness)

    // Initialize brightness
    readonly property Process initProc: Process {
      stdout: StdioCollector {
        onStreamFinished: {
          console.log("[BrightnessService] Raw brightness data for", monitor.modelData.name + ":", text.trim())

          if (monitor.isAppleDisplay) {
            var val = parseInt(text.trim())
            if (!isNaN(val)) {
              monitor.brightness = val / 101
              console.log("[BrightnessService] Apple display brightness:", monitor.brightness)
            }
          } else if (monitor.isDdc) {
            var parts = text.trim().split(" ")
            if (parts.length >= 2) {
              var current = parseInt(parts[0])
              var max = parseInt(parts[1])
              if (!isNaN(current) && !isNaN(max) && max > 0) {
                monitor.brightness = current / max
                console.log("[BrightnessService] DDC brightness:", current + "/" + max + " =", monitor.brightness)
              }
            }
          } else {
            // Internal backlight
            var parts = text.trim().split(" ")
            if (parts.length >= 2) {
              var current = parseInt(parts[0])
              var max = parseInt(parts[1])
              if (!isNaN(current) && !isNaN(max) && max > 0) {
                monitor.brightness = current / max
                console.log("[BrightnessService] Internal brightness:", current + "/" + max + " =", monitor.brightness)
              }
            }
          }

          if (monitor.brightness > 0) {
            // Save the detected brightness to settings
            monitor.saveBrightness(monitor.brightness)
            monitor.brightnessUpdated(monitor.brightness)
          }
        }
      }
    }

    // Timer for debouncing rapid changes
    readonly property Timer timer: Timer {
      interval: 200
      onTriggered: {
        if (!isNaN(monitor.queuedBrightness)) {
          monitor.setBrightness(monitor.queuedBrightness)
          monitor.queuedBrightness = NaN
        }
      }
    }

    function getStoredBrightness(): real {
      // Try to get stored brightness for this specific monitor
      var stored = Settings.data.brightness.monitorBrightness.find(m => m.name === modelData.name)
      if (stored) {
        return stored.brightness / 100
      }
      // Fallback to general last brightness
      return Settings.data.brightness.lastBrightness / 100
    }

    function saveBrightness(value: real): void {
      var brightnessPercent = Math.round(value * 100)

      // Update general last brightness
      Settings.data.brightness.lastBrightness = brightnessPercent
      Settings.data.brightness.lastMethod = method

      // Update monitor-specific brightness
      var monitorIndex = Settings.data.brightness.monitorBrightness.findIndex(m => m.name === modelData.name)
      var monitorData = {
        "name": modelData.name,
        "brightness": brightnessPercent,
        "method": method
      }

      if (monitorIndex >= 0) {
        Settings.data.brightness.monitorBrightness[monitorIndex] = monitorData
      } else {
        Settings.data.brightness.monitorBrightness.push(monitorData)
      }
    }

    function setBrightness(value: real): void {
      value = Math.max(0, Math.min(1, value))
      var rounded = Math.round(value * 100)

      if (Math.round(brightness * 100) === rounded)
        return

      if (isDdc && timer.running) {
        queuedBrightness = value
        return
      }

      brightness = value
      brightnessUpdated(brightness)

      // Save to settings
      saveBrightness(value)

      if (isAppleDisplay) {
        Quickshell.execDetached(["asdbctl", "set", rounded])
      } else if (isDdc) {
        Quickshell.execDetached(["ddcutil", "-b", busNum, "setvcp", "10", rounded])
      } else {
        Quickshell.execDetached(["brightnessctl", "s", rounded + "%"])
      }

      if (isDdc) {
        timer.restart()
      }
    }

    function setBrightnessDebounced(value: real): void {
      queuedBrightness = value
      timer.restart()
    }

    function initBrightness(): void {
      if (isAppleDisplay) {
        initProc.command = ["asdbctl", "get"]
      } else if (isDdc) {
        initProc.command = ["ddcutil", "-b", busNum, "getvcp", "10", "--brief"]
      } else {
        // Internal backlight - try to find the first available backlight device
        initProc.command = ["sh", "-c", "for dev in /sys/class/backlight/*; do if [ -f \"$dev/brightness\" ] && [ -f \"$dev/max_brightness\" ]; then echo \"$(cat $dev/brightness) $(cat $dev/max_brightness)\"; break; fi; done"]
      }
      initProc.running = true
    }

    onBusNumChanged: initBrightness()
    Component.onCompleted: initBrightness()
  }
}

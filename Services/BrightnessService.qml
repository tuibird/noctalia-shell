pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  // Public properties
  property real brightness: 0
  property real maxBrightness: 100
  property bool available: false
  property string currentMethod: ""
  property var detectedDisplays: []

  // Private properties
  property var _brightnessMethods: []
  property var _currentDisplay: null
  property bool _initialized: false
  property real _targetBrightness: 0
  property bool _isSettingBrightness: false

  // Signal when brightness changes
  signal brightnessUpdated(real newBrightness)
  signal methodChanged(string newMethod)

  // Initialize the service
  Component.onCompleted: {
    initializeBrightness()
  }

  function initializeBrightness() {
    if (_initialized) return
    
    console.log("[Brightness] Initializing brightness service...")
    
    // Start method detection
    detectMethods()
    
    _initialized = true
  }

  function detectMethods() {
    _brightnessMethods = []
    
    // Check for brightnessctl
    brightnessctlProcess.running = true
    
    // Check for ddcutil
    ddcutilProcess.running = true
    
    // Internal backlight is always available if we can access /sys/class/backlight
    backlightCheck.running = true
    
    console.log("[Brightness] Starting method detection...")
  }

  function checkMethodsComplete() {
    // Check if all method detection processes have finished
    if (!brightnessctlProcess.running && !ddcutilProcess.running && !backlightCheck.running) {
      console.log("[Brightness] Available methods:", _brightnessMethods)
      
      // Now detect displays
      detectDisplays()
    }
  }

  // Process objects for method detection
  Process {
    id: brightnessctlProcess
    command: ["which", "brightnessctl"]
    running: false
    onExited: function(exitCode, exitStatus) {
      if (exitCode === 0) {
        _brightnessMethods.push("brightnessctl")
        console.log("[Brightness] brightnessctl available")
      }
      checkMethodsComplete()
    }
  }

  Process {
    id: ddcutilProcess
    command: ["which", "ddcutil"]
    running: false
    onExited: function(exitCode, exitStatus) {
      if (exitCode === 0) {
        _brightnessMethods.push("ddcutil")
        console.log("[Brightness] ddcutil available")
      }
      checkMethodsComplete()
    }
  }

  Process {
    id: backlightCheck
    command: ["test", "-d", "/sys/class/backlight"]
    running: false
    onExited: function(exitCode, exitStatus) {
      if (exitCode === 0) {
        _brightnessMethods.push("internal")
        console.log("[Brightness] Internal backlight available")
      }
      checkMethodsComplete()
    }
  }

  function detectDisplays() {
    detectedDisplays = []
    
    // Get internal displays
    backlightProcess.running = true
    
    // Get external displays via ddcutil
    if (_brightnessMethods.indexOf("ddcutil") !== -1) {
      ddcutilDetectProcess.running = true
    } else {
      // If no ddcutil, just check internal displays
      checkDisplaysComplete()
    }
    
    console.log("[Brightness] Starting display detection...")
  }

  function checkDisplaysComplete() {
    // Check if all display detection processes have finished
    var internalFinished = !backlightProcess.running
    var externalFinished = _brightnessMethods.indexOf("ddcutil") === -1 || !ddcutilDetectProcess.running
    
    if (internalFinished && externalFinished) {
      console.log("[Brightness] Detected displays:", detectedDisplays)
      
      // Set current display to first available
      if (detectedDisplays.length > 0) {
        _currentDisplay = detectedDisplays[0]
        currentMethod = _currentDisplay.method
        available = true
        console.log("[Brightness] Using display:", _currentDisplay.name, "method:", currentMethod)
        
        // Start initial brightness update
        updateBrightness()
      } else {
        console.warn("[Brightness] No displays detected")
      }
    }
  }

  // Process objects for display detection
  Process {
    id: backlightProcess
    command: ["ls", "/sys/class/backlight"]
    running: false
    stdout: SplitParser {
      onRead: function(line) {
        var trimmedLine = line.replace(/^\s+|\s+$/g, "")
        if (trimmedLine) {
          detectedDisplays.push({
            name: trimmedLine,
            type: "internal",
            method: "internal"
          })
        }
      }
    }
    onExited: function(exitCode, exitStatus) {
      checkDisplaysComplete()
    }
  }

  Process {
    id: ddcutilDetectProcess
    command: ["ddcutil", "detect"]
    running: false
    stdout: SplitParser {
      onRead: function(line) {
        console.log("[Brightness] ddcutil detect line:", line)
        if (line.indexOf("Display") !== -1) {
          // Simple parsing for Display number
          var parts = line.split("Display")
          if (parts.length > 1) {
            var numberPart = parts[1].replace(/^\s+|\s+$/g, "")
            var number = numberPart.split(" ")[0]
            if (number && !isNaN(number)) {
              detectedDisplays.push({
                name: "Display " + number,
                type: "external",
                method: "ddcutil",
                index: number
              })
              console.log("[Brightness] Added external display:", "Display " + number)
            }
          }
        }
        // Also look for connector information
        if (line.indexOf("DRM connector:") !== -1) {
          console.log("[Brightness] Found DRM connector:", line)
        }
      }
    }
    onExited: function(exitCode, exitStatus) {
      checkDisplaysComplete()
    }
  }

  function updateBrightness() {
    if (!_currentDisplay) return
    
    // Prevent multiple simultaneous brightness checks
    if (brightnessGetProcess.running) {
      console.log("[Brightness] Brightness check already in progress, skipping...")
      return
    }
    
    // Don't update if we're currently setting brightness
    if (_isSettingBrightness) {
      console.log("[Brightness] Skipping update while setting brightness...")
      return
    }
    
    console.log("[Brightness] Updating brightness for display:", _currentDisplay.name)
    
    // Try the brightness script first
    if (_currentDisplay.method === "ddcutil" && _currentDisplay.index) {
      // For ddcutil, try using the display index directly
      brightnessGetProcess.command = ["ddcutil", "--display", _currentDisplay.index, "getvcp", "10"]
    } else {
      // Use the brightness script
      brightnessGetProcess.command = ["sh", "-c", Quickshell.shellDir + "/Bin/brigthness.sh", "get", _currentDisplay.name]
    }
    brightnessGetProcess.running = true
  }

  function updateBrightnessDebounced() {
    // Use debouncing to prevent excessive updates
    debounceTimer.restart()
  }

  function setBrightness(newBrightness) {
    if (!_currentDisplay || !available) {
      console.warn("[Brightness] No display available for brightness control")
      return false
    }
    
    // Clamp brightness to valid range
    newBrightness = Math.max(0, Math.min(100, newBrightness))
    
    // Prevent setting if already setting
    if (brightnessSetProcess.running) {
      console.log("[Brightness] Brightness set already in progress, skipping...")
      return false
    }
    
    console.log("[Brightness] Setting brightness to:", newBrightness, "for display:", _currentDisplay.name)
    
    // Mark that we're setting brightness
    _isSettingBrightness = true
    
    // Try ddcutil directly for external displays
    if (_currentDisplay.method === "ddcutil" && _currentDisplay.index) {
      brightnessSetProcess.command = ["ddcutil", "--display", _currentDisplay.index, "setvcp", "10", newBrightness.toString()]
    } else {
      // Use the brightness script for internal displays
      brightnessSetProcess.command = ["sh", "-c", Quickshell.shellDir + "/Bin/brigthness.sh", "set", _currentDisplay.name, newBrightness.toString()]
    }
    brightnessSetProcess.running = true
    
    return true
  }

  function setBrightnessDebounced(newBrightness) {
    // Store the target brightness for debounced setting
    _targetBrightness = newBrightness
    
    // Update UI immediately for responsiveness
    if (brightness !== newBrightness) {
      brightness = newBrightness
      brightnessUpdated(brightness)
    }
    
    setDebounceTimer.restart()
  }

  // Process objects for brightness control
  Process {
    id: brightnessGetProcess
    running: false
    stdout: SplitParser {
      onRead: function(line) {
        var newBrightness = -1
        
        // Handle ddcutil output format: "current value = X,"
        if (line.indexOf("current value =") !== -1) {
          var match = line.match(/current value\s*=\s*(\d+)/)
          if (match) {
            newBrightness = parseFloat(match[1])
          }
        } else {
          // Handle direct numeric output
          newBrightness = parseFloat(line.replace(/^\s+|\s+$/g, ""))
        }
        
        if (!isNaN(newBrightness) && newBrightness >= 0) {
          if (brightness !== newBrightness) {
            brightness = newBrightness
            brightnessUpdated(brightness)
            console.log("[Brightness] Brightness updated to:", brightness)
          }
        } else {
          console.warn("[Brightness] Invalid brightness value:", line)
        }
      }
    }
    onExited: function(exitCode, exitStatus) {
      // Only log errors
      if (exitCode !== 0) {
        console.warn("[Brightness] Brightness get process failed with code:", exitCode)
      }
    }
  }

  Process {
    id: brightnessSetProcess
    running: false
    stdout: SplitParser {
      onRead: function(line) {
        var result = parseFloat(line.replace(/^\s+|\s+$/g, ""))
        if (!isNaN(result) && result >= 0) {
          brightness = result
          brightnessUpdated(brightness)
          console.log("[Brightness] Brightness set to:", brightness)
        } else {
          console.warn("[Brightness] Failed to set brightness - invalid output:", line)
        }
      }
    }
    onExited: function(exitCode, exitStatus) {
      if (exitCode === 0) {
        // If ddcutil succeeded but didn't output a number, refresh the brightness
        if (_currentDisplay.method === "ddcutil") {
          // Longer delay to let the display update and avoid conflicts
          refreshTimer.interval = 1000
          refreshTimer.start()
        }
      } else {
        console.warn("[Brightness] Set brightness process failed with exit code:", exitCode)
      }
      
      // Clear the setting flag after a delay
      settingCompleteTimer.start()
    }
  }

  // Timer to clear the setting flag
  Timer {
    id: settingCompleteTimer
    interval: 800
    repeat: false
    onTriggered: {
      _isSettingBrightness = false
    }
  }

  // Timer to refresh brightness after setting
  Timer {
    id: refreshTimer
    interval: 500
    repeat: false
    onTriggered: updateBrightnessDebounced()
  }



  function increaseBrightness(step = 5) {
    return setBrightnessDebounced(brightness + step)
  }

  function decreaseBrightness(step = 5) {
    return setBrightnessDebounced(brightness - step)
  }

  function setDisplay(displayIndex) {
    if (displayIndex >= 0 && displayIndex < detectedDisplays.length) {
      _currentDisplay = detectedDisplays[displayIndex]
      currentMethod = _currentDisplay.method
      methodChanged(currentMethod)
      updateBrightness()
      return true
    }
    return false
  }

  function getDisplayInfo() {
    return _currentDisplay || null
  }

  function getAvailableMethods() {
    return _brightnessMethods
  }

  function getDetectedDisplays() {
    return detectedDisplays
  }

  // Refresh brightness periodically - but less frequently
  Timer {
    interval: 5000 // Update every 5 seconds instead of 2
    running: available && _initialized
    repeat: true
    onTriggered: updateBrightness()
  }

  // Debounce timer for UI updates
  Timer {
    id: debounceTimer
    interval: 300
    repeat: false
    onTriggered: updateBrightness()
  }

  // Debounce timer for setting brightness
  Timer {
    id: setDebounceTimer
    interval: 100
    repeat: false
    onTriggered: setBrightness(_targetBrightness)
  }
} 
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Services.Pipewire

import qs.Modules.Settings
import qs.Widgets
import qs.Services

ColumnLayout {
  id: root

  spacing: 0

  ScrollView {
    id: scrollView

    Layout.fillWidth: true
    Layout.fillHeight: true
    padding: Style.marginMedium * scaling
    clip: true
    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
    ScrollBar.vertical.policy: ScrollBar.AsNeeded

    ColumnLayout {
      width: scrollView.availableWidth
      spacing: 0

      Item {
        Layout.fillWidth: true
        Layout.preferredHeight: 0
      }

      ColumnLayout {
        spacing: Style.marginTiny * scaling
        Layout.fillWidth: true

        NText {
          text: "Audio"
          font.pointSize: Style.fontSizeXL * scaling
          font.weight: Style.fontWeightBold
          color: Colors.textPrimary
          Layout.bottomMargin: Style.marginSmall * scaling
        }

        // Volume Controls
        ColumnLayout {
          spacing: Style.marginSmall * scaling
          Layout.fillWidth: true
          Layout.topMargin: Style.marginSmall * scaling

          // Master Volume
          ColumnLayout {
            spacing: Style.marginSmall * scaling
            Layout.fillWidth: true

            NText {
              text: "Master Volume"
              font.weight: Style.fontWeightBold
              color: Colors.textPrimary
            }

            NText {
              text: "System-wide volume level"
              font.pointSize: Style.fontSizeSmall * scaling
              color: Colors.textSecondary
              wrapMode: Text.WordWrap
              Layout.fillWidth: true
            }

            RowLayout {
              NSlider {
                id: masterVolumeSlider
                Layout.fillWidth: true
                from: 0
                to: allowOverdrive.value ? 200 : 100
                value: (Audio.volume || 0) * 100
                stepSize: 5
                onValueChanged: {
                  Audio.volumeSet(value / 100)
                }
              }

              NText {
                text: Math.round(masterVolumeSlider.value) + "%"
                Layout.alignment: Qt.AlignVCenter
                color: Colors.textSecondary
              }
            }

                         NToggle {
               id: allowOverdrive
               label: "Allow Volume Overdrive"
               description: "Enable volume levels above 100% (up to 200%)"
               value: Settings.data.audio ? Settings.data.audio.volumeOverdrive : false
               onToggled: function (checked) {
                 Settings.data.audio.volumeOverdrive = checked
                
                // If overdrive is disabled and current volume is above 100%, cap it
                if (!checked && Audio.volume > 1.0) {
                  Audio.volumeSet(1.0)
                }
              }
            }
          }

          // Mute Toggle
          ColumnLayout {
            spacing: Style.marginSmall * scaling
            Layout.fillWidth: true
            Layout.topMargin: Style.marginMedium * scaling

            NToggle {
              label: "Mute Audio"
              description: "Mute or unmute the default audio output"
              value: Audio.muted
              onToggled: function (newValue) {
                if (Audio.sink && Audio.sink.audio) {
                  Audio.sink.audio.muted = newValue
                }
              }
            }
          }
        }

        NDivider {
          Layout.fillWidth: true
          Layout.topMargin: Style.marginLarge * 2 * scaling
          Layout.bottomMargin: Style.marginLarge * scaling
        }

        // Audio Devices
        ColumnLayout {
          spacing: Style.marginLarge * scaling
          Layout.fillWidth: true

          NText {
            text: "Audio Devices"
            font.pointSize: Style.fontSizeXL * scaling
            font.weight: Style.fontWeightBold
            color: Colors.textPrimary
            Layout.bottomMargin: Style.marginSmall * scaling
                      }

            // Output Device
            NComboBox {
              id: outputDeviceCombo
              label: "Output Device"
              description: "Default audio output device"
              optionsKeys: outputDeviceKeys
              optionsLabels: outputDeviceLabels
              currentKey: Audio.sink ? Audio.sink.id.toString() : ""
              onSelected: function (key) {
                // Find the node by ID and set it as preferred
                for (let i = 0; i < Pipewire.nodes.count; i++) {
                  let node = Pipewire.nodes.get(i)
                  if (node.id.toString() === key && node.isSink) {
                    Pipewire.preferredDefaultAudioSink = node
                    break
                  }
                }
              }
            }

            // Input Device
            NComboBox {
              id: inputDeviceCombo
              label: "Input Device"
              description: "Default audio input device"
              optionsKeys: inputDeviceKeys
              optionsLabels: inputDeviceLabels
              currentKey: Audio.source ? Audio.source.id.toString() : ""
              onSelected: function (key) {
                // Find the node by ID and set it as preferred
                for (let i = 0; i < Pipewire.nodes.count; i++) {
                  let node = Pipewire.nodes.get(i)
                  if (node.id.toString() === key && !node.isSink) {
                    Pipewire.preferredDefaultAudioSource = node
                    break
                  }
                }
              }
            }


                  }

          // Divider
          NDivider {
            Layout.fillWidth: true
            Layout.topMargin: Style.marginLarge * scaling
            Layout.bottomMargin: Style.marginMedium * scaling
          }

        // Audio Visualizer Category
        ColumnLayout {
          spacing: Style.marginSmall * scaling
          Layout.fillWidth: true

          NText {
            text: "Audio Visualizer"
            font.pointSize: Style.fontSizeXL * scaling
            font.weight: Style.fontWeightBold
            color: Colors.textPrimary
            Layout.bottomMargin: Style.marginSmall * scaling
          }

          // Audio Visualizer section
          NComboBox {
            id: audioVisualizerCombo
            label: "Visualization Type"
            description: "Choose a visualization type for media playback"
            optionsKeys: ["radial", "bars", "wave"]
            optionsLabels: ["Radial", "Bars", "Wave"]
            currentKey: Settings.data.audio ? Settings.data.audio.audioVisualizer.type : "radial"
            onSelected: function (key) {
              if (!Settings.data.audio) {
                Settings.data.audio = {}
              }
              if (!Settings.data.audio.audioVisualizer) {
                Settings.data.audio.audioVisualizer = {}
              }
              Settings.data.audio.audioVisualizer.type = key
            }
          }
        }
      }
    }
  }

  // Device list properties
  property var outputDeviceKeys: ["default"]
  property var outputDeviceLabels: ["Default Output"]
  property var inputDeviceKeys: ["default"]
  property var inputDeviceLabels: ["Default Input"]

  // Bind Pipewire nodes
  PwObjectTracker {
    id: nodeTracker
    objects: [Pipewire.nodes]
  }

  // Update device lists when component is completed
  Component.onCompleted: {
    updateDeviceLists()
  }

  // Timer to check if pipewire is ready and update device lists
  Timer {
    id: deviceUpdateTimer
    interval: 100
    repeat: true
    running: !(Pipewire && Pipewire.ready)
    onTriggered: {
      if (Pipewire && Pipewire.ready) {
        updateDeviceLists()
        running = false
      }
    }
  }

  // Update device lists when nodes change
  Connections {
    target: nodeTracker
    function onObjectsChanged() {
      updateDeviceLists()
    }
  }

  Repeater {
    id: nodesRepeater
    model: Pipewire.nodes
    delegate: Item {
      Component.onCompleted: {
        if (modelData && modelData.isSink && modelData.audio) {
          // Add to output devices
          let key = modelData.id.toString()
          if (!outputDeviceKeys.includes(key)) {
            outputDeviceKeys.push(key)
            outputDeviceLabels.push(modelData.description || modelData.name || "Unknown Device")
          }
        } else if (modelData && !modelData.isSink && modelData.audio) {
          // Add to input devices
          let key = modelData.id.toString()
          if (!inputDeviceKeys.includes(key)) {
            inputDeviceKeys.push(key)
            inputDeviceLabels.push(modelData.description || modelData.name || "Unknown Device")
          }
        }
      }
    }
  }

  function updateDeviceLists() {
    if (Pipewire && Pipewire.ready) {
      // Update comboboxes
      if (outputDeviceCombo) {
        outputDeviceCombo.optionsKeys = outputDeviceKeys
        outputDeviceCombo.optionsLabels = outputDeviceLabels
      }
      
      if (inputDeviceCombo) {
        inputDeviceCombo.optionsKeys = inputDeviceKeys
        inputDeviceCombo.optionsLabels = inputDeviceLabels
      }
    }
  }
}
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Services.Pipewire

import qs.Modules.Settings
import qs.Widgets
import qs.Services

ColumnLayout {
  id: root

  property real localVolume: Audio.volume

  // Connection used to open the pill when volume changes
  Connections {
    target: Audio.sink?.audio ? Audio.sink?.audio : null
    function onVolumeChanged() {
      localVolume = Audio.volume
    }
  }

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
          color: Colors.mOnSurface
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

            ColumnLayout {
              spacing: Style.marginTiniest * scaling

              NText {
                text: "Master Volume"
                font.weight: Style.fontWeightBold
                color: Colors.mOnSurface
              }

              NText {
                text: "System-wide volume level"
                font.pointSize: Style.fontSizeSmall * scaling
                color: Colors.mOnSurface
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
              }
            }
            RowLayout {
              // Pipewire seems a bit finicky, if we spam too many volume changes it breaks easily
              // Probably because they have some quick fades in and out to avoid clipping
              // We use a timer to space out the updates, to avoid lock up
              Timer {
                interval: Style.animationFast
                running: true
                repeat: true
                onTriggered: {
                  if (Math.abs(localVolume - Audio.volume) >= 0.01) {
                    Audio.setVolume(localVolume)
                  }
                }
              }

              NSlider {
                Layout.fillWidth: true
                from: 0
                to: Settings.data.audio.volumeOverdrive ? 2.0 : 1.0
                value: localVolume
                stepSize: 0.01
                onMoved: {
                  localVolume = value
                }
              }

              NText {
                text: Math.floor(Audio.volume * 100) + "%"
                Layout.alignment: Qt.AlignVCenter
                color: Colors.mOnSurface
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
            color: Colors.mOnSurface
            Layout.bottomMargin: Style.marginSmall * scaling
          }

          // -------------------------------
          // Output Devices
          ButtonGroup {
            id: sinks
          }

          ColumnLayout {
            spacing: Style.marginTiniest * scaling
            Layout.fillWidth: true
            Layout.bottomMargin: Style.marginLarge * scaling

            NText {
              text: "Output Device"
              font.pointSize: Style.fontSizeMedium * scaling
              font.weight: Style.fontWeightBold
              color: Colors.mOnSurface
            }

            NText {
              text: "Select the desired audio output device"
              font.pointSize: Style.fontSizeSmall * scaling
              color: Colors.mOnSurface
              wrapMode: Text.WordWrap
              Layout.fillWidth: true
            }

            Repeater {
              model: Audio.sinks
              NRadioButton {
                required property PwNode modelData
                ButtonGroup.group: sinks
                checked: Audio.sink?.id === modelData.id
                onClicked: Audio.setAudioSink(modelData)
                text: modelData.description
              }
            }
          }
        }

        // -------------------------------
        // Input Devices
        ButtonGroup {
          id: sources
        }

        ColumnLayout {
          spacing: Style.marginTiniest * scaling
          Layout.fillWidth: true
          Layout.bottomMargin: Style.marginLarge * scaling

          NText {
            text: "Input Device"
            font.pointSize: Style.fontSizeMedium * scaling
            font.weight: Style.fontWeightBold
            color: Colors.mOnSurface
          }

          NText {
            text: "Select desired audio input device"
            font.pointSize: Style.fontSizeSmall * scaling
            color: Colors.mOnSurface
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
          }

          Repeater {
            model: Audio.sources
            NRadioButton {
              required property PwNode modelData
              ButtonGroup.group: sources
              checked: Audio.source?.id === modelData.id
              onClicked: Audio.setAudioSource(modelData)
              text: modelData.description
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
          color: Colors.mOnSurface
          Layout.bottomMargin: Style.marginSmall * scaling
        }

        // Audio Visualizer section
        NComboBox {
          id: audioVisualizerCombo
          label: "Visualization Type"
          description: "Choose a visualization type for media playback"
          model: ListModel {
            ListElement {
              key: "none"
              name: "None"
            }
            ListElement {
              key: "linear"
              name: "Linear"
            }
          }
          currentKey: Settings.data.audio.visualizerType
          onSelected: function (key) {
            Settings.data.audio.visualizerType = key
          }
        }
      }
    }
  }
}

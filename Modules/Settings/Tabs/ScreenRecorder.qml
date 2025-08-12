import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Services
import qs.Widgets

ColumnLayout {
  id: root

  spacing: 0

  ScrollView {
    id: scrollView

    Layout.fillWidth: true
    Layout.fillHeight: true
    padding: 16
    rightPadding: 12
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
        spacing: 4
        Layout.fillWidth: true

        NText {
          text: "Screen Recording"
          font.pointSize: 18
          font.weight: Style.fontWeightBold
          color: Colors.textPrimary
          Layout.bottomMargin: 8
        }

        // Output Directory
        ColumnLayout {
          spacing: 8
          Layout.fillWidth: true
          Layout.topMargin: 8

          NText {
            text: "Output Directory"
            font.pointSize: 13
            font.weight: Style.fontWeightBold
            color: Colors.textPrimary
          }

          NText {
            text: "Directory where screen recordings will be saved"
            font.pointSize: 12
            color: Colors.textSecondary
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
          }

          NTextInput {
            text: Settings.data.screenRecorder.directory
            Layout.fillWidth: true
            onEditingFinished: function () {
              Settings.data.screenRecorder.directory = text
            }
          }
        }

        NDivider {
          Layout.fillWidth: true
          Layout.topMargin: 26
          Layout.bottomMargin: 18
        }

        // Video Settings
        ColumnLayout {
          spacing: 4
          Layout.fillWidth: true

          NText {
            text: "Video Settings"
            font.pointSize: 18
            font.weight: Style.fontWeightBold
            color: Colors.textPrimary
            Layout.bottomMargin: 8
          }

          // Frame Rate
          ColumnLayout {
            spacing: 8
            Layout.fillWidth: true
            Layout.topMargin: 8

            NText {
              text: "Frame Rate"
              font.pointSize: 13
              font.weight: Style.fontWeightBold
              color: Colors.textPrimary
            }

            NText {
              text: "Target frame rate for screen recordings (default: 60)"
              font.pointSize: 12
              color: Colors.textSecondary
              wrapMode: Text.WordWrap
              Layout.fillWidth: true
            }

            RowLayout {
              Layout.fillWidth: true

              NText {
                text: Settings.data.screenRecorder.frameRate + " FPS"
                font.pointSize: 13
                color: Colors.textPrimary
              }

              Item {
                Layout.fillWidth: true
              }
            }

            NSlider {
              Layout.fillWidth: true
              from: 24
              to: 144
              stepSize: 1
              value: Settings.data.screenRecorder.frameRate
              onMoved: Settings.data.screenRecorder.frameRate = Math.round(value)
              cutoutColor: Colors.backgroundPrimary
            }
          }

          // Video Quality
          ColumnLayout {
            spacing: 8
            Layout.fillWidth: true
            Layout.topMargin: 8

            NText {
              text: "Video Quality"
              font.pointSize: 13
              font.weight: Style.fontWeightBold
              color: Colors.textPrimary
            }

            NText {
              text: "Higher quality results in larger file sizes"
              font.pointSize: 12
              color: Colors.textSecondary
              wrapMode: Text.WordWrap
              Layout.fillWidth: true
            }

            NComboBox {
              optionsKeys: ["medium", "high", "very_high", "ultra"]
              optionsLabels: ["Medium", "High", "Very High", "Ultra"]
              currentKey: Settings.data.screenRecorder.quality
              onSelected: function (key) {
                Settings.data.screenRecorder.quality = key
              }
            }
          }

          // Video Codec
          ColumnLayout {
            spacing: 8
            Layout.fillWidth: true
            Layout.topMargin: 8

            NText {
              text: "Video Codec"
              font.pointSize: 13
              font.weight: Style.fontWeightBold
              color: Colors.textPrimary
            }

            NText {
              text: "Different codecs offer different compression and compatibility"
              font.pointSize: 12
              color: Colors.textSecondary
              wrapMode: Text.WordWrap
              Layout.fillWidth: true
            }

            NComboBox {
              optionsKeys: ["h264", "hevc", "av1", "vp8", "vp9"]
              optionsLabels: ["H264", "HEVC", "AV1", "VP8", "VP9"]
              currentKey: Settings.data.screenRecorder.videoCodec
              onSelected: function (key) {
                Settings.data.screenRecorder.videoCodec = key
              }
            }
          }

          // Color Range
          ColumnLayout {
            spacing: 8
            Layout.fillWidth: true
            Layout.topMargin: 8

            NText {
              text: "Color Range"
              font.pointSize: 13
              font.weight: Style.fontWeightBold
              color: Colors.textPrimary
            }

            NText {
              text: "Limited is recommended for better compatibility"
              font.pointSize: 12
              color: Colors.textSecondary
              wrapMode: Text.WordWrap
              Layout.fillWidth: true
            }

            NComboBox {
              optionsKeys: ["limited", "full"]
              optionsLabels: ["Limited", "Full"]
              currentKey: Settings.data.screenRecorder.colorRange
              onSelected: function (key) {
                Settings.data.screenRecorder.colorRange = key
              }
            }
          }
        }

        NDivider {
          Layout.fillWidth: true
          Layout.topMargin: 26
          Layout.bottomMargin: 18
        }

        // Audio Settings
        ColumnLayout {
          spacing: 4
          Layout.fillWidth: true

          NText {
            text: "Audio Settings"
            font.pointSize: 18
            font.weight: Style.fontWeightBold
            color: Colors.textPrimary
            Layout.bottomMargin: 8
          }

          // Audio Source
          ColumnLayout {
            spacing: 8
            Layout.fillWidth: true
            Layout.topMargin: 8

            NText {
              text: "Audio Source"
              font.pointSize: 13
              font.weight: Style.fontWeightBold
              color: Colors.textPrimary
            }

            NText {
              text: "Audio source to capture during recording"
              font.pointSize: 12
              color: Colors.textSecondary
              wrapMode: Text.WordWrap
              Layout.fillWidth: true
            }

            NComboBox {
              optionsKeys: ["default_output", "default_input", "both"]
              optionsLabels: ["System Audio", "Microphone", "System Audio + Microphone"]
              currentKey: Settings.data.screenRecorder.audioSource
              onSelected: function (key) {
                Settings.data.screenRecorder.audioSource = key
              }
            }
          }

          // Audio Codec
          ColumnLayout {
            spacing: 8
            Layout.fillWidth: true
            Layout.topMargin: 8

            NText {
              text: "Audio Codec"
              font.pointSize: 13
              font.weight: Style.fontWeightBold
              color: Colors.textPrimary
            }

            NText {
              text: "Opus is recommended for best performance and smallest audio size"
              font.pointSize: 12
              color: Colors.textSecondary
              wrapMode: Text.WordWrap
              Layout.fillWidth: true
            }

            NComboBox {
              optionsKeys: ["opus", "aac"]
              optionsLabels: ["OPUS", "AAC"]
              currentKey: Settings.data.screenRecorder.audioCodec
              onSelected: function (key) {
                Settings.data.screenRecorder.audioCodec = key
              }
            }
          }

          // Show Cursor
          NToggle {
            label: "Show Cursor"
            description: "Record mouse cursor in the video"
            value: Settings.data.screenRecorder.showCursor
            onToggled: function (newValue) {
              Settings.data.screenRecorder.showCursor = newValue
            }
          }
        }
      }
    }
  }
}
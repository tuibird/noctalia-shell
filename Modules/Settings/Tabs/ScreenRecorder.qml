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
          text: "Recording"
          font.pointSize: Style.fontSizeXL * scaling
          font.weight: Style.fontWeightBold
          color: Colors.mOnSurface
          Layout.bottomMargin: Style.marginSmall * scaling
        }

        // Output Directory
        ColumnLayout {
          spacing: Style.marginSmall * scaling
          Layout.fillWidth: true
          Layout.topMargin: Style.marginSmall * scaling

          NTextInput {
            label: "Output Directory"
            description: "Directory where screen recordings will be saved"
            placeholderText: "/home/xxx/Videos"
            text: Settings.data.screenRecorder.directory
            onEditingFinished: {
              Settings.data.screenRecorder.directory = text
            }
          }

          ColumnLayout {
            spacing: Style.marginSmall * scaling
            Layout.fillWidth: true
            Layout.topMargin: Style.marginMedium * scaling
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

        NDivider {
          Layout.fillWidth: true
          Layout.topMargin: Style.marginLarge * 2 * scaling
          Layout.bottomMargin: Style.marginLarge * scaling
        }

        // Video Settings
        ColumnLayout {
          spacing: Style.marginLarge * scaling
          Layout.fillWidth: true

          NText {
            text: "Video Settings"
            font.pointSize: Style.fontSizeXL * scaling
            font.weight: Style.fontWeightBold
            color: Colors.mOnSurface
            Layout.bottomMargin: Style.marginSmall * scaling
          }

          // Frame Rate
          NComboBox {
            label: "Frame Rate"
            description: "Target frame rate for screen recordings (default: 60)"
            optionsKeys: ["30", "60", "120", "240"]
            optionsLabels: ["30 FPS", "60 FPS", "120 FPS", "240 FPS"]
            currentKey: Settings.data.screenRecorder.frameRate
            onSelected: function (key) {
              Settings.data.screenRecorder.frameRate = key
            }
          }

          // Video Quality
          NComboBox {
            label: "Video Quality"
            description: "Higher quality results in larger file sizes"
            optionsKeys: ["medium", "high", "very_high", "ultra"]
            optionsLabels: ["Medium", "High", "Very High", "Ultra"]
            currentKey: Settings.data.screenRecorder.quality
            onSelected: function (key) {
              Settings.data.screenRecorder.quality = key
            }
          }

          // Video Codec
          NComboBox {
            label: "Video Codec"
            description: "Different codecs offer different compression and compatibility"
            optionsKeys: ["h264", "hevc", "av1", "vp8", "vp9"]
            optionsLabels: ["H264", "HEVC", "AV1", "VP8", "VP9"]
            currentKey: Settings.data.screenRecorder.videoCodec
            onSelected: function (key) {
              Settings.data.screenRecorder.videoCodec = key
            }
          }

          // Color Range
          NComboBox {
            label: "Color Range"
            description: "Limited is recommended for better compatibility"
            optionsKeys: ["limited", "full"]
            optionsLabels: ["Limited", "Full"]
            currentKey: Settings.data.screenRecorder.colorRange
            onSelected: function (key) {
              Settings.data.screenRecorder.colorRange = key
            }
          }
        }

        NDivider {
          Layout.fillWidth: true
          Layout.topMargin: Style.marginLarge * 2 * scaling
          Layout.bottomMargin: Style.marginLarge * scaling
        }

        // Audio Settings
        ColumnLayout {
          spacing: Style.marginLarge * scaling
          Layout.fillWidth: true

          NText {
            text: "Audio Settings"
            font.pointSize: Style.fontSizeXL * scaling
            font.weight: Style.fontWeightBold
            color: Colors.mOnSurface
            Layout.bottomMargin: Style.marginSmall * scaling
          }

          // Audio Source
          NComboBox {
            label: "Audio Source"
            description: "Audio source to capture during recording"
            optionsKeys: ["default_output", "default_input", "both"]
            optionsLabels: ["System Audio", "Microphone", "System Audio + Microphone"]
            currentKey: Settings.data.screenRecorder.audioSource
            onSelected: function (key) {
              Settings.data.screenRecorder.audioSource = key
            }
          }

          // Audio Codec
          NComboBox {
            label: "Audio Codec"
            description: "Opus is recommended for best performance and smallest audio size"
            optionsKeys: ["opus", "aac"]
            optionsLabels: ["OPUS", "AAC"]
            currentKey: Settings.data.screenRecorder.audioCodec
            onSelected: function (key) {
              Settings.data.screenRecorder.audioCodec = key
            }
          }
        }
      }
    }
  }
}

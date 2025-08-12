import QtQuick
import QtQuick.Layouts
import qs.Services
import qs.Widgets

Item {
  property real scaling: 1
  readonly property string tabIcon: "videocam"
  readonly property string tabLabel: "Screen Recorder"
  readonly property int tabIndex: 3
  Layout.fillWidth: true
  Layout.fillHeight: true

  ColumnLayout {
    anchors.fill: parent
    spacing: Style.marginMedium * scaling

    NText {
      text: "Screen Recording"
      font.weight: Style.fontWeightBold
      color: Colors.accentSecondary
    }

    // Output Directory
    NText {
      text: "Output Directory"
      color: Colors.textPrimary
      font.weight: Style.fontWeightBold
    }
    NText {
      text: "Directory where screen recordings will be saved"
      color: Colors.textSecondary
    }
    NTextInput {
      text: Settings.data.screenRecorder.directory
      Layout.fillWidth: true
      onEditingFinished: function () {
        Settings.data.screenRecorder.directory = text
      }
    }

    // Frame Rate
    NText {
      text: "Frame Rate"
      color: Colors.textPrimary
      font.weight: Style.fontWeightBold
    }
    NText {
      text: "Target frame rate for screen recordings (default: 60)"
      color: Colors.textSecondary
    }
    RowLayout {
      Layout.fillWidth: true
      NText {
        text: Settings.data.screenRecorder.frameRate + " FPS"
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
      cutoutColor: Colors.surface
    }

    // Audio Source
    NText {
      text: "Audio Source"
      color: Colors.textPrimary
      font.weight: Style.fontWeightBold
    }
    NText {
      text: "Audio source to capture during recording"
      color: Colors.textSecondary
    }
    NComboBox {
      optionsKeys: ["default_output", "default_input", "both"]
      optionsLabels: ["System Audio", "Microphone", "System Audio + Microphone"]
      currentKey: Settings.data.screenRecorder.audioSource
      onSelected: function (key) {
        Settings.data.screenRecorder.audioSource = key
      }
    }

    // Video Quality
    NText {
      text: "Video Quality"
      color: Colors.textPrimary
      font.weight: Style.fontWeightBold
    }
    NText {
      text: "Higher quality results in larger file sizes"
      color: Colors.textSecondary
    }
    NComboBox {
      optionsKeys: ["medium", "high", "very_high", "ultra"]
      optionsLabels: ["Medium", "High", "Very High", "Ultra"]
      currentKey: Settings.data.screenRecorder.quality
      onSelected: function (key) {
        Settings.data.screenRecorder.quality = key
      }
    }

    // Video Codec
    NText {
      text: "Video Codec"
      color: Colors.textPrimary
      font.weight: Style.fontWeightBold
    }
    NText {
      text: "Different codecs offer different compression and compatibility"
      color: Colors.textSecondary
    }
    NComboBox {
      optionsKeys: ["h264", "hevc", "av1", "vp8", "vp9"]
      optionsLabels: ["H264", "HEVC", "AV1", "VP8", "VP9"]
      currentKey: Settings.data.screenRecorder.videoCodec
      onSelected: function (key) {
        Settings.data.screenRecorder.videoCodec = key
      }
    }

    // Audio Codec
    NText {
      text: "Audio Codec"
      color: Colors.textPrimary
      font.weight: Style.fontWeightBold
    }
    NText {
      text: "Opus is recommended for best performance and smallest audio size"
      color: Colors.textSecondary
    }
    NComboBox {
      optionsKeys: ["opus", "aac"]
      optionsLabels: ["OPUS", "AAC"]
      currentKey: Settings.data.screenRecorder.audioCodec
      onSelected: function (key) {
        Settings.data.screenRecorder.audioCodec = key
      }
    }

    // Color Range
    NText {
      text: "Color Range"
      color: Colors.textPrimary
      font.weight: Style.fontWeightBold
    }
    NText {
      text: "Limited is recommended for better compatibility"
      color: Colors.textSecondary
    }
    NComboBox {
      optionsKeys: ["limited", "full"]
      optionsLabels: ["Limited", "Full"]
      currentKey: Settings.data.screenRecorder.colorRange
      onSelected: function (key) {
        Settings.data.screenRecorder.colorRange = key
      }
    }

    NToggle {
      label: "Show Cursor"
      description: "Record mouse cursor in the video"
      value: Settings.data.screenRecorder.showCursor
      onToggled: function (newValue) {
        Settings.data.screenRecorder.showCursor = newValue
      }
    }

    Item {
      Layout.fillHeight: true
    }
  }
}

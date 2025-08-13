import QtQuick
import QtQuick.Layouts
import qs.Services
import qs.Widgets

// Media player area (placeholder until MediaPlayer service is wired)
NBox {
  id: root

  Layout.fillWidth: true
  Layout.fillHeight: true

  // Let content dictate the height (no hardcoded height here)
  // Height can be overridden by parent layout (SidePanel binds it to stats card)
  //implicitHeight: content.implicitHeight + Style.marginLarge * 2 * scaling
  // Component.onCompleted: {
  //   console.log(MediaPlayer.trackArtUrl)
  // }
  ColumnLayout {
    anchors.fill: parent
    anchors.margins: Style.marginLarge * scaling

    ColumnLayout {
      id: fallback
      visible: !main.visible
      spacing: Style.marginMedium * scaling

      Item {
        Layout.fillWidth: true
      }
      NText {
        text: "music_note"
        font.family: "Material Symbols Outlined"
        font.pointSize: 28 * scaling
        color: Colors.textSecondary
        Layout.alignment: Qt.AlignHCenter
      }
      NText {
        text: "No media player detected"
        color: Colors.textDisabled
        Layout.alignment: Qt.AlignHCenter
      }
      Item {
        Layout.fillWidth: true
      }
    }

    ColumnLayout {
      id: main

      visible: MediaPlayer.currentPlayer
      spacing: Style.marginMedium * scaling

      RowLayout {
        spacing: Style.marginMedium * scaling

        // Rounded thumbnail image
        Rectangle {

          width: 90 * scaling
          height: 90 * scaling
          radius: width * 0.5
          color: trackArt.visible ? Colors.accentPrimary : "transparent"
          border.color: trackArt.visible ? Colors.outline : "transparent"
          border.width: Math.max(1, Style.borderThin * scaling)
          clip: true

          NImageRounded {
            id: trackArt
            visible: MediaPlayer.trackArtUrl.toString() !== ""

            anchors.fill: parent
            anchors.margins: Style.marginTiny * scaling
            imagePath: MediaPlayer.trackArtUrl
            fallbackIcon: "image"
            borderColor: Colors.outline
            borderWidth: Math.max(1, Style.borderThin * scaling)
            imageRadius: width * 0.5
          }

          // Fallback icon when no album art available
          NText {
            anchors.centerIn: parent
            text: "album"
            font.family: "Material Symbols Outlined"
            font.pointSize: Style.fontSizeLarge * 12 * scaling
            visible: !trackArt.visible
          }
        }

        // -------------------------
        // Track metadata
        ColumnLayout {
          Layout.fillWidth: true
          spacing: Style.marginTiny * scaling

          NText {
            visible: MediaPlayer.trackTitle !== ""
            text: MediaPlayer.trackTitle
            font.pointSize: Style.fontSizeMedium * scaling
            font.weight: Style.fontWeightBold
            elide: Text.ElideRight
            wrapMode: Text.Wrap
            maximumLineCount: 2
            Layout.fillWidth: true
          }

          NText {
            visible: MediaPlayer.trackArtist !== ""
            text: MediaPlayer.trackArtist
            color: Colors.textSecondary
            font.pointSize: Style.fontSizeSmall * scaling
            elide: Text.ElideRight
            Layout.fillWidth: true
          }

          NText {
            visible: MediaPlayer.trackAlbum !== ""
            text: MediaPlayer.trackAlbum
            color: Colors.textSecondary
            font.pointSize: Style.fontSizeSmall * scaling
            elide: Text.ElideRight
            Layout.fillWidth: true
          }
        }
      }

      // -------------------------
      // Progress bar
      Rectangle {
        id: progressBarBackground
        width: parent.width
        height: 4 * scaling
        radius: Style.radiusSmall * scaling
        color: Colors.backgroundTertiary
        Layout.fillWidth: true

        property real progressRatio: {
          if (!MediaPlayer.currentPlayer || !MediaPlayer.isPlaying || MediaPlayer.trackLength <= 0) {
            return 0
          }
          return Math.min(1, MediaPlayer.currentPosition / MediaPlayer.trackLength)
        }

        Rectangle {
          id: progressFill
          width: progressBarBackground.progressRatio * parent.width
          height: parent.height
          radius: parent.radius
          color: Colors.accentPrimary

          Behavior on width {
            NumberAnimation {
              duration: 200
            }
          }
        }

        // Interactive progress handle
        Rectangle {
          id: progressHandle
          width: 16 * scaling
          height: 16 * scaling
          radius: width * 0.5
          color: Colors.accentPrimary
          border.color: Colors.backgroundPrimary
          border.width: Math.max(1 * Style.borderMedium * scaling)

          x: Math.max(0, Math.min(parent.width - width, progressFill.width - width / 2))
          anchors.verticalCenter: parent.verticalCenter

          visible: MediaPlayer.trackLength > 0
          scale: progressMouseArea.containsMouse || progressMouseArea.pressed ? 1.2 : 1.0

          Behavior on scale {
            NumberAnimation {
              duration: 150
            }
          }
        }

        // Mouse area for seeking
        MouseArea {
          id: progressMouseArea
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          enabled: MediaPlayer.trackLength > 0 && MediaPlayer.canSeek

          onClicked: function (mouse) {
            let ratio = mouse.x / width
            MediaPlayer.seekByRatio(ratio)
          }

          onPositionChanged: function (mouse) {
            if (pressed) {
              let ratio = Math.max(0, Math.min(1, mouse.x / width))
              MediaPlayer.seekByRatio(ratio)
            }
          }
        }
      }

      // -------------------------
      // Media controls
      RowLayout {
        spacing: Style.marginMedium * scaling
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter

        // Previous button
        NIconButton {
          icon: "skip_previous"
          onClicked: MediaPlayer.canGoPrevious ? MediaPlayer.previous() : {}
        }

        // Play/Pause button
        NIconButton {
          icon: MediaPlayer.isPlaying ? "pause" : "play_arrow"
          onClicked: (MediaPlayer.canPlay || MediaPlayer.canPause) ? MediaPlayer.playPause() : {}
        }

        // Next button
        NIconButton {
          icon: "skip_next"
          onClicked: MediaPlayer.canGoNext ? MediaPlayer.next() : {}
        }
      }
    }
  }
}// import QtQuick// import QtQuick.Controls// import QtQuick.Layouts// import QtQuick.Effects// import qs.Settings// import qs.Components// import qs.Services

// Rectangle {
//     id: musicCard
//     color: "transparent"

//     Rectangle {
//         id: card
//         anchors.fill: parent
//         color: Theme.surface
//         radius: 18 * scaling

//         // Show fallback UI if no player is available
//         Item {
//             width: parent.width
//             height: parent.height
//             visible: !MusicManager.currentPlayer

//             ColumnLayout {
//                 anchors.centerIn: parent
//                 spacing: 16 * scaling

//                 Text {
//                     text: "music_note"
//                     font.family: "Material Symbols Outlined"
//                     font.pixelSize: Theme.fontSizeHeader * scaling
//                     color: Qt.rgba(Theme.textPrimary.r, Theme.textPrimary.g, Theme.textPrimary.b, 0.3)
//                     Layout.alignment: Qt.AlignHCenter
//                 }

//                 Text {
//                     text: MusicManager.hasPlayer ? "No controllable player selected" : "No music player detected"
//                     color: Qt.rgba(Theme.textPrimary.r, Theme.textPrimary.g, Theme.textPrimary.b, 0.6)
//                     font.family: Theme.fontFamily
//                     font.pixelSize: Theme.fontSizeSmall * scaling
//                     Layout.alignment: Qt.AlignHCenter
//                 }
//             }
//         }

//         // Main player UI
//         ColumnLayout {
//             anchors.fill: parent
//             anchors.margins: 18 * scaling
//             spacing: 12 * scaling
//             visible: !!MusicManager.currentPlayer

//             // Player selector
//             ComboBox {
//                 id: playerSelector
//                 Layout.fillWidth: true
//                 Layout.preferredHeight: 40 * scaling
//                 visible: MusicManager.getAvailablePlayers().length > 1
//                 model: MusicManager.getAvailablePlayers()
//                 textRole: "identity"
//                 currentIndex: MusicManager.selectedPlayerIndex

//                 background: Rectangle {
//                     implicitWidth: 120 * scaling
//                     implicitHeight: 40 * scaling
//                     color: Theme.surfaceVariant
//                     border.color: playerSelector.activeFocus ? Theme.accentPrimary : Theme.outline
//                     border.width: 1 * scaling
//                     radius: 16 * scaling
//                 }

//                 contentItem: Text {
//                     leftPadding: 12 * scaling
//                     rightPadding: playerSelector.indicator.width + playerSelector.spacing
//                     text: playerSelector.displayText
//                     font.pixelSize: 13 * scaling
//                     color: Theme.textPrimary
//                     verticalAlignment: Text.AlignVCenter
//                     elide: Text.ElideRight
//                 }

//                 indicator: Text {
//                     x: playerSelector.width - width - 12 * scaling
//                     y: playerSelector.topPadding + (playerSelector.availableHeight - height) / 2
//                     text: "arrow_drop_down"
//                     font.family: "Material Symbols Outlined"
//                     font.pixelSize: 24 * scaling
//                     color: Theme.textPrimary
//                 }

//                 popup: Popup {
//                     y: playerSelector.height
//                     width: playerSelector.width
//                     implicitHeight: contentItem.implicitHeight
//                     padding: 1 * scaling

//                     contentItem: ListView {
//                         clip: true
//                         implicitHeight: contentHeight
//                         model: playerSelector.popup.visible ? playerSelector.delegateModel : null
//                         currentIndex: playerSelector.highlightedIndex

//                         ScrollIndicator.vertical: ScrollIndicator {}
//                     }

//                     background: Rectangle {
//                         color: Theme.surfaceVariant
//                         border.color: Theme.outline
//                         border.width: 1 * scaling
//                         radius: 16
//                     }
//                 }

//                 delegate: ItemDelegate {
//                     width: playerSelector.width
//                     contentItem: Text {
//                         text: modelData.identity
//                         font.pixelSize: 13 * scaling
//                         color: Theme.textPrimary
//                         verticalAlignment: Text.AlignVCenter
//                         elide: Text.ElideRight
//                     }
//                     highlighted: playerSelector.highlightedIndex === index

//                     background: Rectangle {
//                         color: highlighted ? Theme.accentPrimary.toString().replace(/#/, "#1A") : "transparent"
//                     }
//                 }

//                 onActivated: {
//                     MusicManager.selectedPlayerIndex = index;
//                     MusicManager.updateCurrentPlayer();
//                 }
//             }

//             // Album art with spectrum visualizer
//             RowLayout {
//                 spacing: 12 * scaling
//                 Layout.fillWidth: true

//                 // Album art container with circular spectrum overlay
//                 Item {
//                     id: albumArtContainer
//                     width: 96 * scaling
//                     height: 96 * scaling // enough for spectrum and art (will adjust if needed)
//                     Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

//                     // Circular spectrum visualizer around album art
//                     CircularSpectrum {
//                         id: spectrum
//                         values: MusicManager.cavaValues
//                         anchors.centerIn: parent
//                         innerRadius: 30 * scaling // Position just outside 60x60 album art
//                         outerRadius: 48 * scaling // Extend bars outward from album art
//                         fillColor: Theme.accentPrimary
//                         strokeColor: Theme.accentPrimary
//                         strokeWidth: 0 * scaling
//                         z: 0
//                     }

//                     // Album art image
//                     Rectangle {
//                         id: albumArtwork
//                         width: 60 * scaling
//                         height: 60 * scaling
//                         anchors.centerIn: parent
//                         radius: width * 0.5
//                         color: Qt.darker(Theme.surface, 1.1)
//                         border.color: Qt.rgba(Theme.accentPrimary.r, Theme.accentPrimary.g, Theme.accentPrimary.b, 0.3)
//                         border.width: 1 * scaling

//                         Image {
//                             id: albumArt
//                             anchors.fill: parent
//                             anchors.margins: 2 * scaling
//                             fillMode: Image.PreserveAspectCrop
//                             smooth: true
//                             mipmap: true
//                             cache: false
//                             asynchronous: true
//                             sourceSize.width: 60 * scaling
//                             sourceSize.height: 60 * scaling
//                             source: MusicManager.trackArtUrl
//                             visible: source.toString() !== ""

//                         // Apply circular mask for rounded corners
//                             layer.enabled: true
//                             layer.effect: MultiEffect {
//                                 maskEnabled: true
//                                 maskSource: mask
//                             }
//                         }

//                         Item {
//                             id: mask

//                             anchors.fill: albumArt
//                             layer.enabled: true
//                             visible: false

//                             Rectangle {
//                                 width: albumArt.width
//                                 height: albumArt.height
//                                 radius: albumArt.width / 2 // circle
//                             }
//                         }

//                         // Fallback icon when no album art available
//                         Text {
//                             anchors.centerIn: parent
//                             text: "album"
//                             font.family: "Material Symbols Outlined"
//                             font.pixelSize: Theme.fontSizeBody * scaling
//                             color: Qt.rgba(Theme.textPrimary.r, Theme.textPrimary.g, Theme.textPrimary.b, 0.4)
//                             visible: !albumArt.visible
//                         }
//                     }
//                 }

//             // Progress bar
//             Rectangle {
//                 id: progressBarBackground
//                 width: parent.width
//                 height: 6 * scaling
//                 radius: 3
//                 color: Qt.rgba(Theme.textPrimary.r, Theme.textPrimary.g, Theme.textPrimary.b, 0.15)
//                 Layout.fillWidth: true

//                 property real progressRatio: {
//                     if (!MusicManager.currentPlayer || !MusicManager.isPlaying || MusicManager.trackLength <= 0) {
//                         return 0;
//                     }
//                     return Math.min(1, MusicManager.currentPosition / MusicManager.trackLength);
//                 }

//                 Rectangle {
//                     id: progressFill
//                     width: progressBarBackground.progressRatio * parent.width
//                     height: parent.height
//                     radius: parent.radius
//                     color: Theme.accentPrimary

//                     Behavior on width {
//                         NumberAnimation {
//                             duration: 200
//                         }
//                     }
//                 }

//                 // Interactive progress handle
//                 Rectangle {
//                     id: progressHandle
//                     width: 12 * scaling
//                     height: 12 * scaling
//                     radius: width * 0.5
//                     color: Theme.accentPrimary
//                     border.color: Qt.lighter(Theme.accentPrimary, 1.3)
//                     border.width: 1 * scaling

//                     x: Math.max(0, Math.min(parent.width - width, progressFill.width - width / 2))
//                     anchors.verticalCenter: parent.verticalCenter

//                     visible: MusicManager.trackLength > 0
//                     scale: progressMouseArea.containsMouse || progressMouseArea.pressed ? 1.2 : 1.0

//                     Behavior on scale {
//                         NumberAnimation {
//                             duration: 150
//                         }
//                     }
//                 }

//                 // Mouse area for seeking
//                 MouseArea {
//                     id: progressMouseArea
//                     anchors.fill: parent
//                     hoverEnabled: true
//                     cursorShape: Qt.PointingHandCursor
//                     enabled: MusicManager.trackLength > 0 && MusicManager.canSeek

//                     onClicked: function (mouse) {
//                         let ratio = mouse.x / width;
//                         MusicManager.seekByRatio(ratio);
//                     }

//                     onPositionChanged: function (mouse) {
//                         if (pressed) {
//                             let ratio = Math.max(0, Math.min(1, mouse.x / width));
//                             MusicManager.seekByRatio(ratio);
//                         }
//                     }
//                 }
//             }

//             // Media controls
//             RowLayout {
//                 spacing: 4 * scaling
//                 Layout.fillWidth: true
//                 Layout.alignment: Qt.AlignHCenter

//                 // Previous button
//                 Rectangle {
//                     width: 28 * scaling
//                     height: 28 * scaling
//                     radius: width * 0.5
//                     color: previousButton.containsMouse ? Qt.rgba(Theme.accentPrimary.r, Theme.accentPrimary.g, Theme.accentPrimary.b, 0.2) : Qt.darker(Theme.surface, 1.1)
//                     border.color: Qt.rgba(Theme.accentPrimary.r, Theme.accentPrimary.g, Theme.accentPrimary.b, 0.3)
//                     border.width: 1 * scaling

//                     MouseArea {
//                         id: previousButton
//                         anchors.fill: parent
//                         hoverEnabled: true
//                         cursorShape: Qt.PointingHandCursor
//                         enabled: MusicManager.canGoPrevious
//                         onClicked: MusicManager.previous()
//                     }

//                     Text {
//                         anchors.centerIn: parent
//                         text: "skip_previous"
//                         font.family: "Material Symbols Outlined"
//                         font.pixelSize: Theme.fontSizeCaption * scaling
//                         color: previousButton.enabled ? Theme.accentPrimary : Qt.rgba(Theme.textPrimary.r, Theme.textPrimary.g, Theme.textPrimary.b, 0.3)
//                     }
//                 }

//                 // Play/Pause button
//                 Rectangle {
//                     width: 36 * scaling
//                     height: 36 * scaling
//                     radius: width * 0.5
//                     color: playButton.containsMouse ? Qt.rgba(Theme.accentPrimary.r, Theme.accentPrimary.g, Theme.accentPrimary.b, 0.2) : Qt.darker(Theme.surface, 1.1)
//                     border.color: Theme.accentPrimary
//                     border.width: 2 * scaling

//                     MouseArea {
//                         id: playButton
//                         anchors.fill: parent
//                         hoverEnabled: true
//                         cursorShape: Qt.PointingHandCursor
//                         enabled: MusicManager.canPlay || MusicManager.canPause
//                         onClicked: MusicManager.playPause()
//                     }

//                     Text {
//                         anchors.centerIn: parent
//                         text: MusicManager.isPlaying ? "pause" : "play_arrow"
//                         font.family: "Material Symbols Outlined"
//                         font.pixelSize: Theme.fontSizeBody * scaling
//                         color: playButton.enabled ? Theme.accentPrimary : Qt.rgba(Theme.textPrimary.r, Theme.textPrimary.g, Theme.textPrimary.b, 0.3)
//                     }
//                 }

//                 // Next button
//                 Rectangle {
//                     width: 28 * scaling
//                     height: 28 * scaling
//                     radius: width * 0.5
//                     color: nextButton.containsMouse ? Qt.rgba(Theme.accentPrimary.r, Theme.accentPrimary.g, Theme.accentPrimary.b, 0.2) : Qt.darker(Theme.surface, 1.1)
//                     border.color: Qt.rgba(Theme.accentPrimary.r, Theme.accentPrimary.g, Theme.accentPrimary.b, 0.3)
//                     border.width: 1 * scaling

//                     MouseArea {
//                         id: nextButton
//                         anchors.fill: parent
//                         hoverEnabled: true
//                         cursorShape: Qt.PointingHandCursor
//                         enabled: MusicManager.canGoNext
//                         onClicked: MusicManager.next()
//                     }

//                     Text {
//                         anchors.centerIn: parent
//                         text: "skip_next"
//                         font.family: "Material Symbols Outlined"
//                         font.pixelSize: Theme.fontSizeCaption * scaling
//                         color: nextButton.enabled ? Theme.accentPrimary : Qt.rgba(Theme.textPrimary.r, Theme.textPrimary.g, Theme.textPrimary.b, 0.3)
//                     }
//                 }
//             }
//         }
//     }
// }


import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.Modules.Audio
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

    // Fallback
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

    // MediaPlayer Main Content
    ColumnLayout {
      id: main

      visible: MediaPlayer.currentPlayer
      spacing: Style.marginMedium * scaling

      // Player selector
      ComboBox {
        id: playerSelector
        Layout.fillWidth: true
        Layout.preferredHeight: 30 * scaling
        visible: MediaPlayer.getAvailablePlayers().length > 1
        model: MediaPlayer.getAvailablePlayers()
        textRole: "identity"
        currentIndex: MediaPlayer.selectedPlayerIndex

        background: Rectangle {
          // implicitWidth: 120 * scaling
          // implicitHeight: 30 * scaling
          color: "transparent"
          border.color: playerSelector.activeFocus ? Colors.hover : Colors.outline
          border.width: Math.max(1, Style.borderThin * scaling)
          radius: Style.radiusMedium * scaling
        }

        contentItem: NText {
          leftPadding: Style.marginMedium * scaling
          rightPadding: playerSelector.indicator.width + playerSelector.spacing
          text: playerSelector.displayText
          font.pointSize: Style.fontSizeSmall * scaling
          color: Colors.textPrimary
          verticalAlignment: Text.AlignVCenter
          elide: Text.ElideRight
        }

        indicator: Text {
          x: playerSelector.width - width - Style.marginMedium * scaling
          y: playerSelector.topPadding + (playerSelector.availableHeight - height) / 2
          text: "arrow_drop_down"
          font.family: "Material Symbols Outlined"
          font.pointSize: Style.marginXL * scaling
          color: Colors.textPrimary
        }

        popup: Popup {
          y: playerSelector.height
          width: playerSelector.width
          implicitHeight: Math.min(160 * scaling, contentItem.implicitHeight + Style.marginMedium * scaling * 2)
          padding: Style.marginSmall * scaling

          contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: playerSelector.popup.visible ? playerSelector.delegateModel : null
            currentIndex: playerSelector.highlightedIndex
            ScrollIndicator.vertical: ScrollIndicator {}
          }

          background: Rectangle {
            color: Colors.backgroundSecondary
            border.color: Colors.outline
            border.width: Math.max(1, Style.borderThin * scaling)
            radius: Style.radiusMedium * scaling
          }
        }

        delegate: ItemDelegate {
          width: playerSelector.width
          contentItem: NText {
            text: modelData.identity
            font.pointSize: Style.fontSizeSmall * scaling
            color: highlighted ? Colors.backgroundPrimary : Colors.textPrimary
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
          }
          highlighted: playerSelector.highlightedIndex === index

          background: Rectangle {
            width: playerSelector.width - Style.marginSmall * scaling * 2
            color: highlighted ? Colors.hover : "transparent"
            radius: Style.radiusSmall * scaling
          }
        }

        onActivated: {
          MediaPlayer.selectedPlayerIndex = currentIndex
          MediaPlayer.updateCurrentPlayer()
        }
      }

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

    Loader {
      active: Settings.data.audio.visualizerType == "linear"
      Layout.alignment: Qt.AlignHCenter

      sourceComponent: 
      LinearSpectrum {
        width: 300 * scaling
        height: 80 * scaling
        values: Cava.values
        fillColor: Colors.textPrimary
        Layout.alignment: Qt.AlignHCenter
      }
    }

    // CircularSpectrum {
    //   visible: Settings.data.audio.visualizerType == "radial"
    //   values: Cava.values
    //   innerRadius: 30 * scaling // Position just outside 60x60 album art
    //   outerRadius: 48 * scaling // Extend bars outward from album art
    //   fillColor: Colors.accentPrimary
    //   strokeColor: Colors.accentPrimary
    //   strokeWidth: 0 * scaling
    // }
  }
}

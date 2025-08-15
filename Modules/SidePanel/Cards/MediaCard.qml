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
    Layout.fillHeight: true
    anchors.margins: Style.marginLarge * scaling

    // Fallback
    ColumnLayout {
      id: fallback

      visible: !main.visible
      spacing: Style.marginSmall * scaling

      Item {
        Layout.fillWidth: true
        Layout.fillHeight: true
      }

      NText {
        text: "album"
        font.family: "Material Symbols Outlined"
        font.pointSize: Style.fontSizeXXL * 2.5 * scaling
        color: Colors.mOnSurfaceVariant
        Layout.alignment: Qt.AlignHCenter
      }
      NText {
        text: "No media player detected"
        color: Colors.mOnSurfaceVariant
        Layout.alignment: Qt.AlignHCenter
      }

      Item {
        Layout.fillWidth: true
      }
    }

    // MediaPlayer Main Content
    ColumnLayout {
      id: main

      visible: MediaPlayer.currentPlayer && MediaPlayer.canPlay
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
          visible: false
          // implicitWidth: 120 * scaling
          // implicitHeight: 30 * scaling
          color: "transparent"
          border.color: playerSelector.activeFocus ? Colors.mTertiary : Colors.mOutline
          border.width: Math.max(1, Style.borderThin * scaling)
          radius: Style.radiusMedium * scaling
        }

        contentItem: NText {
          visible: false
          leftPadding: Style.marginMedium * scaling
          rightPadding: playerSelector.indicator.width + playerSelector.spacing
          text: playerSelector.displayText
          font.pointSize: Style.fontSizeSmall * scaling
          color: Colors.mOnSurface
          verticalAlignment: Text.AlignVCenter
          elide: Text.ElideRight
        }

        indicator: Text {
          x: playerSelector.width - width
          y: playerSelector.topPadding + (playerSelector.availableHeight - height) / 2
          text: "arrow_drop_down"
          font.family: "Material Symbols Outlined"
          font.pointSize: Style.fontSizeXL * scaling
          color: Colors.mOnSurface
          horizontalAlignment: Text.AlignRight
        }

        popup: Popup {
          id: popup
          x: playerSelector.width * 0.5
          y: playerSelector.height * 0.75
          width: playerSelector.width * 0.5
          implicitHeight: Math.min(160 * scaling, contentItem.implicitHeight + Style.marginMedium * scaling)
          padding: Style.marginSmall * scaling

          contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: playerSelector.popup.visible ? playerSelector.delegateModel : null
            currentIndex: playerSelector.highlightedIndex
            ScrollIndicator.vertical: ScrollIndicator {}
          }

          background: Rectangle {
            color: Colors.mSurface
            border.color: Colors.mOutline
            border.width: Math.max(1, Style.borderThin * scaling)
            radius: Style.radiusTiny * scaling
          }
        }

        delegate: ItemDelegate {
          width: playerSelector.width
          contentItem: NText {
            text: modelData.identity
            font.pointSize: Style.fontSizeSmall * scaling
            color: highlighted ? Colors.mSurface : Colors.mOnSurface
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
          }
          highlighted: playerSelector.highlightedIndex === index

          background: Rectangle {
            width: popup.width - Style.marginSmall * scaling * 2
            color: highlighted ? Colors.mTertiary : "transparent"
            radius: Style.radiusTiny * scaling
          }
        }

        onActivated: {
          MediaPlayer.selectedPlayerIndex = currentIndex
          MediaPlayer.updateCurrentPlayer()
        }
      }

      RowLayout {
        spacing: Style.marginMedium * scaling

        // -------------------------
        // Rounded thumbnail image
        Rectangle {

          width: 90 * scaling
          height: 90 * scaling
          radius: width * 0.5
          color: trackArt.visible ? Colors.mPrimary : "transparent"
          border.color: trackArt.visible ? Colors.mOutline : "transparent"
          border.width: Math.max(1, Style.borderThin * scaling)
          clip: true

          NImageRounded {
            id: trackArt
            visible: MediaPlayer.trackArtUrl.toString() !== ""

            anchors.fill: parent
            anchors.margins: Style.marginTiny * scaling
            imagePath: MediaPlayer.trackArtUrl
            fallbackIcon: "image"
            borderColor: Colors.mOutline
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
            color: Colors.mOnSurface
            font.pointSize: Style.fontSizeSmall * scaling
            elide: Text.ElideRight
            Layout.fillWidth: true
          }

          NText {
            visible: MediaPlayer.trackAlbum !== ""
            text: MediaPlayer.trackAlbum
            color: Colors.mOnSurface
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
        visible: (MediaPlayer.currentPlayer && MediaPlayer.trackLength > 0)
        width: parent.width
        height: 4 * scaling
        radius: Style.radiusSmall * scaling
        color: Colors.mSurface
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
          color: Colors.mPrimary

          Behavior on width {
            NumberAnimation {
              duration: 200
            }
          }
        }

        // Interactive progress handle
        Rectangle {
          id: progressHandle
          visible: (MediaPlayer.currentPlayer && MediaPlayer.trackLength > 0)
          width: 16 * scaling
          height: 16 * scaling
          radius: width * 0.5
          color: Colors.mPrimary
          border.color: Colors.mSurface
          border.width: Math.max(1 * Style.borderMedium * scaling)
          x: Math.max(0, Math.min(parent.width - width, progressFill.width - width / 2))
          anchors.verticalCenter: parent.verticalCenter
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

      sourceComponent: LinearSpectrum {
        width: 300 * scaling
        height: 80 * scaling
        values: Cava.values
        fillColor: Colors.mOnSurface
        Layout.alignment: Qt.AlignHCenter
      }
    }
  }
}

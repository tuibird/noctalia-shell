import QtQuick
import QtQuick.Layouts
import qs.Services
import qs.Widgets

Item {
  id: root

  width: visible ? mediaRow.width : 0
  height: Style.barHeight * scaling
  visible: Settings.data.bar.showMedia && (MediaPlayer.canPlay || MediaPlayer.canPause)

  RowLayout {
    id: mediaRow
    height: parent.height
    spacing: Style.spacingTiniest * scaling

    NIconButton {
      icon: MediaPlayer.isPlaying ? "pause" : "play_arrow"
      tooltipText: "Play/pause media"
      sizeMultiplier: 0.8
      showBorder: false
      onClicked: MediaPlayer.playPause()
    }

    // Track info
    NText {
      text: MediaPlayer.trackTitle + " - " + MediaPlayer.trackArtist
      color: Colors.mOnSurface
      font.pointSize: Style.fontSizeSmall * scaling
      elide: Text.ElideRight
      Layout.maximumWidth: 200 * scaling
      Layout.alignment: Qt.AlignVCenter
    }
  }
}

import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Services
import qs.Widgets

Item {
  id: root

  width: visible ? mediaRow.width : 0
  height: Style.barHeight * scaling
  visible: Settings.data.bar.showMedia && (MediaService.canPlay || MediaService.canPause)

  RowLayout {
    id: mediaRow
    height: parent.height
    spacing: Style.spacingTiniest * scaling

    // NIconButton {
    //   icon: MediaService.isPlaying ? "pause" : "play_arrow"
    //   tooltipText: "Play/pause media"
    //   sizeMultiplier: 0.8
    //   showBorder: false
    //   onClicked: MediaService.playPause()
    // }
    NText {
      text: MediaService.isPlaying ? "pause" : "play_arrow"
      font.family: "Material Symbols Outlined"
      font.pointSize: Style.fontSizeLarge * scaling
      verticalAlignment: Text.AlignVCenter

      MouseArea {
        id: titleContainerMouseArea
        anchors.fill: parent

        onClicked: {
          onClicked: MediaService.playPause()
        }
      }
    }

    // Track info
    NText {
      text: MediaService.trackTitle + (MediaService.trackArtist !== "" ? ` - {MediaService.trackArtist}` : "")
      font.pointSize: Style.fontSizeReduced * scaling
      font.weight: Style.fontWeightBold
      elide: Text.ElideRight
      color: Color.mSecondary
      verticalAlignment: Text.AlignVCenter
      Layout.maximumWidth: 200 * scaling
      Layout.alignment: Qt.AlignVCenter
    }
  }
}

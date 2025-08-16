import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import qs.Commons
import qs.Services
import qs.Widgets

NLoader {
  active: WorkspacesService.isNiri

  Component.onCompleted: {
    if (WorkspacesService.isNiri) {
      Logger.log("Overview", "Loading Overview component (Niri detected)")
    } else {
      Logger.log("Overview", "Skipping Overview component (Niri not detected)")
    }
  }

  sourceComponent: Variants {
    model: Quickshell.screens

    delegate: PanelWindow {
      required property ShellScreen modelData
      property string wallpaperSource: WallpapersService.currentWallpaper !== ""
                                       && !Settings.data.wallpaper.swww.enabled ? WallpapersService.currentWallpaper : ""

      visible: wallpaperSource !== "" && !Settings.data.wallpaper.swww.enabled
      color: "transparent"
      screen: modelData
      WlrLayershell.layer: WlrLayer.Background
      WlrLayershell.exclusionMode: ExclusionMode.Ignore
      WlrLayershell.namespace: "quickshell-overview"

      anchors {
        top: true
        bottom: true
        right: true
        left: true
      }

      Image {
        id: bgImage

        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: wallpaperSource
        cache: true
        smooth: true
        mipmap: false
        visible: wallpaperSource !== ""
      }

      MultiEffect {
        id: overviewBgBlur

        anchors.fill: parent
        source: bgImage
        blurEnabled: true
        blur: 0.48
        blurMax: 128
      }

      Rectangle {
        anchors.fill: parent
        color: Qt.rgba(Colors.mSurface.r, Colors.mSurface.g, Colors.mSurface.b, 0.5)
      }
    }
  }
}

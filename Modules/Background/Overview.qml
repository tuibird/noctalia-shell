import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import qs.Services
import qs.Widgets

NLoader {
  active: Workspaces.isNiri

  Component.onCompleted: {
    if (Workspaces.isNiri) {
      console.log("[Overview] Loading Overview component (Niri detected)")
    } else {
      console.log("[Overview] Skipping Overview component (Niri not detected)")
    }
  }

  sourceComponent: Variants {
    model: Quickshell.screens

    delegate: PanelWindow {
      required property ShellScreen modelData
      property string wallpaperSource: Wallpapers.currentWallpaper !== ""
                                       && !Settings.data.wallpaper.swww.enabled ? Wallpapers.currentWallpaper : ""

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

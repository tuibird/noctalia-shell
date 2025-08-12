import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Services

Variants {
  model: Quickshell.screens

  delegate: PanelWindow {
    required property ShellScreen modelData
    property string wallpaperSource: Wallpapers.currentWallpaper !== ""
                                     && !Settings.data.wallpaper.swww.enabled ? Wallpapers.currentWallpaper : ""

    visible: wallpaperSource !== "" && !Settings.data.wallpaper.swww.enabled

    // Force update when SWWW setting changes
    onVisibleChanged: {
      if (visible) {
        console.log("Background: Showing wallpaper:", wallpaperSource)
      } else {
        console.log("Background: Hiding wallpaper (SWWW enabled)")
      }
    }
    color: "transparent"
    screen: modelData
    WlrLayershell.layer: WlrLayer.Background
    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    WlrLayershell.namespace: "quickshell-wallpaper"

    anchors {
      bottom: true
      top: true
      right: true
      left: true
    }

    margins {
      top: 0
    }

    Image {
      anchors.fill: parent
      fillMode: Image.PreserveAspectCrop
      source: wallpaperSource
      visible: wallpaperSource !== ""
      cache: true
      smooth: true
      mipmap: false
    }
  }
}

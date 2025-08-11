import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Services

Variants {
  model: Quickshell.screens

  delegate: PanelWindow {
    required property ShellScreen modelData
    property string wallpaperSource: Qt.resolvedUrl("../../Assets/Tests/wallpaper.png")
    //property string wallpaperSource: Qt.resolvedUrl("/home/lysec/Pictures/wallpapers/wallhaven-6lqvql.jpg")

    visible: wallpaperSource !== ""
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

import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Services

ShellRoot {
    
    property var modelData
    property string wallpaperSource: "/home/lysec/Pictures/wallpapers/wallhaven-6lqvql.jpg"

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property ShellScreen modelData

            visible: wallpaperSource !== ""
            anchors {
                bottom: true
                top: true
                right: true
                left: true
            }
            margins {
                top: 0
            }
            color: "transparent"
            screen: modelData
            WlrLayershell.layer: WlrLayer.Background
            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            WlrLayershell.namespace: "quickshell-wallpaper"
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


}
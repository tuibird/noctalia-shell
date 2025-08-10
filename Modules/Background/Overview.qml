import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import qs.Services

ShellRoot {
    property string wallpaperSource: "/home/lysec/Pictures/wallpapers/wallhaven-6lqvql.jpg"
    property var modelData

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property ShellScreen modelData

            visible: wallpaperSource !== ""
            anchors {
                top: true
                bottom: true
                right: true
                left: true
            }
            color: "transparent"
            screen: modelData
            WlrLayershell.layer: WlrLayer.Background
            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            WlrLayershell.namespace: "quickshell-overview"
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
                color: Qt.rgba(
                    Colors.backgroundPrimary.r,
                    Colors.backgroundPrimary.g,
                    Colors.backgroundPrimary.b, 0.5)
            }
        }
    }
}

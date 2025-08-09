import QtQuick
import Quickshell

PanelWindow {
    id: root

    property var modelData

    screen: modelData
    implicitHeight: 36
    color: "transparent"

    anchors {
        top: true
        left: true
        right: true
    }

    Item {
        anchors.fill: parent

        Rectangle {
            anchors.fill: parent
            color: "purple"
            layer.enabled: true
        }
    }
}

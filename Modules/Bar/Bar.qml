import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.Services
import qs.Widgets

Variants {
    model: Quickshell.screens

    delegate: PanelWindow {
        id: root

        required property ShellScreen modelData
        readonly property real scaling: Scaling.scale(screen)

        screen: modelData
        implicitHeight: Style.barHeight * scaling
        color: "transparent"
        visible: Settings.data.bar.monitors.includes(modelData.name) || (Settings.data.bar.monitors.length === 0)

        anchors {
            top: true
            left: true
            right: true
        }

        Item {
            anchors.fill: parent
            clip: true

            // Background fill
            Rectangle {
                id: bar

                anchors.fill: parent
                color: Colors.backgroundPrimary
                layer.enabled: true
            }

            Row {
                id: leftSection

                height: parent.height
                anchors.left: parent.left
                anchors.leftMargin: Style.marginSmall * scaling
                anchors.verticalCenter: parent.verticalCenter
                spacing: Style.marginSmall * scaling

                NText {
                    text: screen.name
                    anchors.verticalCenter: parent.verticalCenter
                }

            }

            Row {
                id: centerSection

                height: parent.height
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                spacing: Style.marginSmall * scaling

                Workspace {
                }

            }

            Row {
                id: rightSection

                height: parent.height
                anchors.right: bar.right
                anchors.rightMargin: Style.marginSmall * scaling
                anchors.verticalCenter: bar.verticalCenter
                spacing: Style.marginSmall * scaling

                Clock {
                    anchors.verticalCenter: parent.verticalCenter
                }

                NIconButton {
                    id: demoPanelToggle

                    icon: "experiment"
                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: function() {
                        demoPanel.isLoaded = !demoPanel.isLoaded;
                    }
                }

                NIconButton {
                    id: sidePanelToggle

                    icon: "widgets"
                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: function() {
                        // Map this button's center to the screen and open the side panel below it
                        const localCenterX = width / 2;
                        const localCenterY = height / 2;
                        const globalPoint = mapToItem(null, localCenterX, localCenterY);
                        if (sidePanel.isLoaded)
                            sidePanel.isLoaded = false;
                        else if (sidePanel.openAt)
                            sidePanel.openAt(globalPoint.x, screen);
                        else
                            // Fallback: toggle if API unavailable
                            sidePanel.isLoaded = true;
                    }
                }

            }

        }

    }

}

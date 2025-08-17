import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import qs.Commons
import qs.Services
import qs.Widgets

// Loader for Bluetooth menu
NLoader {
  id: root

  content: Component {
    NPanel {
      id: bluetoothPanel

      function hide() {
        bluetoothMenuRect.scaleValue = 0.8
        bluetoothMenuRect.opacityValue = 0.0
        hideTimer.start()
      }

      // Connect to NPanel's dismissed signal to handle external close events
      Connections {
        target: bluetoothPanel
        ignoreUnknownSignals: true
        function onDismissed() {
          // Start hide animation
          bluetoothMenuRect.scaleValue = 0.8
          bluetoothMenuRect.opacityValue = 0.0
          // Hide after animation completes
          hideTimer.start()
        }
      }

      // Also handle visibility changes from external sources
      onVisibleChanged: {
        if (visible && Settings.data.network.bluetoothEnabled) {
          // Always refresh devices when menu opens to get fresh device objects
          BluetoothService.refreshDevices()
        } else if (bluetoothMenuRect.opacityValue > 0) {
          // Start hide animation
          bluetoothMenuRect.scaleValue = 0.8
          bluetoothMenuRect.opacityValue = 0.0
          // Hide after animation completes
          hideTimer.start()
        }
      }

      // Timer to hide panel after animation
      Timer {
        id: hideTimer
        interval: Style.animationSlow
        repeat: false
        onTriggered: {
          bluetoothPanel.visible = false
          bluetoothPanel.dismissed()
        }
      }

      WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

      Rectangle {
        id: bluetoothMenuRect
        color: Color.mSurface
        radius: Style.radiusLarge * scaling
        border.color: Color.mOutlineVariant
        border.width: Math.max(1, Style.borderThin * scaling)
        width: 340 * scaling
        height: 500 * scaling
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: Style.marginTiny * scaling
        anchors.rightMargin: Style.marginTiny * scaling

        // Animation properties
        property real scaleValue: 0.8
        property real opacityValue: 0.0

        scale: scaleValue
        opacity: opacityValue

        // Animate in when component is completed
        Component.onCompleted: {
          scaleValue = 1.0
          opacityValue = 1.0
        }

        // Animation behaviors
        Behavior on scale {
          NumberAnimation {
            duration: Style.animationSlow
            easing.type: Easing.OutExpo
          }
        }

        Behavior on opacity {
          NumberAnimation {
            duration: Style.animationNormal
            easing.type: Easing.OutQuad
          }
        }

        ColumnLayout {
          anchors.fill: parent
          anchors.margins: Style.marginLarge * scaling
          spacing: Style.marginMedium * scaling

          RowLayout {
            Layout.fillWidth: true
            spacing: Style.marginMedium * scaling

            NText {
              text: "bluetooth"
              font.family: "Material Symbols Outlined"
              font.pointSize: Style.fontSizeXL * scaling
              color: Color.mPrimary
            }

            NText {
              text: "Bluetooth"
              font.pointSize: Style.fontSizeLarge * scaling
              font.bold: true
              color: Color.mOnSurface
              Layout.fillWidth: true
            }

            NIconButton {
              icon: "refresh"
              tooltipText: "Refresh Devices"
              sizeMultiplier: 0.8
              enabled: Settings.data.network.bluetoothEnabled && !BluetoothService.isDiscovering
              onClicked: {
                BluetoothService.refreshDevices()
              }
            }

            NIconButton {
              icon: "close"
              tooltipText: "Close"
              sizeMultiplier: 0.8
              onClicked: {
                bluetoothPanel.hide()
              }
            }
          }

          NDivider {}

          Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            // Loading indicator
            ColumnLayout {
              anchors.centerIn: parent
              visible: Settings.data.network.bluetoothEnabled && BluetoothService.isDiscovering
              spacing: Style.marginMedium * scaling

              NBusyIndicator {
                running: BluetoothService.isDiscovering
                color: Color.mPrimary
                size: Style.baseWidgetSize * scaling
                Layout.alignment: Qt.AlignHCenter
              }

              NText {
                text: "Scanning for devices..."
                font.pointSize: Style.fontSizeNormal * scaling
                color: Color.mOnSurfaceVariant
                Layout.alignment: Qt.AlignHCenter
              }
            }

            // Bluetooth disabled message
            ColumnLayout {
              anchors.centerIn: parent
              visible: !Settings.data.network.bluetoothEnabled
              spacing: Style.marginMedium * scaling

              NText {
                text: "bluetooth_disabled"
                font.family: "Material Symbols Outlined"
                font.pointSize: Style.fontSizeXXL * scaling
                color: Color.mOnSurfaceVariant
                Layout.alignment: Qt.AlignHCenter
              }

              NText {
                text: "Bluetooth is disabled"
                font.pointSize: Style.fontSizeLarge * scaling
                color: Color.mOnSurfaceVariant
                Layout.alignment: Qt.AlignHCenter
              }

              NText {
                text: "Enable Bluetooth to see available devices"
                font.pointSize: Style.fontSizeNormal * scaling
                color: Color.mOnSurfaceVariant
                Layout.alignment: Qt.AlignHCenter
              }
            }

            // Device list
            ListView {
              id: deviceList
              anchors.fill: parent
              visible: Settings.data.network.bluetoothEnabled && !BluetoothService.isDiscovering
              model: []
              spacing: Style.marginMedium * scaling
              clip: true

              // Combine all devices into a single list for the ListView
              property var allDevices: {
                const devices = []

                // Add connected devices first
                for (const device of BluetoothService.connectedDevices) {
                  devices.push({
                                 "device": device,
                                 "type": 'connected',
                                 "section": 'Connected Devices'
                               })
                }

                // Add paired devices
                for (const device of BluetoothService.pairedDevices) {
                  devices.push({
                                 "device": device,
                                 "type": 'paired',
                                 "section": 'Paired Devices'
                               })
                }

                // Add available devices
                for (const device of BluetoothService.availableDevices) {
                  devices.push({
                                 "device": device,
                                 "type": 'available',
                                 "section": 'Available Devices'
                               })
                }

                return devices
              }

              // Update model when devices change
              onAllDevicesChanged: {
                deviceList.model = allDevices
              }

              // Also watch for changes in the service arrays
              Connections {
                target: BluetoothService
                function onConnectedDevicesChanged() {
                  deviceList.model = deviceList.allDevices
                }
                function onPairedDevicesChanged() {
                  deviceList.model = deviceList.allDevices
                }
                function onAvailableDevicesChanged() {
                  deviceList.model = deviceList.allDevices
                }
              }

              delegate: Item {
                width: parent ? parent.width : 0
                height: Style.baseWidgetSize * 1.5 * scaling

                Rectangle {
                  anchors.fill: parent
                  radius: Style.radiusMedium * scaling
                  color: modelData.device.connected ? Color.mPrimary : (deviceMouseArea.containsMouse ? Color.mTertiary : Color.transparent)

                  RowLayout {
                    anchors.fill: parent
                    anchors.margins: Style.marginSmall * scaling
                    spacing: Style.marginSmall * scaling

                    NText {
                      text: BluetoothService.getDeviceIcon(modelData.device)
                      font.family: "Material Symbols Outlined"
                      font.pointSize: Style.fontSizeXL * scaling
                      color: modelData.device.connected ? Color.mSurface : (deviceMouseArea.containsMouse ? Color.mSurface : Color.mOnSurface)
                    }

                    ColumnLayout {
                      Layout.fillWidth: true
                      spacing: Style.marginTiny * scaling

                      NText {
                        text: modelData.device.name || modelData.device.deviceName || "Unknown Device"
                        font.pointSize: Style.fontSizeNormal * scaling
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                        color: modelData.device.connected ? Color.mSurface : (deviceMouseArea.containsMouse ? Color.mSurface : Color.mOnSurface)
                      }

                      NText {
                        text: {
                          if (modelData.device.connected) {
                            return "Connected"
                          } else if (modelData.device.paired) {
                            return "Paired"
                          } else {
                            return "Available"
                          }
                        }
                        font.pointSize: Style.fontSizeSmall * scaling
                        color: modelData.device.connected ? Color.mSurface : (deviceMouseArea.containsMouse ? Color.mSurface : Color.mOnSurfaceVariant)
                      }

                      NText {
                        text: BluetoothService.getBatteryText(modelData.device)
                        font.pointSize: Style.fontSizeSmall * scaling
                        color: modelData.device.connected ? Color.mSurface : (deviceMouseArea.containsMouse ? Color.mSurface : Color.mOnSurfaceVariant)
                        visible: modelData.device.batteryAvailable
                      }
                    }

                    Item {
                      Layout.preferredWidth: Style.baseWidgetSize * 0.7 * scaling
                      Layout.preferredHeight: Style.baseWidgetSize * 0.7 * scaling
                      visible: modelData.device.pairing || modelData.device.state === 2 // Connecting state

                      NBusyIndicator {
                        visible: modelData.device.pairing || modelData.device.state === 2
                        running: modelData.device.pairing || modelData.device.state === 2
                        color: Color.mPrimary
                        anchors.centerIn: parent
                        size: Style.baseWidgetSize * 0.7 * scaling
                      }
                    }

                    NText {
                      visible: modelData.device.connected
                      text: "connected"
                      font.pointSize: Style.fontSizeSmall * scaling
                      color: modelData.device.connected ? Color.mSurface : (deviceMouseArea.containsMouse ? Color.mSurface : Color.mOnSurface)
                    }
                  }

                  MouseArea {
                    id: deviceMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                      if (modelData.device.connected) {
                        BluetoothService.disconnectDevice(modelData.device)
                      } else if (modelData.device.paired) {
                        BluetoothService.connectDevice(modelData.device)
                      } else {
                        BluetoothService.pairDevice(modelData.device)
                      }
                    }
                  }
                }
              }
            }

            // Empty state when no devices found
            ColumnLayout {
              anchors.centerIn: parent
              visible: Settings.data.network.bluetoothEnabled && !BluetoothService.isDiscovering
                       && deviceList.count === 0
              spacing: Style.marginMedium * scaling

              NText {
                text: "bluetooth_disabled"
                font.family: "Material Symbols Outlined"
                font.pointSize: Style.fontSizeXXL * scaling
                color: Color.mOnSurfaceVariant
                Layout.alignment: Qt.AlignHCenter
              }

              NText {
                text: "No Bluetooth devices"
                font.pointSize: Style.fontSizeLarge * scaling
                color: Color.mOnSurfaceVariant
                Layout.alignment: Qt.AlignHCenter
              }

              NText {
                text: "Click the refresh button to discover devices"
                font.pointSize: Style.fontSizeNormal * scaling
                color: Color.mOnSurfaceVariant
                Layout.alignment: Qt.AlignHCenter
              }
            }
          }
        }
      }
    }
  }
}

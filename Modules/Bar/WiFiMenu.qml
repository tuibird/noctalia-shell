import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import qs.Commons
import qs.Services
import qs.Widgets

// Loader for WiFi menu
NLoader {
  id: root

  content: Component {
    NPanel {
      id: wifiPanel

      property string passwordPromptSsid: ""
      property string passwordInput: ""
      property bool showPasswordPrompt: false

      function hide() {
        wifiMenuRect.scaleValue = 0.8
        wifiMenuRect.opacityValue = 0.0

        hideTimer.start()
      }

      // Connect to NPanel's dismissed signal to handle external close events
      Connections {
        target: wifiPanel
        ignoreUnknownSignals: true
        function onDismissed() {
          // Start hide animation
          wifiMenuRect.scaleValue = 0.8
          wifiMenuRect.opacityValue = 0.0

          // Hide after animation completes
          hideTimer.start()
        }
      }

      // Also handle visibility changes from external sources
      onVisibleChanged: {
        if (visible && Settings.data.network.wifiEnabled) {
          NetworkService.refreshNetworks()
        } else if (wifiMenuRect.opacityValue > 0) {
          // Start hide animation
          wifiMenuRect.scaleValue = 0.8
          wifiMenuRect.opacityValue = 0.0

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
          wifiPanel.visible = false
          wifiPanel.dismissed()
          NetworkService.onMenuClosed()
        }
      }

      WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

      // Timer to refresh networks when WiFi is enabled while menu is open
      Timer {
        id: wifiEnableRefreshTimer
        interval: 3000 // Wait 3 seconds for WiFi to be fully ready
        repeat: false
        onTriggered: {
          if (Settings.data.network.wifiEnabled && wifiPanel.visible) {
            NetworkService.refreshNetworks()
          }
        }
      }

      Rectangle {
        id: wifiMenuRect
        color: Colors.mSurface
        radius: Style.radiusLarge * scaling
        border.color: Colors.mOutlineVariant
        border.width: Math.max(1, Style.borderThin * scaling)
        width: 340 * scaling
        height: 320 * scaling
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
              text: "wifi"
              font.family: "Material Symbols Outlined"
              font.pointSize: Style.fontSizeXL * scaling
              color: Colors.mPrimary
            }

            NText {
              text: "WiFi"
              font.pointSize: Style.fontSizeLarge * scaling
              font.bold: true
              color: Colors.mOnSurface
              Layout.fillWidth: true
            }

            NToggle {
              baseSize: Style.baseWidgetSize * 0.75
              value: Settings.data.network.wifiEnabled
              onToggled: function (value) {
                Settings.data.network.wifiEnabled = value
                NetworkService.setWifiEnabled(value)

                // If enabling WiFi while menu is open, refresh after a delay
                if (value) {
                  wifiEnableRefreshTimer.start()
                }
              }
            }

            NIconButton {
              icon: "refresh"
              tooltipText: "Refresh Networks"
              sizeMultiplier: 0.8
              enabled: Settings.data.network.wifiEnabled && !network.isLoading
              onClicked: {
                NetworkService.refreshNetworks()
              }
            }

            NIconButton {
              icon: "close"
              tooltipText: "Close"
              sizeMultiplier: 0.8
              onClicked: {
                wifiPanel.hide()
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
              visible: Settings.data.network.wifiEnabled && NetworkService.isLoading
              spacing: Style.marginMedium * scaling

              NBusyIndicator {
                running: NetworkService.isLoading
                color: Colors.mPrimary
                size: Style.baseWidgetSize * scaling
                Layout.alignment: Qt.AlignHCenter
              }

              NText {
                text: "Scanning for networks..."
                font.pointSize: Style.fontSizeNormal * scaling
                color: Colors.mOnSurfaceVariant
                Layout.alignment: Qt.AlignHCenter
              }
            }

            // WiFi disabled message
            ColumnLayout {
              anchors.centerIn: parent
              visible: !Settings.data.network.wifiEnabled
              spacing: Style.marginMedium * scaling

              NText {
                text: "wifi_off"
                font.family: "Material Symbols Outlined"
                font.pointSize: Style.fontSizeXXL * scaling
                color: Colors.mOnSurfaceVariant
                Layout.alignment: Qt.AlignHCenter
              }

              NText {
                text: "WiFi is disabled"
                font.pointSize: Style.fontSizeLarge * scaling
                color: Colors.mOnSurfaceVariant
                Layout.alignment: Qt.AlignHCenter
              }

              NText {
                text: "Enable WiFi to see available networks"
                font.pointSize: Style.fontSizeNormal * scaling
                color: Colors.mOnSurfaceVariant
                Layout.alignment: Qt.AlignHCenter
              }
            }

            // Network list
            ListView {
              id: networkList
              anchors.fill: parent
              visible: Settings.data.network.wifiEnabled && !network.isLoading
              model: Object.values(network.networks)
              spacing: Style.marginMedium * scaling
              clip: true

              delegate: Item {
                width: parent.width
                height: modelData.ssid === passwordPromptSsid
                        && showPasswordPrompt ? 108 * scaling : Style.baseWidgetSize * 1.5 * scaling

                ColumnLayout {
                  anchors.fill: parent
                  spacing: 0

                  Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.baseWidgetSize * 1.5 * scaling
                    radius: Style.radiusMedium * scaling
                    color: modelData.connected ? Colors.mPrimary : (networkMouseArea.containsMouse ? Colors.mTertiary : "transparent")

                    RowLayout {
                      anchors.fill: parent
                      anchors.margins: Style.marginSmall * scaling
                      spacing: Style.marginSmall * scaling

                      NText {
                        text: NetworkService.signalIcon(modelData.signal)
                        font.family: "Material Symbols Outlined"
                        font.pointSize: Style.fontSizeXL * scaling
                        color: modelData.connected ? Colors.mSurface : (networkMouseArea.containsMouse ? Colors.mSurface : Colors.mOnSurface)
                      }

                      ColumnLayout {
                        Layout.fillWidth: true
                        spacing: Style.marginTiny * scaling

                        // SSID
                        NText {
                          text: modelData.ssid || "Unknown Network"
                          font.pointSize: Style.fontSizeNormal * scaling
                          elide: Text.ElideRight
                          Layout.fillWidth: true
                          color: modelData.connected ? Colors.mSurface : (networkMouseArea.containsMouse ? Colors.mSurface : Colors.mOnSurface)
                        }

                        // Security Protocol
                        NText {
                          text: modelData.security && modelData.security !== "--" ? modelData.security : "Open"
                          font.pointSize: Style.fontSizeTiny * scaling
                          elide: Text.ElideRight
                          Layout.fillWidth: true
                          color: modelData.connected ? Colors.mSurface : (networkMouseArea.containsMouse ? Colors.mSurface : Colors.mOnSurface)
                        }

                        NText {
                          visible: NetworkService.connectStatusSsid === modelData.ssid && NetworkService.connectStatus === "error"
                                   && network.connectError.length > 0
                          text: NetworkService.connectError
                          color: Colors.mError
                          font.pointSize: Style.fontSizeSmall * scaling
                          elide: Text.ElideRight
                          Layout.fillWidth: true
                        }
                      }

                      Item {
                        Layout.preferredWidth: Style.baseWidgetSize * 0.7 * scaling
                        Layout.preferredHeight: Style.baseWidgetSize * 0.7 * scaling
                        visible: NetworkService.connectStatusSsid === modelData.ssid
                                 && (network.connectStatus !== "" || NetworkService.connectingSsid === modelData.ssid)

                        NBusyIndicator {
                          visible: NetworkService.connectingSsid === modelData.ssid
                          running: NetworkService.connectingSsid === modelData.ssid
                          color: Colors.mPrimary
                          anchors.centerIn: parent
                          size: Style.baseWidgetSize * 0.7 * scaling
                        }

                        // TBC: Does nothing on my setup
                        NText {
                          visible: NetworkService.connectStatus === "success" && !NetworkService.connectingSsid
                          text: "check_circle"
                          font.family: "Material Symbols Outlined"
                          font.pointSize: Style.fontSizeXL * scaling
                          color: "#43a047" // TBC: No!
                          anchors.centerIn: parent
                        }

                        // TBC: Does nothing on my setup
                        NText {
                          visible: NetworkService.connectStatus === "error" && !NetworkService.connectingSsid
                          text: "error"
                          font.family: "Material Symbols Outlined"
                          font.pointSize: Style.fontSizeSmall * scaling
                          color: Colors.mError
                          anchors.centerIn: parent
                        }
                      }

                      NText {
                        visible: modelData.connected
                        text: "connected"
                        font.pointSize: Style.fontSizeSmall * scaling
                        color: modelData.connected ? Colors.mSurface : (networkMouseArea.containsMouse ? Colors.mSurface : Colors.mOnSurface)
                      }
                    }

                    MouseArea {
                      id: networkMouseArea
                      anchors.fill: parent
                      hoverEnabled: true
                      onClicked: {
                        if (modelData.connected) {
                          NetworkService.disconnectNetwork(modelData.ssid)
                        } else if (NetworkService.isSecured(modelData.security) && !modelData.existing) {
                          passwordPromptSsid = modelData.ssid
                          showPasswordPrompt = true
                          passwordInput = "" // Clear previous input
                          Qt.callLater(function () {
                            passwordInputField.forceActiveFocus()
                          })
                        } else {
                          NetworkService.connectNetwork(modelData.ssid, modelData.security)
                        }
                      }
                    }
                  }

                  // Password prompt section
                  Rectangle {
                    id: passwordPromptSection
                    Layout.fillWidth: true
                    Layout.preferredHeight: modelData.ssid === passwordPromptSsid && showPasswordPrompt ? 60 : 0
                    Layout.margins: Style.marginSmall * scaling
                    visible: modelData.ssid === passwordPromptSsid && showPasswordPrompt
                    color: Colors.mSurfaceVariant
                    radius: Style.radiusSmall * scaling

                    RowLayout {
                      anchors.fill: parent
                      anchors.margins: Style.marginSmall * scaling
                      spacing: Style.marginSmall * scaling

                      Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.barHeight * scaling

                        Rectangle {
                          anchors.fill: parent
                          radius: Style.radiusTiny * scaling
                          color: "transparent"
                          border.color: passwordInputField.activeFocus ? Colors.mPrimary : Colors.mOutline
                          border.width: Math.max(1, Style.borderThin * scaling)

                          TextInput {
                            id: passwordInputField
                            anchors.fill: parent
                            anchors.margins: Style.marginMedium * scaling
                            text: passwordInput
                            font.pointSize: Style.fontSizeMedium * scaling
                            color: Colors.mOnSurface
                            verticalAlignment: TextInput.AlignVCenter
                            clip: true
                            focus: true
                            selectByMouse: true
                            activeFocusOnTab: true
                            inputMethodHints: Qt.ImhNone
                            echoMode: TextInput.Password
                            onTextChanged: passwordInput = text
                            onAccepted: {
                              NetworkService.submitPassword(passwordPromptSsid, passwordInput)
                              showPasswordPrompt = false
                            }

                            MouseArea {
                              id: passwordInputMouseArea
                              anchors.fill: parent
                              onClicked: passwordInputField.forceActiveFocus()
                            }
                          }
                        }
                      }

                      Rectangle {
                        Layout.preferredWidth: Style.baseWidgetSize * 2.5 * scaling
                        Layout.preferredHeight: Style.barHeight * scaling
                        radius: Style.radiusMedium * scaling
                        color: Colors.mPrimary

                        Behavior on color {
                          ColorAnimation {
                            duration: Style.animationFast
                          }
                        }

                        NText {
                          anchors.centerIn: parent
                          text: "Connect"
                          color: Colors.mSurface
                          font.pointSize: Style.fontSizeSmall * scaling
                        }

                        MouseArea {
                          anchors.fill: parent
                          onClicked: {
                            NetworkService.submitPassword(passwordPromptSsid, passwordInput)
                            showPasswordPrompt = false
                          }
                          cursorShape: Qt.PointingHandCursor
                          hoverEnabled: true
                          onEntered: parent.color = Qt.darker(Colors.mPrimary, 1.1)
                          onExited: parent.color = Colors.mPrimary
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

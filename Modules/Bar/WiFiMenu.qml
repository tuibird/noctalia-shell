import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
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

      Connections {
        target: wifiPanel
        ignoreUnknownSignals: true
        function onDismissed() {
          wifiPanel.visible = false
          network.onMenuClosed()
        }
      }

      WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

      Rectangle {
        color: Colors.backgroundSecondary
        radius: Style.radiusMedium * scaling
        border.color: Colors.backgroundTertiary
        border.width: Math.max(1, Style.borderMedium * scaling)
        width: 340 * scaling
        height: 320 * scaling
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: Style.marginTiny * scaling
        anchors.rightMargin: Style.marginTiny * scaling

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
              color: Colors.accentPrimary
            }

            NText {
              text: "WiFi"
              font.pointSize: Style.fontSizeLarge * scaling
              font.bold: true
              color: Colors.textPrimary
              Layout.fillWidth: true
            }

            NToggle {
              baseSize: Style.baseWidgetSize * 0.75
              value: Settings.data.network.wifiEnabled
              onToggled: function (value) {
                Settings.data.network.wifiEnabled = value
                // TBC: This should be done in a service
                Quickshell.execDetached(["nmcli", "radio", "wifi", Settings.data.network.wifiEnabled ? "on" : "off"])
              }
            }

            NIconButton {
              icon: "refresh"
              sizeMultiplier: 0.8
              onClicked: {
                network.refreshNetworks()
              }
            }

            NIconButton {
              icon: "close"
              sizeMultiplier: 0.8
              onClicked: {
                wifiPanel.visible = false
                network.onMenuClosed()
              }
            }
          }

          NDivider {}

          ListView {
            id: networkList
            Layout.fillWidth: true
            Layout.fillHeight: true
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
                  color: modelData.connected ? Colors.accentPrimary : (networkMouseArea.containsMouse ? Colors.hover : "transparent")

                  RowLayout {
                    anchors.fill: parent
                    anchors.margins: Style.marginSmall * scaling
                    spacing: Style.marginSmall * scaling

                    NText {
                      text: network.signalIcon(modelData.signal)
                      font.family: "Material Symbols Outlined"
                      font.pointSize: Style.fontSizeXL * scaling
                      color: modelData.connected ? Colors.backgroundPrimary : (networkMouseArea.containsMouse ? Colors.backgroundPrimary : Colors.textPrimary)
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
                        color: modelData.connected ? Colors.backgroundPrimary : (networkMouseArea.containsMouse ? Colors.backgroundPrimary : Colors.textPrimary)
                      }

                      // Security Protocol
                      NText {
                        text: modelData.security && modelData.security !== "--" ? modelData.security : "Open"
                        font.pointSize: Style.fontSizeTiny * scaling
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                        color: modelData.connected ? Colors.backgroundPrimary : (networkMouseArea.containsMouse ? Colors.backgroundPrimary : Colors.textPrimary)
                      }

                      NText {
                        visible: network.connectStatusSsid === modelData.ssid && network.connectStatus === "error"
                                 && network.connectError.length > 0
                        text: network.connectError
                        color: Colors.error
                        font.pointSize: Style.fontSizeSmall * scaling
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                      }
                    }

                    Item {
                      Layout.preferredWidth: 22
                      Layout.preferredHeight: 22
                      visible: network.connectStatusSsid === modelData.ssid
                               && (network.connectStatus !== "" || network.connectingSsid === modelData.ssid)

                      NBusyIndicator {
                        visible: network.connectingSsid === modelData.ssid
                        running: network.connectingSsid === modelData.ssid
                        color: Colors.accentPrimary
                        anchors.centerIn: parent
                        size: Style.baseWidgetSize * 0.7 * scaling
                      }

                      // TBC: Does nothing on my setup
                      NText {
                        visible: network.connectStatus === "success" && !network.connectingSsid
                        text: "check_circle"
                        font.family: "Material Symbols Outlined"
                        font.pointSize: 18 * scaling
                        color: "#43a047" // TBC: No!
                        anchors.centerIn: parent
                      }

                      // TBC: Does nothing on my setup
                      NText {
                        visible: network.connectStatus === "error" && !network.connectingSsid
                        text: "error"
                        font.family: "Material Symbols Outlined"
                        font.pointSize: Style.fontSizeSmall * scaling
                        color: Colors.error
                        anchors.centerIn: parent
                      }
                    }

                    NText {
                      visible: modelData.connected
                      text: "connected"
                      font.pointSize: Style.fontSizeSmall * scaling
                      color: modelData.connected ? Colors.backgroundPrimary : (networkMouseArea.containsMouse ? Colors.backgroundPrimary : Colors.textPrimary)
                    }
                  }

                  MouseArea {
                    id: networkMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                      if (modelData.connected) {
                        network.disconnectNetwork(modelData.ssid)
                      } else if (network.isSecured(modelData.security) && !modelData.existing) {
                        passwordPromptSsid = modelData.ssid
                        showPasswordPrompt = true
                        passwordInput = "" // Clear previous input
                        Qt.callLater(function () {
                          passwordInputField.forceActiveFocus()
                        })
                      } else {
                        network.connectNetwork(modelData.ssid, modelData.security)
                      }
                    }
                  }
                }

                // Password prompt section
                Rectangle {
                  id: passwordPromptSection
                  Layout.fillWidth: true
                  Layout.preferredHeight: modelData.ssid === passwordPromptSsid && showPasswordPrompt ? 60 : 0
                  Layout.margins: 8
                  visible: modelData.ssid === passwordPromptSsid && showPasswordPrompt
                  color: Colors.surfaceVariant
                  radius: Style.radiusSmall * scaling

                  RowLayout {
                    anchors.fill: parent
                    anchors.margins: Style.marginSmall * scaling
                    spacing: Style.marginSmall * scaling

                    Item {
                      Layout.fillWidth: true
                      Layout.preferredHeight: 36

                      Rectangle {
                        anchors.fill: parent
                        radius: 8
                        color: "transparent"
                        border.color: passwordInputField.activeFocus ? Colors.accentPrimary : Colors.outline
                        border.width: 1

                        TextInput {
                          id: passwordInputField
                          anchors.fill: parent
                          anchors.margins: Style.marginMedium * scaling
                          text: passwordInput
                          font.pointSize: Style.fontSizeMedium * scaling
                          color: Colors.textPrimary
                          verticalAlignment: TextInput.AlignVCenter
                          clip: true
                          focus: true
                          selectByMouse: true
                          activeFocusOnTab: true
                          inputMethodHints: Qt.ImhNone
                          echoMode: TextInput.Password
                          onTextChanged: passwordInput = text
                          onAccepted: {
                            network.submitPassword(passwordPromptSsid, passwordInput)
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
                      Layout.preferredWidth: 80
                      Layout.preferredHeight: 36
                      radius: Style.radiusMedium * scaling
                      color: Colors.accentPrimary
                      border.color: Colors.accentPrimary
                      border.width: 0

                      Behavior on color {
                        ColorAnimation {
                          duration: Style.animationFast
                        }
                      }

                      NText {
                        anchors.centerIn: parent
                        text: "Connect"
                        color: Colors.backgroundPrimary
                        font.pointSize: Style.fontSizeSmall * scaling
                      }

                      MouseArea {
                        anchors.fill: parent
                        onClicked: {
                          network.submitPassword(passwordPromptSsid, passwordInput)
                          showPasswordPrompt = false
                        }
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onEntered: parent.color = Qt.darker(Colors.accentPrimary, 1.1)
                        onExited: parent.color = Colors.accentPrimary
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

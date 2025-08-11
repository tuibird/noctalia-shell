import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import qs.Services
import qs.Widgets

Item {
  id: root

  readonly property real scaling: Scaling.scale(screen)
  readonly property bool wifiEnabled: Settings.data.network.wifiEnabled

  property bool menuVisible: false
  property string passwordPromptSsid: ""
  property string passwordInput: ""
  property bool showPasswordPrompt: false


  width: wifiEnabled ? 22 : 0
  height: wifiEnabled ? 22 : 0


  Network {
    id: network
  }

  // WiFi icon/button
  Item {
    id: wifiIcon
    width: 22
    height: 22
    visible: wifiEnabled

    property int currentSignal: {
      let maxSignal = 0
      for (const net in network.networks) {
        if (network.networks[net].connected && network.networks[net].signal > maxSignal) {
          maxSignal = network.networks[net].signal
        }
      }
      return maxSignal
    }

    NIconButton {
      id: wifiText
      anchors.centerIn: parent
      icon: {
        let connected = false
        for (const net in network.networks) {
          if (network.networks[net].connected) {
            connected = true
            break
          }
        }
        return connected ? network.signalIcon(parent.currentSignal) : "wifi_off"
      }
      fontFamily: mouseAreaWifi.containsMouse ? "Material Symbols Rounded" : "Material Symbols Outlined"
      tooltipText: "WiFi Networks"
      onClicked: function () {
        if (!wifiMenuLoader.active) {
          wifiMenuLoader.loading = true
        }
        if (wifiMenuLoader.item) {
          wifiMenuLoader.item.visible = !wifiMenuLoader.item.visible
          if (wifiMenuLoader.item.visible) {
            network.onMenuOpened()
          } else {
            network.onMenuClosed()
          }
        }
      }
    }

    // MouseArea {
    //   id: mouseAreaWifi
    //   anchors.fill: parent
    //   hoverEnabled: true
    //   cursorShape: Qt.PointingHandCursor
    //   onClicked: {
    //     wifiTooltip.hide()
    //     if (!wifiMenuLoader.active) {
    //       wifiMenuLoader.loading = true
    //     }
    //     if (wifiMenuLoader.item) {
    //       wifiMenuLoader.item.visible = !wifiMenuLoader.item.visible
    //       if (wifiMenuLoader.item.visible) {
    //         network.onMenuOpened()
    //       } else {
    //         network.onMenuClosed()
    //       }
    //     }
    //   }
    //   onEntered: wifiTooltip.show()
    //   onExited: wifiTooltip.hide()
    // }
  }

  // NTooltip {
  //   id: wifiTooltip
  //   target: wifiIcon
    
  //   positionAbove: false
  // }

  // LazyLoader for WiFi menu
  LazyLoader {
    id: wifiMenuLoader
    loading: false
    component: NPanel {
      id: wifiMenu
      
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
          anchors.margins: 16
          spacing: 16

          RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Text {
              text: "wifi"
              font.family: "Material Symbols Outlined"
              font.pointSize: 24 * scaling
              color: Colors.accentPrimary
            }

            Text {
              text: "WiFi Networks"
              font.pointSize: 18 * scaling
              font.bold: true
              color: Colors.textPrimary
              Layout.fillWidth: true
            }

            NIconButton {
              icon: "refresh"
              onClicked: function () {network.refreshNetworks() }
            }

            NIconButton {
              icon: "close"
              onClicked: function () {
                wifiMenu.visible = false
                network.onMenuClosed()
              }
            }
          }

          Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Colors.outline
            opacity: 0.12
          }

          ListView {
            id: networkList
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: Object.values(network.networks)
            spacing: 8
            clip: true

            delegate: Item {
              width: parent.width
              height: modelData.ssid === passwordPromptSsid
                      && showPasswordPrompt ? 108 : 48 // 48 for network + 60 for password prompt

              ColumnLayout {
                anchors.fill: parent
                spacing: 0

                Rectangle {
                  Layout.fillWidth: true
                  Layout.preferredHeight: 48
                  radius: 8
                  color: modelData.connected ? Qt.rgba(
                                                 Colors.accentPrimary.r, Colors.accentPrimary.g, Colors.accentPrimary.b,
                                                 0.44) : (networkMouseArea.containsMouse ? Colors.highlight : "transparent")

                  RowLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 8

                    Text {
                      text: network.signalIcon(modelData.signal)
                      font.family: "Material Symbols Outlined"
                      font.pointSize: 18 * scaling
                      color: networkMouseArea.containsMouse ? Colors.backgroundPrimary : (modelData.connected ? Colors.accentPrimary : Colors.textSecondary)
                    }

                    ColumnLayout {
                      Layout.fillWidth: true
                      spacing: 2

                      Text {
                        text: modelData.ssid || "Unknown Network"
                        color: networkMouseArea.containsMouse ? Colors.backgroundPrimary : (modelData.connected ? Colors.accentPrimary : Colors.textPrimary)
                        font.pointSize: 14 * scaling
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                      }

                      Text {
                        text: modelData.security && modelData.security !== "--" ? modelData.security : "Open"
                        color: networkMouseArea.containsMouse ? Colors.backgroundPrimary : (modelData.connected ? Colors.accentPrimary : Colors.textSecondary)
                        font.pointSize: 11 * scaling
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                      }

                      Text {
                        visible: network.connectStatusSsid === modelData.ssid && network.connectStatus === "error"
                                 && network.connectError.length > 0
                        text: network.connectError
                        color: Colors.error
                        font.pointSize: 11 * scaling
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                      }
                    }

                    Item {
                      Layout.preferredWidth: 22
                      Layout.preferredHeight: 22
                      visible: network.connectStatusSsid === modelData.ssid
                               && (network.connectStatus !== "" || network.connectingSsid === modelData.ssid)

                      // TBC
                      // Spinner {
                      //   visible: network.connectingSsid === modelData.ssid
                      //   running: network.connectingSsid === modelData.ssid
                      //   color: Colors.accentPrimary
                      //   anchors.centerIn: parent
                      //   size: 22
                      // }

                      Text {
                        visible: network.connectStatus === "success" && !network.connectingSsid
                        text: "check_circle"
                        font.family: "Material Symbols Outlined"
                        font.pointSize: 18 * scaling
                        color: "#43a047"  // TBC: No!
                        anchors.centerIn: parent
                      }

                      Text {
                        visible: network.connectStatus === "error" && !network.connectingSsid
                        text: "error"
                        font.family: "Material Symbols Outlined"
                        font.pointSize: 18 * scaling
                        color: Colors.error
                        anchors.centerIn: parent
                      }
                    }

                    Text {
                      visible: modelData.connected
                      text: "connected"
                      color: networkMouseArea.containsMouse ? Colors.backgroundPrimary : Colors.accentPrimary
                      font.pointSize: 11 * scaling
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
                  radius: 8

                  RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 10

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
                          anchors.margins: 12
                          text: passwordInput
                          font.pointSize: 13 * scaling
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
                      radius: 18
                      color: Colors.accentPrimary
                      border.color: Colors.accentPrimary
                      border.width: 0
                      opacity: 1.0

                      Behavior on color {
                        ColorAnimation {
                          duration: 100
                        }
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

                      Text {
                        anchors.centerIn: parent
                        text: "Connect"
                        color: Colors.backgroundPrimary
                        font.pointSize: 14 * scaling
                        font.bold: true
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

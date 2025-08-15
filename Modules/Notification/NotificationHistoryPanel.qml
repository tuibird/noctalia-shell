import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import qs.Services
import qs.Widgets

// Loader for Notification History panel
NLoader {
  id: root

  content: Component {
    NPanel {
      id: notificationPanel

      // Override hide function to animate first
      function hide() {
        // Start hide animation
        notificationRect.scaleValue = 0.8
        notificationRect.opacityValue = 0.0

        // Hide after animation completes
        hideTimer.start()
      }

      Connections {
        target: notificationPanel
        ignoreUnknownSignals: true
        function onDismissed() {
          // Start hide animation
          notificationRect.scaleValue = 0.8
          notificationRect.opacityValue = 0.0

          // Hide after animation completes
          hideTimer.start()
        }
      }

      // Also handle visibility changes from external sources
      onVisibleChanged: {
        if (!visible && notificationRect.opacityValue > 0) {
          // Start hide animation
          notificationRect.scaleValue = 0.8
          notificationRect.opacityValue = 0.0

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
          notificationPanel.visible = false
          notificationPanel.dismissed()
        }
      }

      WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

              Rectangle {
          id: notificationRect
          color: Colors.mSurface
          radius: Style.radiusLarge * scaling
          border.color: Colors.mOutlineVariant
          border.width: Math.max(1, Style.borderThin * scaling)
          width: 400 * scaling
          height: 500 * scaling
          anchors.top: parent.top
          anchors.right: parent.right
          anchors.topMargin: Style.marginTiny * scaling
          anchors.rightMargin: Style.marginTiny * scaling
          clip: true

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
              text: "notifications"
              font.family: "Material Symbols Outlined"
              font.pointSize: Style.fontSizeXL * scaling
              color: Colors.mPrimary
            }

            NText {
              text: "Notification History"
              font.pointSize: Style.fontSizeLarge * scaling
              font.bold: true
              color: Colors.mOnSurface
              Layout.fillWidth: true
            }

            NIconButton {
              icon: "delete"
              sizeMultiplier: 0.8
              tooltipText: "Clear history"
              onClicked: NotificationService.clearHistory()
            }

            NIconButton {
              icon: "close"
              sizeMultiplier: 0.8
              onClicked: {
                notificationPanel.hide()
              }
            }
          }

          NDivider {}

          ListView {
            id: notificationList
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: NotificationService.historyModel
            spacing: Style.marginMedium * scaling
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            delegate: Rectangle {
              width: notificationList ? (notificationList.width - 20) : 380 * scaling
              height: Math.max(80, notificationContent.height + 30)
              radius: Style.radiusMedium * scaling
              color: notificationMouseArea.containsMouse ? Colors.mPrimary : Colors.mSurface

              RowLayout {
                anchors {
                  fill: parent
                  margins: Style.marginMedium * scaling
                }
                spacing: Style.marginMedium * scaling

                // Notification content
                Column {
                  id: notificationContent
                  Layout.fillWidth: true
                  Layout.alignment: Qt.AlignVCenter
                  spacing: Style.marginTiniest * scaling

                  NText {
                    text: (summary || "No summary").substring(0, 100)
                    font.pointSize: Style.fontSizeMedium * scaling
                    font.weight: Font.Medium
                    color: notificationMouseArea.containsMouse ? Colors.mSurface : Colors.mOnSurface
                    wrapMode: Text.Wrap
                    width: parent.width - 60
                    maximumLineCount: 2
                    elide: Text.ElideRight
                  }

                  NText {
                    text: (body || "").substring(0, 150)
                    font.pointSize: Style.fontSizeSmall * scaling
                    color: notificationMouseArea.containsMouse ? Colors.mSurface : Colors.mOnSurface
                    wrapMode: Text.Wrap
                    width: parent.width - 60
                    maximumLineCount: 3
                    elide: Text.ElideRight
                  }

                  NText {
                    text: NotificationService.formatTimestamp(timestamp)
                    font.pointSize: Style.fontSizeSmall * scaling
                    color: notificationMouseArea.containsMouse ? Colors.mSurface : Colors.mOnSurface
                  }
                }

                // Trash icon button
                NIconButton {
                  icon: "delete"
                  sizeMultiplier: 0.7
                  tooltipText: "Delete notification"
                  onClicked: {
                    console.log("[NotificationHistory] Removing notification:", summary)
                    NotificationService.historyModel.remove(index)
                    NotificationService.saveHistory()
                  }
                }
              }

              MouseArea {
                id: notificationMouseArea
                anchors.fill: parent
                anchors.rightMargin: Style.marginLarge * 3 * scaling
                hoverEnabled: true
                // Remove the onClicked handler since we now have a dedicated delete button
              }
            }

            ScrollBar.vertical: ScrollBar {
              active: true
              anchors.right: parent.right
              anchors.top: parent.top
              anchors.bottom: parent.bottom
            }
          }
        }
      }
    }
  }
}

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Services.Notifications
import qs.Services
import qs.Widgets

// Simple notification popup - displays multiple notifications
PanelWindow {
  id: root

  readonly property real scaling: Scaling.scale(screen)

  color: "transparent"
  visible: notificationService.notificationModel.count > 0
  anchors.top: true
  anchors.right: true
  margins.top: (Style.barHeight + Style.marginMedium) * scaling
  margins.right: Style.marginMedium * scaling
  implicitWidth: 360 * scaling
  implicitHeight: Math.min(notificationStack.implicitHeight, (notificationService.maxVisible * 120) * scaling)
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.exclusionMode: ExclusionMode.Ignore

  // Use the notification service
  property var notificationService: NotificationService {}

  // Access the notification model from the service
  property ListModel notificationModel: notificationService.notificationModel

  // Track notifications being removed for animation
  property var removingNotifications: ({})

  // Connect to animation signal from service
  Component.onCompleted: {
    notificationService.animateAndRemove.connect(function (notification, index) {
      // Find the delegate and trigger its animation
      if (notificationStack.children && notificationStack.children[index]) {
        let delegate = notificationStack.children[index]
        if (delegate && delegate.animateOut) {
          delegate.animateOut()
        }
      }
    })
  }

  // Main notification container
  Column {
    id: notificationStack
    anchors.top: parent.top
    anchors.right: parent.right
    spacing: 8 * scaling
    width: 360 * scaling
    visible: true

    // Multiple notifications display
    Repeater {
      model: notificationModel
      delegate: Rectangle {
        width: 360 * scaling
        height: Math.max(80 * scaling, contentColumn.implicitHeight + (Style.marginMedium * 2 * scaling))
        clip: true
        radius: Style.radiusMedium * scaling
        border.color: Colors.accentPrimary
        border.width: Math.max(1, Style.borderThin * scaling)
        gradient: Gradient {
        GradientStop { position: 0.0; color: Colors.backgroundTertiary }
        GradientStop { position: 1.0; color: Colors.backgroundSecondary }
    }

        // Animation properties
        property real scaleValue: 0.8
        property real opacityValue: 0.0
        property bool isRemoving: false

        // Scale and fade-in animation
        scale: scaleValue
        opacity: opacityValue

        // Animate in when the item is created
        Component.onCompleted: {
          scaleValue = 1.0
          opacityValue = 1.0
        }

        // Animate out when being removed
        function animateOut() {
          isRemoving = true
          scaleValue = 0.8
          opacityValue = 0.0
        }

        // Timer for delayed removal after animation
        Timer {
          id: removalTimer
          interval: Style.animationSlow
          repeat: false
          onTriggered: {
            notificationService.forceRemoveNotification(model.rawNotification)
          }
        }

        // Check if this notification is being removed
        onIsRemovingChanged: {
          if (isRemoving) {
            // Remove from model after animation completes
            removalTimer.start()
          }
        }

        // Animation behaviors
        Behavior on scale {
          NumberAnimation {
            duration: Style.animationSlow
            easing.type: Easing.OutBack
          }
        }

        Behavior on opacity {
          NumberAnimation {
            duration: Style.animationNormal
            easing.type: Easing.OutQuad
          }
        }

        Column {
          id: contentColumn
          anchors.fill: parent
          anchors.margins: Style.marginMedium * scaling
          spacing: Style.marginSmall * scaling

          RowLayout {
            spacing: Style.marginSmall * scaling
            NText {
              text: (model.appName || model.desktopEntry) || "Unknown App"
              color: Colors.accentSecondary
              font.pointSize: Style.fontSizeSmall
            }
            Rectangle {
              width: 6 * scaling
              height: 6 * scaling
              radius: 3 * scaling
              color: (model.urgency === NotificationUrgency.Critical) ? Colors.error : (model.urgency === NotificationUrgency.Low) ? Colors.textSecondary : Colors.accentPrimary
              Layout.alignment: Qt.AlignVCenter
            }
            Item {
              Layout.fillWidth: true
            }
            NText {
              text: notificationService.formatTimestamp(model.timestamp)
              color: Colors.textSecondary
              font.pointSize: Style.fontSizeSmall
            }
          }

          NText {
            text: model.summary || "No summary"
            font.pointSize: Style.fontSizeLarge
            font.weight: Style.fontWeightBold
            color: Colors.textPrimary
            wrapMode: Text.Wrap
            width: 300 * scaling
            maximumLineCount: 3
            elide: Text.ElideRight
          }

          NText {
            text: model.body || ""
            font.pointSize: Style.fontSizeSmall
            color: Colors.textSecondary
            wrapMode: Text.Wrap
            width: 300 * scaling
            maximumLineCount: 5
            elide: Text.ElideRight
          }
        }

        NIconButton {
          anchors.top: parent.top
          anchors.right: parent.right
          anchors.margins: Style.marginSmall * scaling
          icon: "close"
          onClicked: function () {
            animateOut()
          }
        }
      }
    }
  }
}

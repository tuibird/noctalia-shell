import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Services
import qs.Widgets

Row {
  id: layout
  anchors.verticalCenter: parent.verticalCenter
  spacing: Style.marginSmall * scaling
  visible: Settings.data.bar.showActiveWindow

  property bool showingFullTitle: false
  property int lastWindowIndex: -1

  // Timer to hide full title after window switch
  Timer {
    id: fullTitleTimer
    interval: Style.animationSlow * 4 // Show full title for 2 seconds
    repeat: false
    onTriggered: {
      showingFullTitle = false
      // No need to update text here, the width property change will handle it
    }
  }

  // Update text when window changes
  Connections {
    target: typeof NiriService !== "undefined" ? NiriService : null
    function onFocusedWindowIndexChanged() {
      // Check if window actually changed
      if (NiriService.focusedWindowIndex !== lastWindowIndex) {
        lastWindowIndex = NiriService.focusedWindowIndex
        showingFullTitle = true
        fullTitleTimer.restart()
      }
    }
  }

  function getFocusedWindow() {
    if (typeof NiriService === "undefined" || NiriService.focusedWindowIndex < 0
        || NiriService.focusedWindowIndex >= NiriService.windows.length) {
      return null
    }
    return NiriService.windows[NiriService.focusedWindowIndex]
  }

  function getTitle() {
    const focusedWindow = getFocusedWindow()
    return focusedWindow ? (focusedWindow.title || focusedWindow.appId || "") : ""
  }

  //  A hidden text element to safely measure the full title width
  NText {
    id: fullTitleMetrics
    visible: false
    text: getTitle()
    font: titleText.font
  }

  Rectangle {
    // Let the Rectangle size itself based on its content (the Row)
    width: row.width + Style.marginMedium* scaling * 2
    height: row.height + Style.marginSmall * scaling
    color: Color.mSurfaceVariant
    radius: Style.radiusSmall * scaling
    anchors.verticalCenter: parent.verticalCenter

    Item {
      id: mainContainer
      anchors.fill: parent
      anchors.leftMargin: Style.marginSmall * scaling
      anchors.rightMargin: Style.marginSmall * scaling

      Row {
        id: row
        anchors.verticalCenter: parent.verticalCenter
        spacing: Style.marginTiny * scaling

        // Window icon
        NText {
          id: windowIcon
          text: "dialogs"
          font.family: "Material Symbols Outlined"
          font.pointSize: Style.fontSizeLarge * scaling
          verticalAlignment: Text.AlignVCenter
          anchors.verticalCenter: parent.verticalCenter
          visible: getTitle() !== ""
        }

        NText {
          id: titleText
          width: (showingFullTitle || mouseArea.containsMouse) ? fullTitleMetrics.contentWidth : 150 * scaling
          text: getTitle()
          font.pointSize: Style.fontSizeReduced * scaling
          font.weight: Style.fontWeightBold
          elide: Text.ElideRight
          anchors.verticalCenter: parent.verticalCenter
          verticalAlignment: Text.AlignVCenter
          color: Color.mTertiary

          Behavior on width {
            NumberAnimation {
              duration: Style.animationSlow
              easing.type: Easing.OutBack
            }
          }
        }
      }

      // Mouse area for hover detection
      MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
      }
    }
  }
}

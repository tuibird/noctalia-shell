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
      titleText.text = getDisplayText()
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
      titleText.text = getDisplayText()
    }
  }

  Rectangle {
    width: row.width + Style.marginSmall * scaling * 2
    height: row.height
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
          visible: getDisplayText() !== ""
        }

        NText {
          id: titleText
          width: (showingFullTitle || mouseArea.containsMouse) ? 300 * scaling : 100 * scaling
          text: getDisplayText()
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
        cursorShape: Qt.IBeamCursor
        onEntered: {
          titleText.text = getDisplayText()
        }
        onExited: {
          titleText.text = getDisplayText()
        }
      }
    }
  }
  function getDisplayText() {
    // Check if Niri service is available
    if (typeof NiriService === "undefined") {
      return ""
    }

    // Get the focused window data
    const focusedWindow = NiriService.focusedWindowIndex >= 0 && NiriService.focusedWindowIndex
                        < NiriService.windows.length ? NiriService.windows[NiriService.focusedWindowIndex] : null

    if (!focusedWindow) {
      return ""
    }

    const appId = focusedWindow.appId || ""
    const title = focusedWindow.title || ""

    // If no appId, fall back to title processing
    if (!appId) {
      if (!title || title === "(No active window)" || title === "(Unnamed window)") {
        return ""
      }

      // Extract program name from title (before first space or special characters)
      const programName = title.split(/[\s\-_]/)[0]

      if (programName.length <= 2 || programName === title) {
        return title
      }

      if (isGenericName(programName)) {
        return title
      }

      return programName
    }

    return title

    // // Use appId for program name, show full title on hover or window switch
    // if (showingFullTitle || mouseArea.containsMouse) {
    //   return truncateTitle(title || appId, 50)
    // } else {
    //   return truncateTitle(title || appId, 20)
    // }
  }

  function truncateTitle(title, length) {
    if (title.length > length) {
      return title.substring(0, length - 3) + "..."
    }
    return title
  }

  function isGenericName(name) {
    const genericNames = ["window", "application", "app", "program", "process", "unknown"]
    return genericNames.includes(name.toLowerCase())
  }
}

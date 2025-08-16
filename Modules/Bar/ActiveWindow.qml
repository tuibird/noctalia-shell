import QtQuick
import QtQuick.Controls
import Quickshell
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
    target: typeof Niri !== "undefined" ? Niri : null
    function onFocusedWindowIndexChanged() {
      // Check if window actually changed
      if (Niri.focusedWindowIndex !== lastWindowIndex) {
        lastWindowIndex = Niri.focusedWindowIndex
        showingFullTitle = true
        fullTitleTimer.restart()
      }
      titleText.text = getDisplayText()
    }
  }

  // Window icon
  NText {
    id: windowIcon
    text: "desktop_windows"
    font.family: "Material Symbols Outlined"
    font.pointSize: Style.fontSizeLarge * scaling
    verticalAlignment: Text.AlignVCenter
    anchors.verticalCenter: parent.verticalCenter
    color: Colors.mPrimary
    visible: getDisplayText() !== ""
  }

  // Window title container
  Item {
    id: titleContainer
    width: titleText.width
    height: titleText.height
    anchors.verticalCenter: parent.verticalCenter

    Behavior on width {
      NumberAnimation {
        duration: Style.animationNormal
        easing.type: Easing.OutCubic
      }
    }

    NText {
      id: titleText
      text: getDisplayText()
      font.pointSize: Style.fontSizeSmall * scaling
      font.weight: Style.fontWeightBold
      anchors.verticalCenter: parent.verticalCenter
      verticalAlignment: Text.AlignVCenter
      elide: Text.ElideRight
    }

    // Mouse area for hover detection
    MouseArea {
      id: titleContainerMouseArea
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

  function getDisplayText() {
    // Check if Niri service is available
    if (typeof Niri === "undefined") {
      return ""
    }

    // Get the focused window data
    const focusedWindow = Niri.focusedWindowIndex >= 0
                        && Niri.focusedWindowIndex < Niri.windows.length ? Niri.windows[Niri.focusedWindowIndex] : null

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
        return truncateTitle(title)
      }

      if (showingFullTitle || titleContainerMouseArea.containsMouse || isGenericName(programName)) {
        return truncateTitle(title)
      }

      return programName
    }

    // Use appId for program name, show full title on hover or window switch
    if (showingFullTitle || titleContainerMouseArea.containsMouse) {
      return truncateTitle(title || appId)
    }

    return appId
  }

  function truncateTitle(title) {
    if (title.length > 50) {
      return title.substring(0, 47) + "..."
    }
    return title
  }

  function isGenericName(name) {
    const genericNames = ["window", "application", "app", "program", "process", "unknown"]
    return genericNames.includes(name.toLowerCase())
  }
}

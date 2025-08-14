import QtQuick
import Quickshell.Io
import qs.Modules.Lockscreen

Item {
  id: root
  
  // Reference to the lockscreen component
  property var lockscreen: null

  IpcHandler {
    target: "settings"

    function toggle() {
      settingsPanel.isLoaded = !settingsPanel.isLoaded
    }
  }

  IpcHandler {
    target: "notifications"

    function toggleHistory() {
      notificationHistoryPanel.isLoaded = !notificationHistoryPanel.isLoaded
    }

    function toggleDoNotDisturb() {// TODO
    }
  }

  IpcHandler {
    target: "idleInhibitor"

    function toggle() {// TODO
    }
  }

  IpcHandler {
    target: "appLauncher"

    function toggle() {// TODO
    }
  }

  IpcHandler {
    target: "lockScreen"

    function toggle() {
      lockScreen.locked = !lockScreen.locked
    }
  }

  // Lockscreen instance
  Lockscreen {
    id: lockScreen
  }
}

import QtQuick
import Quickshell.Io

Item {
  id: root

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

    function toggle() {// TODO
    }
  }
}

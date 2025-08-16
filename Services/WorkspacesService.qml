pragma Singleton

pragma ComponentBehavior

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import qs.Commons
import qs.Services

Singleton {
  id: root

  property ListModel workspaces: ListModel {}
  property bool isHyprland: false
  property bool isNiri: false
  property var hlWorkspaces: Hyprland.workspaces.values
  // Detect which compositor we're using
  Component.onCompleted: {
    detectCompositor()
  }

  function detectCompositor() {
    try {
      try {
        if (Hyprland.eventSocketPath) {
          isHyprland = true
          isNiri = false
          initHyprland()
          return
        }
      } catch (e) {

      }

      if (typeof NiriService !== "undefined") {
        isHyprland = false
        isNiri = true
        initNiri()
        return
      }
    } catch (e) {
      Logger.error("WorkspacesService", "Error detecting compositor:", e)
    }
  }

  // Initialize Hyprland integration
  function initHyprland() {
    try {
      // Fixes the odd workspace issue.
      Hyprland.refreshWorkspaces()
      // hlWorkspaces = Hyprland.workspaces.values;
      // updateHyprlandWorkspaces();
      return true
    } catch (e) {
      Logger.error("WorkspacesService", "Error initializing Hyprland:", e)
      isHyprland = false
      return false
    }
  }

  onHlWorkspacesChanged: {
    updateHyprlandWorkspaces()
  }

  Connections {
    target: Hyprland.workspaces
    function onValuesChanged() {
      updateHyprlandWorkspaces()
    }
  }

  Connections {
    target: Hyprland
    function onRawEvent(event) {
      updateHyprlandWorkspaces()
    }
  }

  function updateHyprlandWorkspaces() {
    workspaces.clear()
    try {
      for (var i = 0; i < hlWorkspaces.length; i++) {
        const ws = hlWorkspaces[i]
        // Only append workspaces with id >= 1
        if (ws.id >= 1) {
          workspaces.append({
                              "id": i,
                              "idx": ws.id,
                              "name": ws.name || "",
                              "output": ws.monitor?.name || "",
                              "isActive": ws.active === true,
                              "isFocused": ws.focused === true,
                              "isUrgent": ws.urgent === true
                            })
        }
      }
      workspacesChanged()
    } catch (e) {
      Logger.error("WorkspacesService", "Error updating Hyprland workspaces:", e)
    }
  }

  function initNiri() {
    updateNiriWorkspaces()
  }

  Connections {
    target: NiriService
    function onWorkspacesChanged() {
      updateNiriWorkspaces()
    }
  }

  function updateNiriWorkspaces() {
    const niriWorkspaces = NiriService.workspaces || []
    workspaces.clear()
    for (var i = 0; i < niriWorkspaces.length; i++) {
      const ws = niriWorkspaces[i]
      workspaces.append({
                          "id": ws.id,
                          "idx": ws.idx || 1,
                          "name": ws.name || "",
                          "output": ws.output || "",
                          "isFocused": ws.isFocused === true,
                          "isActive": ws.isActive === true,
                          "isUrgent": ws.isUrgent === true,
                          "isOccupied": ws.isOccupied === true
                        })
    }

    workspacesChanged()
  }

  function switchToWorkspace(workspaceId) {
    if (isHyprland) {
      try {
        Hyprland.dispatch(`workspace ${workspaceId}`)
      } catch (e) {
        Logger.error("WorkspacesService", "Error switching Hyprland workspace:", e)
      }
    } else if (isNiri) {
      try {
        Quickshell.execDetached(["niri", "msg", "action", "focus-workspace", workspaceId.toString()])
      } catch (e) {
        Logger.error("WorkspacesService", "Error switching Niri workspace:", e)
      }
    } else {
      Logger.warn("WorkspacesService", "No supported compositor detected for workspace switching")
    }
  }
}

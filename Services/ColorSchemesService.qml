pragma Singleton

import QtQuick
import Qt.labs.folderlistmodel
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  Component.onCompleted: {
    console.log("[ColorSchemes] Service started")
    loadColorSchemes()
  }

  property var schemes: []
  property bool scanning: false
  property string schemesDirectory: Quickshell.shellDir + "/Assets/ColorSchemes"
  property string colorsJsonFilePath: Settings.configDir + "colors.json"

  function loadColorSchemes() {
    console.log("[ColorSchemes] Load ColorSchemes")
    scanning = true
    schemes = []
    // Unsetting, then setting the folder will re-trigger the parsing!
    folderModel.folder = ""
    folderModel.folder = "file://" + schemesDirectory
  }

  function applyScheme(filePath) {
    Quickshell.execDetached(["cp", filePath, colorsJsonFilePath])
  }

  function changedWallpaper() {
    if (Settings.data.colorSchemes.useWallpaperColors) {
      console.log("[ColorSchemes] Starting color generation process")
      generateColorsProcess.running = true
      // Invalidate potential predefined scheme
      Settings.data.colorSchemes.predefinedScheme = ""
    }
  }

  FolderListModel {
    id: folderModel
    nameFilters: ["*.json"]
    showDirs: false
    sortField: FolderListModel.Name
    onStatusChanged: {
      if (status === FolderListModel.Ready) {
        var files = []
        for (var i = 0; i < count; i++) {
          var filepath = schemesDirectory + "/" + get(i, "fileName")
          files.push(filepath)
        }
        schemes = files
        scanning = false
        console.log("[ColorSchemes] Loaded", schemes.length, "schemes")
      }
    }
  }

  Process {
    id: generateColorsProcess
    command: ["matugen", "image", WallpapersService.currentWallpaper, "--config", Quickshell.shellDir + "/Assets/Matugen/matugen.toml"]
    workingDirectory: Quickshell.shellDir
    running: false
    stdout: StdioCollector {
      onStreamFinished: {
        console.log("[ColorSchemes] Generated colors from wallpaper")
      }
    }
    stderr: StdioCollector {
      onStreamFinished: {
        if (this.text !== "") {
          console.error(this.text)
        }
      }
    }
  }
}

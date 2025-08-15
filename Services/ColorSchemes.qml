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

  function loadColorSchemes() {
    console.log("[ColorSchemes] Load ColorSchemes")
    scanning = true
    schemes = []
    // Unsetting, then setting the folder will re-trigger the parsing!
    folderModel.folder = ""
    folderModel.folder = "file://" + Quickshell.shellDir + "/Assets/ColorSchemes"
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
          var filepath = folderModel.folder + "/" + get(i, "fileName")
          files.push(filepath)
        }
        schemes = files
        scanning = false
        console.log(schemes)
      }
    }
  }
}

pragma Singleton

import QtQuick
import Qt.labs.folderlistmodel
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  // Component.onCompleted: {
  //   console.log("[ColorSchemes] Service initialized")
  //   loadColorSchemes()
  // }

  // property var schemes: []
  // //property string currentScheme: Settings.data.wallpaper.current
  // property bool scanning: false

  // function loadColorSchemes() {
  //   scanning = true
  //   schemes = []
  //   // Unsetting, then setting the folder will re-trigger the parsing!
  //   folderModel.folder = ""
  //   folderModel.folder = "file://" + Quickshell.shellDir + "/Assets/Matugen/ColorSchemes"
  // }

  // FolderListModel {
  //   id: folderModel
  //   nameFilters: ["*.json"]
  //   showDirs: false
  //   sortField: FolderListModel.Name
  //   onStatusChanged: {
  //     console.log("sasfjsaflkhfkjhasf")
  //     if (status === FolderListModel.Ready) {
  //       var files = []
  //       for (var i = 0; i < count; i++) {
  //         console.log(get(i, "fileName"))
  //         // var filepath = (Settings.data.wallpaper.directory !== undefined ? Settings.data.wallpaper.directory : "") + "/" + get(
  //         //   i, "fileName")
  //         // files.push(filepath)
  //       }
  //       schemes = files
  //       scanning = false
  //       console.log(schemes)
  //     }
  //   }
  // }
}

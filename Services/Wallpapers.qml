pragma Singleton

import QtQuick
import Qt.labs.folderlistmodel
import Quickshell
import Quickshell.Io

Singleton {
  id: manager //TBC

  Item {
    Component.onCompleted: {
      loadWallpapers()
      setCurrentWallpaper(currentWallpaper, true)
      toggleRandomWallpaper()
    }
  }

  property var wallpaperList: []
  property string currentWallpaper: Settings.data.wallpaper.current
  property bool scanning: false
  property string transitionType: Settings.data.wallpaper.swww.transitionType
  property var randomChoices: ["fade", "left", "right", "top", "bottom", "wipe", "wave", "grow", "center", "any", "outer"]

  function loadWallpapers() {
    scanning = true
    wallpaperList = []
    folderModel.folder = "file://" + (Settings.data.wallpaper.directory !== undefined ? Settings.data.wallpaper.directory : "")
  }

  function changeWallpaper(path) {
    setCurrentWallpaper(path)
  }

  function setCurrentWallpaper(path, isInitial) {
    currentWallpaper = path
    if (!isInitial) {
      Settings.data.wallpaper.current = path
    }
    if (Settings.data.wallpaper.swww.enabled) {
      if (Settings.data.wallpaper.swww.transitionType === "random") {
        transitionType = randomChoices[Math.floor(Math.random() * randomChoices.length)]
      } else {
        transitionType = Settings.data.wallpaper.swww.transitionType
      }
      changeWallpaperProcess.running = true
    }

    if (randomWallpaperTimer.running) {
      randomWallpaperTimer.restart()
    }

    generateTheme()
  }

  function setRandomWallpaper() {
    var randomIndex = Math.floor(Math.random() * wallpaperList.length)
    var randomPath = wallpaperList[randomIndex]
    if (!randomPath) {
      return
    }
    setCurrentWallpaper(randomPath)
  }

  function toggleRandomWallpaper() {
    if (Settings.data.wallpaper.isRandom && !randomWallpaperTimer.running) {
      randomWallpaperTimer.start()
      setRandomWallpaper()
    } else if (!Settings.data.randomWallpaper && randomWallpaperTimer.running) {
      randomWallpaperTimer.stop()
    }
  }

  function restartRandomWallpaperTimer() {
    if (Settings.data.wallpaper.isRandom) {
      randomWallpaperTimer.stop()
      randomWallpaperTimer.start()
    }
  }

  function generateTheme() {
    if (Settings.data.wallpaper.generateTheme) {
      generateThemeProcess.running = true
    }
  }

  Timer {
    id: randomWallpaperTimer
    interval: Settings.data.wallpaper.randomInterval * 1000
    running: false
    repeat: true
    onTriggered: setRandomWallpaper()
    triggeredOnStart: false
  }

  FolderListModel {
    id: folderModel
    // Swww supports many images format but Quickshell only support a subset of those.
    nameFilters: ["*.jpg", "*.jpeg", "*.png", "*.gif", "*.pnm", "*.bmp"]
    showDirs: false
    sortField: FolderListModel.Name
    onStatusChanged: {
      if (status === FolderListModel.Ready) {
        var files = []
        var filesSwww = []
        for (var i = 0; i < count; i++) {
          var filepath = (Settings.data.wallpaper.directory !== undefined ? Settings.data.wallpaper.directory : "") + "/" + get(
            i, "fileName")
          files.push(filepath)
        }
        wallpaperList = files
        scanning = false
      }
    }
  }

  Process {
    id: changeWallpaperProcess
    command: ["swww", "img", "--resize", Settings.data.wallpaper.swww.resizeMethod, "--transition-fps", Settings.data.wallpaper.swww.transitionFps.toString(
        ), "--transition-type", transitionType, "--transition-duration", Settings.data.wallpaper.swww.transitionDuration.toString(
        ), currentWallpaper]
    running: false
  }

  Process {
    id: generateThemeProcess
    command: ["wallust", "run", currentWallpaper, "-u", "-k", "-d", "Templates"]
    workingDirectory: Quickshell.shellDir
    running: false
  }
}

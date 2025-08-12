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
      // Only set initial wallpaper if it's not empty
      if (currentWallpaper !== "") {
        console.log("Wallpapers: Initializing with wallpaper:", currentWallpaper)
        setCurrentWallpaper(currentWallpaper, true)
      }
      // Don't start random wallpaper during initialization
      // toggleRandomWallpaper()
    }
  }

  property var wallpaperList: []
  property string currentWallpaper: Settings.data.wallpaper.current
  property bool scanning: false
  property string transitionType: Settings.data.wallpaper.swww.transitionType
  property var randomChoices: ["simple", "fade", "left", "right", "top", "bottom", "wipe", "wave", "grow", "center", "any", "outer"]

  function loadWallpapers() {
    scanning = true
    wallpaperList = []
    folderModel.folder = "file://" + (Settings.data.wallpaper.directory !== undefined ? Settings.data.wallpaper.directory : "")
  }

  function changeWallpaper(path) {
    console.log("Wallpapers: changeWallpaper called with:", path)
    setCurrentWallpaper(path, false)
  }

  function setCurrentWallpaper(path, isInitial) {
    console.log("Wallpapers: Setting wallpaper to:", path, "isInitial:", isInitial)
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
      console.log("SWWW: Changing wallpaper with transition type:", transitionType)
      changeWallpaperProcess.running = true
    } else {
      // Fallback: update the settings directly for non-SWWW mode
      console.log("Non-SWWW mode: Setting wallpaper directly")
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
    setCurrentWallpaper(randomPath, false)
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

  function startSWWWDaemon() {
    if (Settings.data.wallpaper.swww.enabled) {
      console.log("SWWW: Attempting to start swww-daemon...")
      startDaemonProcess.running = true
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

    onStarted: {
      console.log("SWWW: Process started with command:", command.join(" "))
    }

    onExited: function (exitCode, exitStatus) {
      console.log("SWWW: Process finished with exit code:", exitCode, "status:", exitStatus)
      if (exitCode !== 0) {
        console.log("SWWW: Process failed. Make sure swww-daemon is running with: swww-daemon")
        console.log("SWWW: You can start it with: swww-daemon --format xrgb")
      }
    }
  }

  Process {
    id: generateThemeProcess
    command: ["wallust", "run", currentWallpaper, "-u", "-k", "-d", "Templates"]
    workingDirectory: Quickshell.shellDir
    running: false
  }

  Process {
    id: startDaemonProcess
    command: ["swww-daemon", "--format", "xrgb"]
    running: false

    onStarted: {
      console.log("SWWW: Daemon start process initiated")
    }

    onExited: function (exitCode, exitStatus) {
      console.log("SWWW: Daemon start process finished with exit code:", exitCode)
      if (exitCode === 0) {
        console.log("SWWW: Daemon started successfully")
      } else {
        console.log("SWWW: Failed to start daemon. It might already be running.")
      }
    }
  }
}

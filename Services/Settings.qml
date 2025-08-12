import QtQuick
import Quickshell
import Quickshell.Io
import qs.Services
pragma Singleton

Singleton {
  id: root

  // Define our app directories
  // Default config directory: ~/.config/noctalia
  // Default cache directory: ~/.cache/noctalia
  property string shellName: "noctalia"
  property string configDir: Quickshell.env("NOCTALIA_CONFIG_DIR") || (Quickshell.env("XDG_CONFIG_HOME")
                                                                       || Quickshell.env(
                                                                         "HOME") + "/.config") + "/" + shellName + "/"
  property string cacheDir: Quickshell.env("NOCTALIA_CACHE_DIR") || (Quickshell.env("XDG_CACHE_HOME") || Quickshell.env(
                                                                       "HOME") + "/.cache") + "/" + shellName + "/"

  property string settingsFile: Quickshell.env("NOCTALIA_SETTINGS_FILE") || (configDir + "settings.json")
  property string colorsFile: Quickshell.env("NOCTALIA_COLORS_FILE") || (configDir + "colors.json")

  property string defaultWallpaper: Qt.resolvedUrl("../Assets/Tests/wallpaper.png")
  property string defaultAvatar: Quickshell.env("HOME") + "/.face"

  // Used to access via Settings.data.xxx.yyy
  property var data: adapter

  // Needed to only have one NPanel loaded at a time. <--- VERY BROKEN
  //property var openPanel: null
  Item {
    Component.onCompleted: {

      // ensure settings dir exists
      Quickshell.execDetached(["mkdir", "-p", configDir])
      Quickshell.execDetached(["mkdir", "-p", cacheDir])
    }
  }

  FileView {

    // TBC ? needed for SWWW only ?
    // Qt.callLater(function () {
    //     WallpaperManager.setCurrentWallpaper(settings.currentWallpaper, true);
    // })
    path: settingsFile
    watchChanges: true
    onFileChanged: reload()
    onAdapterUpdated: writeAdapter()
    Component.onCompleted: {
      reload()
    }
    onLoaded: {
      Qt.callLater(function () {
        if (adapter.wallpaper.current !== "") {
          console.log("Settings: Initializing wallpaper to:", adapter.wallpaper.current)
          Wallpapers.setCurrentWallpaper(adapter.wallpaper.current, true)
        }
      })
    }
    onLoadFailed: function (error) {
      if (error.toString().includes("No such file") || error === 2)
        // File doesn't exist, create it with default values
        writeAdapter()
    }

    JsonAdapter {
      id: adapter

      // bar
      property JsonObject bar

      bar: JsonObject {
        property bool showActiveWindow: true
        property bool showActiveWindowIcon: false
        property bool showSystemInfo: false
        property bool showMedia: false
        // New: optional taskbar visibility in bar
        property bool showTaskbar: false
        property list<string> monitors: []
      }

      // general
      property JsonObject general

      general: JsonObject {
        property string avatarImage: defaultAvatar
        property bool dimDesktop: true
        property bool showScreenCorners: false
        property bool showDock: false
      }

      // location
      property JsonObject location

      location: JsonObject {
        property string name: "Tokyo"
        property bool useFahrenheit: false
        property bool reverseDayMonth: false
        property bool use12HourClock: false
      }

      // screen recorder
      property JsonObject screenRecorder

      screenRecorder: JsonObject {
        property string directory: "~/Videos"
        property int frameRate: 60
        property string audioCodec: "opus"
        property string videoCodec: "h264"
        property string quality: "very_high"
        property string colorRange: "limited"
        property bool showCursor: true
        // New: optional audio source selection (default: system output)
        property string audioSource: "default_output"
      }

      // wallpaper
      property JsonObject wallpaper

      wallpaper: JsonObject {
        property string directory: "/usr/share/wallpapers"
        property string current: ""
        property bool isRandom: false
        property int randomInterval: 300
        property bool generateTheme: false
        property JsonObject swww

        onDirectoryChanged: Wallpapers.loadWallpapers()
        onIsRandomChanged: Wallpapers.toggleRandomWallpaper()
        onRandomIntervalChanged: Wallpapers.restartRandomWallpaperTimer()

        swww: JsonObject {
          property bool enabled: false
          property string resizeMethod: "crop"
          property int transitionFps: 60
          property string transitionType: "random"
          property real transitionDuration: 1.1
        }
      }

      // applauncher
      property JsonObject appLauncher

      appLauncher: JsonObject {
        property list<string> pinnedExecs: []
      }

      // dock
      property JsonObject dock

      dock: JsonObject {
        property bool exclusive: false
        property list<string> monitors: []
      }

      // network
      property JsonObject network

      network: JsonObject {
        property bool wifiEnabled: true
        property bool bluetoothEnabled: true
      }

      // notifications
      property JsonObject notifications

      notifications: JsonObject {
        property list<string> monitors: []
      }

      // audioVisualizer
      property JsonObject audioVisualizer

      audioVisualizer: JsonObject {
        property string type: "radial"
      }

      // ui
      property JsonObject ui

      ui: JsonObject {
        property string fontFamily: "Roboto" // Family for all text
        property list<string> monitorsScale: []
      }
    }
  }

  Connections {
    target: adapter.wallpaper
    function onIsRandomChanged() {
      Wallpapers.toggleRandomWallpaper()
    }
    function onRandomIntervalChanged() {
      Wallpapers.restartRandomWallpaperTimer()
    }
    function onDirectoryChanged() {
      Wallpapers.loadWallpapers()
    }
  }
}

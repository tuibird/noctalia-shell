import QtQuick
import Quickshell
import Quickshell.Io
import qs.Services
pragma Singleton

Singleton {
  property string shellName: "noctalia"
  property string settingsDir: Quickshell.env("NOCTALIA_SETTINGS_DIR")
                               || (Quickshell.env("XDG_CONFIG_HOME")
                                   || Quickshell.env(
                                     "HOME") + "/.config") + "/" + shellName + "/"
  property string settingsFile: Quickshell.env("NOCTALIA_SETTINGS_FILE")
                                || (settingsDir + "settings.json")
  property string colorsFile: Quickshell.env("NOCTALIA_COLORS_FILE")
                              || (settingsDir + "colors.json")
  property var data: settingAdapter

  // Needed to only have one NPanel loaded at a time.
  // property var openPanel: null
  Item {
    Component.onCompleted: {
      // ensure settings dir
      Quickshell.execDetached(["mkdir", "-p", settingsDir])
    }
  }

  FileView {

    // TBC ? needed for SWWW only ?
    // Qt.callLater(function () {
    //     WallpaperManager.setCurrentWallpaper(settings.currentWallpaper, true);
    // })
    id: settingFileView

    path: settingsFile
    watchChanges: true
    onFileChanged: reload()
    onAdapterUpdated: writeAdapter()
    Component.onCompleted: function () {
      reload()
    }
    onLoaded: function () {}
    onLoadFailed: function (error) {
      if (error.toString().includes("No such file") || error === 2)
        // File doesn't exist, create it with default values
        writeAdapter()
    }

    JsonAdapter {
      id: settingAdapter

      // bar
      property JsonObject bar

      bar: JsonObject {
        property bool showActiveWindow: true
        property bool showActiveWindowIcon: false
        property bool showSystemInfo: false
        property bool showMedia: false
        property list<string> monitors: []
      }

      // general
      property JsonObject general

      general: JsonObject {
        property string avatarImage: Quickshell.env("HOME") + "/.face"
        property bool dimDesktop: true
        property bool showScreenCorners: false
      }

      // location
      property JsonObject location

      location: JsonObject {
        property bool name: true
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

        onDirectoryChanged: WallpaperManager.loadWallpapers()
        onIsRandomChanged: WallpaperManager.toggleRandomWallpaper()
        onRandomIntervalChanged: WallpaperManager.restartRandomWallpaperTimer()

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
}

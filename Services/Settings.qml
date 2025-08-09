pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.Services

Singleton {
  id: root

  property string shellName: "Noctalia"
  property string settingsDir: Quickshell.env("NOCTALIA_SETTINGS_DIR")
                               || (Quickshell.env("XDG_CONFIG_HOME")
                                   || Quickshell.env(
                                     "HOME") + "/.config") + "/" + shellName + "/"
  property string settingsFile: Quickshell.env("NOCTALIA_SETTINGS_FILE")
                                || (settingsDir + "Settings.json")
  property string themeFile: Quickshell.env("NOCTALIA_THEME_FILE")
                             || (settingsDir + "Theme.json")

  Item {
    Component.onCompleted: {
      // ensure settings dir
      Quickshell.execDetached(["mkdir", "-p", settingsDir])
    }
  }
}

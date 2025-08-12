pragma Singleton

import Quickshell
import qs.Modules.Settings

Singleton {
  id: root

  property var openedPanel: null
  property SettingsWindow settingsWindow: null
}

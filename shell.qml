// Disable reload popup
//@ pragma Env QS_NO_RELOAD_POPUP=1
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import qs.Widgets
import qs.Modules.Audio
import qs.Modules.Bar
import qs.Modules.DemoPanel
import qs.Modules.Background
import qs.Modules.SidePanel
import qs.Modules.Notification
import qs.Services

ShellRoot {
  id: shellRoot

  Background {}
  Overview {}
  ScreenCorners {}
  Bar {}

  DemoPanel {
    id: demoPanel
  }

  SidePanel {
    id: sidePanel
  }

  Notification {
    id: notification
  }

  AudioDeviceSelector {
    id: audioDeviceSelector
  }
}

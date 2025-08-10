// Disable reload popup
//@ pragma Env QS_NO_RELOAD_POPUP=1
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.Widgets
import qs.Modules.Bar
import qs.Modules.DemoPanel
import qs.Modules.Background
import qs.Modules.SidePanel
import qs.Services

ShellRoot {
  id: root

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
}

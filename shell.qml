// Disable reload popup
//@ pragma Env QS_NO_RELOAD_POPUP=1

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.Modules.Bar
import qs.Modules.DemoPanel
import qs.Modules.Background

ShellRoot {
  id: root

  Variants {
    model: Quickshell.screens

    delegate: Item {
      required property ShellScreen modelData
      
      Bar {
        modelData: parent.modelData
      }

     // Background {}

     // Overview {}
    }
  }

  DemoPanel {
    id: demoPanel
  }
}

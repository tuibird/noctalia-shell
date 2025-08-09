

/*
    Here we go, this is it. Rebuild time...
    No spaghetti code, preset sizing, proper project structure
    only "spawn" UI, do not do anything else here.
*/
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.Modules.Bar
import qs.Modules.DemoPanel

ShellRoot {
  id: root

  Variants {
    model: Quickshell.screens

    delegate: Bar {
      modelData: item
    }
  }

  DemoPanel {
    id: demoPanel
  }
}

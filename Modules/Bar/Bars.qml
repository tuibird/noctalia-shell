import Quickshell
import qs.Modules.Bar

Variants {
  model: Quickshell.screens

  delegate: Bar {
    modelData: item
  }
}

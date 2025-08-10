import QtQuick

Loader {
  id: loader

  // Boolean control to load/unload the item
  property bool isLoaded: false

  // Provide the component to load.
  // Example usage:
  // content: Component { NPanel { /* ... */ } }
  property Component panel

  active: isLoaded
  asynchronous: true
  sourceComponent: panel

  onActiveChanged: {
    if (active && item && item.show)
      item.show()
  }

  onItemChanged: {
    if (active && item && item.show)
      item.show()
  }

  Connections {
    target: loader.item
    function onDismissed() {
      loader.isLoaded = false
    }
  }
}

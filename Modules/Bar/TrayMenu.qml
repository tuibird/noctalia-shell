import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.Services
import qs.Widgets

PopupWindow {
  id: trayMenu

  readonly property real scaling: Scaling.scale(screen)
  property QsMenuHandle menu
  property var anchorItem: null
  property real anchorX
  property real anchorY

  implicitWidth: 180 * scaling
  implicitHeight: Math.max(40 * scaling, listView.contentHeight + (Style.spacingMedium * 2 * scaling))
  visible: false
  color: "transparent"

  anchor.item: anchorItem ? anchorItem : null
  anchor.rect.x: anchorX
  anchor.rect.y: anchorY - 4

  // Recursive function to destroy all open submenus in delegate tree, safely avoiding infinite recursion
  function destroySubmenusRecursively(item) {
    if (!item || !item.contentItem)
      return
    var children = item.contentItem.children
    for (var i = 0; i < children.length; ++i) {
      var child = children[i]
      if (child.subMenu) {
        child.subMenu.hideMenu()
        child.subMenu.destroy()
        child.subMenu = null
      }
      // Recursively destroy submenus only if the child has contentItem to prevent issues
      if (child.contentItem) {
        destroySubmenusRecursively(child)
      }
    }
  }

  function showAt(item, x, y) {
    if (!item) {
      console.warn("CustomTrayMenu: anchorItem is undefined, won't show menu.")
      return
    }
    anchorItem = item
    anchorX = x
    anchorY = y
    visible = true
    forceActiveFocus()
    Qt.callLater(() => trayMenu.anchor.updateAnchor())
  }

  function hideMenu() {
    visible = false
    destroySubmenusRecursively(listView)
  }

  Item {
    anchors.fill: parent
    Keys.onEscapePressed: trayMenu.hideMenu()
  }

  QsMenuOpener {
    id: opener
    menu: trayMenu.menu
  }

  Rectangle {
    id: bg
    anchors.fill: parent
    color: Colors.backgroundSecondary
    border.color: Colors.outline
    border.width: Math.max(1, Style.borderThin * scaling)
    radius: Style.radiusMedium * scaling
    z: 0
  }

  ListView {
    id: listView
    anchors.fill: parent
    anchors.margins: Style.spacingMedium * scaling
    spacing: 0
    interactive: false
    enabled: trayMenu.visible
    clip: true

    model: ScriptModel {
      values: opener.children ? [...opener.children.values] : []
    }

    delegate: Rectangle {
      id: entry
      required property var modelData

      width: listView.width
      height: (modelData?.isSeparator) ? 8 * scaling : 32 * scaling
      color: "transparent"

      property var subMenu: null

      NDivider {
        anchors.centerIn: parent
        width: parent.width - (Style.marginMedium * scaling * 2)
        visible: modelData?.isSeparator ?? false
      }

      Rectangle {
        id: bg
        anchors.fill: parent
        color: mouseArea.containsMouse ? Colors.highlight : "transparent"
        radius: Style.radiusSmall * scaling
        visible: !(modelData?.isSeparator ?? false)

        RowLayout {
          anchors.fill: parent
          anchors.leftMargin: Style.marginMedium * scaling
          anchors.rightMargin: Style.marginMedium * scaling
          spacing: Style.marginSmall * scaling

          NText {
            Layout.fillWidth: true
            color: (modelData?.enabled
                    ?? true) ? (mouseArea.containsMouse ? Colors.onAccent : Colors.textPrimary) : Colors.textDisabled
            text: modelData?.text ?? ""
            font.pointSize: Colors.fontSizeSmall * scaling
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
          }

          Image {
            Layout.preferredWidth: 16 * scaling
            Layout.preferredHeight: 16 * scaling
            source: modelData?.icon ?? ""
            visible: (modelData?.icon ?? "") !== ""
            fillMode: Image.PreserveAspectFit
          }

          // Chevron right for optional submenu
          Text {
            text: modelData?.hasChildren ? "menu" : ""
            font.family: "Material Symbols Outlined"
            font.pointSize: Colors.fontSizeMedium * scaling
            verticalAlignment: Text.AlignVCenter
            visible: modelData?.hasChildren ?? false
            color: Colors.textPrimary
          }
        }

        MouseArea {
          id: mouseArea
          anchors.fill: parent
          hoverEnabled: true
          enabled: (modelData?.enabled ?? true) && !(modelData?.isSeparator ?? false) && trayMenu.visible

          onClicked: {
            if (modelData && !modelData.isSeparator) {
              if (modelData.hasChildren) {
                // Submenus open on hover; ignore click here
                return
              }
              modelData.triggered()
              trayMenu.hideMenu()
            }
          }

          onEntered: {
            if (!trayMenu.visible)
              return

            if (modelData?.hasChildren) {
              // Close sibling submenus immediately
              for (var i = 0; i < listView.contentItem.children.length; i++) {
                const sibling = listView.contentItem.children[i]
                if (sibling !== entry && sibling.subMenu) {
                  sibling.subMenu.hideMenu()
                  sibling.subMenu.destroy()
                  sibling.subMenu = null
                }
              }
              if (entry.subMenu) {
                entry.subMenu.hideMenu()
                entry.subMenu.destroy()
                entry.subMenu = null
              }
              var globalPos = entry.mapToGlobal(0, 0)
              var submenuWidth = 180 * scaling
              var gap = 12 * scaling
              var openLeft = (globalPos.x + entry.width + submenuWidth > Screen.width)
              var anchorX = openLeft ? -submenuWidth - gap : entry.width + gap

              entry.subMenu = subMenuComponent.createObject(trayMenu, {
                                                              "menu": modelData,
                                                              "anchorItem": entry,
                                                              "anchorX": anchorX,
                                                              "anchorY": 0
                                                            })
              entry.subMenu.showAt(entry, anchorX, 0)
            } else {
              // Hovered item without submenu; close siblings
              for (var i = 0; i < listView.contentItem.children.length; i++) {
                const sibling = listView.contentItem.children[i]
                if (sibling.subMenu) {
                  sibling.subMenu.hideMenu()
                  sibling.subMenu.destroy()
                  sibling.subMenu = null
                }
              }
              if (entry.subMenu) {
                entry.subMenu.hideMenu()
                entry.subMenu.destroy()
                entry.subMenu = null
              }
            }
          }

          onExited: {
            if (entry.subMenu && !entry.subMenu.containsMouse()) {
              entry.subMenu.hideMenu()
              entry.subMenu.destroy()
              entry.subMenu = null
            }
          }
        }
      }

      // Simplified containsMouse without recursive calls to avoid stack overflow
      function containsMouse() {
        return mouseArea.containsMouse
      }

      Component.onDestruction: {
        if (subMenu) {
          subMenu.destroy()
          subMenu = null
        }
      }
    }
  }

  // -----------------------------------------
  // Sub Component
  // -----------------------------------------
  Component {
    id: subMenuComponent

    PopupWindow {
      id: subMenu
      implicitWidth: 180 * scaling
      implicitHeight: Math.max(40, listView.contentHeight + 12)
      visible: false
      color: "transparent"

      property QsMenuHandle menu
      property var anchorItem: null
      property real anchorX
      property real anchorY

      anchor.item: anchorItem ? anchorItem : null
      anchor.rect.x: anchorX
      anchor.rect.y: anchorY

      function showAt(item, x, y) {
        if (!item) {
          console.warn("subMenuComponent: anchorItem is undefined, not showing menu.")
          return
        }
        anchorItem = item
        anchorX = x
        anchorY = y
        visible = true
        Qt.callLater(() => subMenu.anchor.updateAnchor())
      }

      function hideMenu() {
        visible = false
        // Close all submenus recursively in this submenu
        for (var i = 0; i < listView.contentItem.children.length; i++) {
          const child = listView.contentItem.children[i]
          if (child.subMenu) {
            child.subMenu.hideMenu()
            child.subMenu.destroy()
            child.subMenu = null
          }
        }
      }

      // Simplified containsMouse avoiding recursive calls
      function containsMouse() {
        return subMenu.containsMouse
      }

      Item {
        anchors.fill: parent
        Keys.onEscapePressed: subMenu.hideMenu()
      }

      QsMenuOpener {
        id: opener
        menu: subMenu.menu
      }

      Rectangle {
        id: bg
        anchors.fill: parent
        color: Colors.backgroundPrimary
        border.color: Colors.outline
        border.width: Math.max(1, Style.borderThin * scaling)
        radius: Style.radiusMedium * scaling
        z: 0
      }

      ListView {
        id: listView
        anchors.fill: parent
        anchors.margins: Style.spacingSmall * scaling
        spacing: Style.spacingTiny * scaling
        interactive: false
        enabled: subMenu.visible
        clip: true

        model: ScriptModel {
          values: opener.children ? [...opener.children.values] : []
        }

        delegate: Rectangle {
          id: entry
          required property var modelData

          width: listView.width
          height: (modelData?.isSeparator) ? 8 * scaling : 32 * scaling
          color: "transparent"

          property var subMenu: null

          NDivider {
            anchors.centerIn: parent
            width: parent.width - (Style.marginMedium * scaling * 2)
            visible: modelData?.isSeparator ?? false
          }

          Rectangle {
            id: bg
            anchors.fill: parent
            color: mouseArea.containsMouse ? Colors.highlight : "transparent"
            radius: Style.radiusSmall * scaling
            visible: !(modelData?.isSeparator ?? false)
            property color hoverTextColor: mouseArea.containsMouse ? Colors.onAccent : Colors.textPrimary

            RowLayout {
              anchors.fill: parent
              anchors.leftMargin: Style.spacingMedium * scaling
              anchors.rightMargin: Style.spacingMedium * scaling
              spacing: Style.spacingSmall * scaling

              NText {
                Layout.fillWidth: true
                color: (modelData?.enabled ?? true) ? bg.hoverTextColor : Colors.textDisabled
                text: modelData?.text ?? ""
                font.pointSize: Colors.fontSizeSmall * scaling
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
              }

              Image {
                Layout.preferredWidth: 16 * scaling
                Layout.preferredHeight: 16 * scaling
                source: modelData?.icon ?? ""
                visible: (modelData?.icon ?? "") !== ""
                fillMode: Image.PreserveAspectFit
              }

              // TBC a Square UTF-8?
              NText {
                text: modelData?.hasChildren ? "\uE5CC" : ""
                font.family: "Material Symbols Outlined"
                font.pointSize: Colors.fontSizeMedium * scaling
                verticalAlignment: Text.AlignVCenter
                visible: modelData?.hasChildren ?? false
              }
            }

            MouseArea {
              id: mouseArea
              anchors.fill: parent
              hoverEnabled: true
              enabled: (modelData?.enabled ?? true) && !(modelData?.isSeparator ?? false) && subMenu.visible

              onClicked: {
                if (modelData && !modelData.isSeparator) {
                  if (modelData.hasChildren) {
                    return
                  }
                  modelData.triggered()
                  trayMenu.hideMenu()
                }
              }

              onEntered: {
                if (!subMenu.visible) {
                  return
                }

                if (modelData?.hasChildren) {
                  for (var i = 0; i < listView.contentItem.children.length; i++) {
                    const sibling = listView.contentItem.children[i]
                    if (sibling !== entry && sibling.subMenu) {
                      sibling.subMenu.hideMenu()
                      sibling.subMenu.destroy()
                      sibling.subMenu = null
                    }
                  }
                  if (entry.subMenu) {
                    entry.subMenu.hideMenu()
                    entry.subMenu.destroy()
                    entry.subMenu = null
                  }
                  var globalPos = entry.mapToGlobal(0, 0)
                  var submenuWidth = 180 * scaling
                  var gap = 12 * scaling
                  var openLeft = (globalPos.x + entry.width + submenuWidth > Screen.width)
                  var anchorX = openLeft ? -submenuWidth - gap : entry.width + gap

                  entry.subMenu = subMenuComponent.createObject(subMenu, {
                                                                  "menu": modelData,
                                                                  "anchorItem": entry,
                                                                  "anchorX": anchorX,
                                                                  "anchorY": 0
                                                                })
                  entry.subMenu.showAt(entry, anchorX, 0)
                } else {
                  for (var i = 0; i < listView.contentItem.children.length; i++) {
                    const sibling = listView.contentItem.children[i]
                    if (sibling.subMenu) {
                      sibling.subMenu.hideMenu()
                      sibling.subMenu.destroy()
                      sibling.subMenu = null
                    }
                  }
                  if (entry.subMenu) {
                    entry.subMenu.hideMenu()
                    entry.subMenu.destroy()
                    entry.subMenu = null
                  }
                }
              }

              onExited: {
                if (entry.subMenu && !entry.subMenu.containsMouse()) {
                  entry.subMenu.hideMenu()
                  entry.subMenu.destroy()
                  entry.subMenu = null
                }
              }
            }
          }

          // Simplified & safe containsMouse avoiding recursion
          function containsMouse() {
            return mouseArea.containsMouse
          }

          Component.onDestruction: {
            if (subMenu) {
              subMenu.destroy()
              subMenu = null
            }
          }
        }
      }
    }
  }
}

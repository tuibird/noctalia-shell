import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Qt.labs.folderlistmodel
import qs.Services
import qs.Widgets

Item {
  property real scaling: 1
  readonly property string tabIcon: "photo_library"
  readonly property string tabLabel: "Wallpaper Selector"
  readonly property int tabIndex: 7
  Layout.fillWidth: true
  Layout.fillHeight: true

  ScrollView {
    anchors.fill: parent
    clip: true
    ScrollBar.vertical.policy: ScrollBar.AsNeeded
    ScrollBar.horizontal.policy: ScrollBar.AsNeeded
    contentWidth: parent.width

    ColumnLayout {
      width: parent.width
      spacing: Style.marginMedium * scaling
      Layout.fillWidth: true

      NText {
        text: "Wallpaper Selector"
        font.weight: Style.fontWeightBold
        color: Colors.accentSecondary
      }

      NText {
        text: "Select a wallpaper from your configured directory"
        color: Colors.textSecondary
        wrapMode: Text.WordWrap
      }

      // Current wallpaper display
      NText {
        text: "Current Wallpaper"
        font.weight: Style.fontWeightBold
        color: Colors.textPrimary
      }

      Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 120 * scaling
        radius: Style.radiusMedium * scaling
        color: Colors.backgroundSecondary
        border.color: Colors.outline
        border.width: Math.max(1, Style.borderThin * scaling)
        clip: true

        Image {
          id: currentWallpaperImage
          anchors.fill: parent
          anchors.margins: Style.marginSmall * scaling
          source: Wallpapers.currentWallpaper
          fillMode: Image.PreserveAspectCrop
          asynchronous: true
          cache: true
        }

        // Fallback if no image
        Rectangle {
          anchors.fill: parent
          anchors.margins: Style.marginSmall * scaling
          color: Colors.backgroundTertiary
          radius: Style.radiusSmall * scaling
          visible: currentWallpaperImage.status !== Image.Ready

          ColumnLayout {
            anchors.centerIn: parent
            spacing: Style.marginSmall * scaling

            NText {
              text: "image"
              font.family: "Material Symbols Outlined"
              font.pointSize: Style.fontSizeLarge * scaling
              color: Colors.textSecondary
              Layout.alignment: Qt.AlignHCenter
            }

            NText {
              text: "No wallpaper selected"
              color: Colors.textSecondary
              Layout.alignment: Qt.AlignHCenter
            }
          }
        }
      }

      NDivider {
        Layout.fillWidth: true
      }

      // Wallpaper grid
      NText {
        text: "Available Wallpapers"
        font.weight: Style.fontWeightBold
        color: Colors.textPrimary
      }

      NText {
        text: "Click on a wallpaper to set it as your current wallpaper"
        color: Colors.textSecondary
        wrapMode: Text.WordWrap
      }

      NText {
        text: Settings.data.wallpaper.swww.enabled ? 
          "Wallpapers will change with " + Settings.data.wallpaper.swww.transitionType + " transition" :
          "Wallpapers will change instantly"
        color: Colors.textSecondary
        font.pointSize: Style.fontSizeSmall * scaling
        visible: Settings.data.wallpaper.swww.enabled
      }

      // Refresh button and status
      RowLayout {
        Layout.fillWidth: true
        spacing: Style.marginSmall * scaling

        NIconButton {
          icon: "refresh"
          tooltipText: "Refresh wallpaper list"
          onClicked: {
            Wallpapers.loadWallpapers()
          }
        }

        NText {
          text: "Refresh"
          color: Colors.textSecondary
        }
      }

      // Wallpaper grid container
      Item {
        Layout.fillWidth: true
        Layout.preferredHeight: 400 * scaling

        FolderListModel {
          id: folderModel
          folder: "file://" + (Settings.data.wallpaper.directory !== undefined ? Settings.data.wallpaper.directory : "")
          nameFilters: ["*.jpg", "*.jpeg", "*.png", "*.gif", "*.pnm", "*.bmp"]
          showDirs: false
          sortField: FolderListModel.Name
        }

        GridView {
          id: wallpaperGridView
          anchors.fill: parent
          clip: true
          model: folderModel
          
          // Fixed 5 items per row - more aggressive sizing
          property int itemSize: Math.floor((width - leftMargin - rightMargin - (4 * Style.marginSmall * scaling)) / 5)
          
          cellWidth: Math.floor((width - leftMargin - rightMargin) / 5)
          cellHeight: Math.floor(itemSize * 0.67) + Style.marginSmall * scaling
          
          leftMargin: Style.marginSmall * scaling
          rightMargin: Style.marginSmall * scaling
          topMargin: Style.marginSmall * scaling
          bottomMargin: Style.marginSmall * scaling

          delegate: Rectangle {
            id: wallpaperItem
            property string wallpaperPath: Settings.data.wallpaper.directory + "/" + fileName
            property bool isSelected: wallpaperPath === Wallpapers.currentWallpaper

            width: wallpaperGridView.itemSize
            height: Math.floor(wallpaperGridView.itemSize * 0.67)
            radius: Style.radiusMedium * scaling
            color: isSelected ? Colors.accentPrimary : Colors.backgroundSecondary
            border.color: isSelected ? Colors.accentSecondary : Colors.outline
            border.width: Math.max(1, Style.borderThin * scaling)
            clip: true

            Image {
              anchors.fill: parent
              anchors.margins: Style.marginTiny * scaling
              source: wallpaperPath
              fillMode: Image.PreserveAspectCrop
              asynchronous: true
              cache: true
              smooth: true
            }

            // Selection indicator
            Rectangle {
              anchors.top: parent.top
              anchors.right: parent.right
              anchors.margins: Style.marginTiny * scaling
              width: 20 * scaling
              height: 20 * scaling
              radius: width / 2
              color: Colors.accentPrimary
              border.color: Colors.onAccent
              border.width: Math.max(1, Style.borderThin * scaling)
              visible: isSelected

              NText {
                anchors.centerIn: parent
                text: "check"
                font.family: "Material Symbols Outlined"
                font.pointSize: Style.fontSizeSmall * scaling
                color: Colors.onAccent
              }
            }

            // Hover effect
            Rectangle {
              anchors.fill: parent
              color: Colors.textPrimary
              opacity: mouseArea.containsMouse ? 0.1 : 0
              radius: parent.radius
              
              Behavior on opacity {
                NumberAnimation { duration: 150 }
              }
            }

            MouseArea {
              id: mouseArea
              anchors.fill: parent
              acceptedButtons: Qt.LeftButton
              hoverEnabled: true
              onClicked: {
                Wallpapers.changeWallpaper(wallpaperPath)
              }
            }
          }
        }

        // Empty state
        Rectangle {
          anchors.fill: parent
          color: Colors.backgroundSecondary
          radius: Style.radiusMedium * scaling
          border.color: Colors.outline
          border.width: Math.max(1, Style.borderThin * scaling)
          visible: folderModel.count === 0 && !Wallpapers.scanning

          ColumnLayout {
            anchors.centerIn: parent
            spacing: Style.marginMedium * scaling

            NText {
              text: "folder_open"
              font.family: "Material Symbols Outlined"
              font.pointSize: Style.fontSizeLarge * scaling
              color: Colors.textSecondary
              Layout.alignment: Qt.AlignHCenter
            }

            NText {
              text: "No wallpapers found"
              color: Colors.textSecondary
              font.weight: Style.fontWeightBold
              Layout.alignment: Qt.AlignHCenter
            }

            NText {
              text: "Make sure your wallpaper directory is configured and contains image files"
              color: Colors.textSecondary
              wrapMode: Text.WordWrap
              horizontalAlignment: Text.AlignHCenter
              Layout.preferredWidth: 300 * scaling
            }
          }
        }
      }
    }
  }
}
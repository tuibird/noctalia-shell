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
      ColumnLayout {
        spacing: Style.marginLarge * scaling
        Layout.margins: Style.marginLarge * scaling
        Layout.fillWidth: true

        // Current wallpaper display
        NText {
          text: "Current Wallpaper"
          font.pointSize: Style.fontSizeXL * scaling
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

          NImageRounded {
            id: currentWallpaperImage
            anchors.fill: parent
            anchors.margins: Style.marginSmall * scaling
            imagePath: Wallpapers.currentWallpaper
            fallbackIcon: "image"
            borderColor: Colors.outline
            borderWidth: Math.max(1, Style.borderThin * scaling)
            imageRadius: Style.radiusMedium * scaling
          }
        }

        NDivider {
          Layout.fillWidth: true
          Layout.topMargin: Style.marginLarge * scaling
          Layout.bottomMargin: Style.marginLarge * scaling
        }

        RowLayout {
          Layout.fillWidth: true

          ColumnLayout {
            Layout.fillWidth: true

            // Wallpaper grid
            NText {
              text: "Wallpaper Selector"
              font.pointSize: Style.fontSizeXL * scaling
              font.weight: Style.fontWeightBold
              color: Colors.textPrimary
            }

            NText {
              text: "Click on a wallpaper to set it as your current wallpaper"
              color: Colors.textSecondary
              wrapMode: Text.WordWrap
              Layout.fillWidth: true
            }

            NText {
              text: Settings.data.wallpaper.swww.enabled ? "Wallpapers will change with " + Settings.data.wallpaper.swww.transitionType
                                                           + " transition" : "Wallpapers will change instantly"
              color: Colors.textSecondary
              font.pointSize: Style.fontSizeSmall * scaling
              visible: Settings.data.wallpaper.swww.enabled
            }
          }

          NIconButton {
            icon: "refresh"
            tooltipText: "Refresh wallpaper list"
            onClicked: {
              Wallpapers.loadWallpapers()
            }
            Layout.alignment: Qt.AlignTop | Qt.AlignRight
          }
        }

        // Wallpaper grid container
        Item {
          Layout.fillWidth: true
          Layout.preferredHeight: {
            return Math.ceil(folderModel.count / wallpaperGridView.columns) * wallpaperGridView.cellHeight
          }

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
            property int columns: 5
            property int itemSize: Math.floor(
                                     (width - leftMargin - rightMargin - (4 * Style.marginSmall * scaling)) / columns)

            cellWidth: Math.floor((width - leftMargin - rightMargin) / columns)
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

              NImageRounded {
                anchors.fill: parent
                anchors.margins: Style.marginTiny * scaling
                imagePath: wallpaperPath
                fallbackIcon: "image"
                borderColor: "transparent"
                borderWidth: 0
                imageRadius: Style.radiusMedium * scaling
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
                  NumberAnimation {
                    duration: 150
                  }
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
}

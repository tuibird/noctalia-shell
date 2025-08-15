import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Services
import qs.Widgets
import Quickshell.Io

ColumnLayout {
  id: root

  spacing: 0

  // Helper function to get color from scheme file
  function getSchemeColor(schemePath, colorKey) {
    // Extract scheme name from path
    var schemeName = schemePath.split("/").pop().replace(".json", "")

    // Try to get from cached data first
    if (schemeColorsCache[schemeName] && schemeColorsCache[schemeName][colorKey]) {
      return schemeColorsCache[schemeName][colorKey]
    }

    // Return a default color if not cached yet
    return "#000000"
  }

  // Cache for scheme colors
  property var schemeColorsCache: ({})

  // Array to hold FileView objects
  property var fileViews: []

  // Scale properties for card animations
  property real cardScaleLow: 0.95
  property real cardScaleHigh: 1.0

  // Load color scheme data when schemes are available
  Connections {
    target: ColorSchemes
    function onSchemesChanged() {
      loadSchemeColors()
    }
  }

  function loadSchemeColors() {
    // Clear existing cache
    schemeColorsCache = {}

    // Destroy existing FileViews
    for (var i = 0; i < fileViews.length; i++) {
      if (fileViews[i]) {
        fileViews[i].destroy()
      }
    }
    fileViews = []

    // Create FileViews for each scheme
    for (var i = 0; i < ColorSchemes.schemes.length; i++) {
      var schemePath = ColorSchemes.schemes[i]
      var schemeName = schemePath.split("/").pop().replace(".json", "")

      // Create FileView component
      var component = Qt.createComponent("SchemeFileView.qml")
      if (component.status === Component.Ready) {
        var fileView = component.createObject(root, {
                                                "path": schemePath,
                                                "schemeName": schemeName
                                              })
        fileViews.push(fileView)
      } else {
        // Fallback: create inline FileView
        createInlineFileView(schemePath, schemeName)
      }
    }
  }

  function createInlineFileView(schemePath, schemeName) {
    var fileViewQml = `
    import QtQuick
    import Quickshell.Io

    FileView {
    property string schemeName: "${schemeName}"
    path: "${schemePath}"
    blockLoading: true

    onLoaded: {
    try {
    var jsonData = JSON.parse(text())
    root.schemeLoaded(schemeName, jsonData)
    } catch (e) {
    console.warn("Failed to parse JSON for scheme:", schemeName, e)
    }
    }
    }
    `

    try {
      var fileView = Qt.createQmlObject(fileViewQml, root, "dynamicFileView_" + schemeName)
      fileViews.push(fileView)
    } catch (e) {
      console.warn("Failed to create FileView for scheme:", schemeName, e)
    }
  }

  function schemeLoaded(schemeName, jsonData) {
    var colors = {}

    // Extract colors from JSON data
    if (jsonData && typeof jsonData === 'object') {
      colors.mPrimary = jsonData.mPrimary || jsonData.primary || "#000000"
      colors.mSecondary = jsonData.mSecondary || jsonData.secondary || "#000000"
      colors.mTertiary = jsonData.mTertiary || jsonData.tertiary || "#000000"
      colors.mError = jsonData.mError || jsonData.error || "#ff0000"
      colors.mSurface = jsonData.mSurface || jsonData.surface || "#ffffff"
      colors.mOnSurface = jsonData.mOnSurface || jsonData.onSurface || "#000000"
      colors.mOutline = jsonData.mOutline || jsonData.outline || "#666666"
    } else {
      // Default colors
      colors = {
        "mPrimary": "#000000",
        "mSecondary": "#000000",
        "mTertiary": "#000000",
        "mError": "#ff0000",
        "mSurface": "#ffffff",
        "mOnSurface": "#000000",
        "mOutline": "#666666"
      }
    }

    // Update cache
    var newCache = schemeColorsCache
    newCache[schemeName] = colors
    schemeColorsCache = newCache
  }

  ScrollView {
    id: scrollView

    Layout.fillWidth: true
    Layout.fillHeight: true
    padding: Style.marginMedium * scaling
    clip: true
    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
    ScrollBar.vertical.policy: ScrollBar.AsNeeded

    ColumnLayout {
      width: scrollView.availableWidth
      spacing: 0

      Item {
        Layout.fillWidth: true
        Layout.preferredHeight: 0
      }

      ColumnLayout {
        spacing: Style.marginLarge * scaling
        Layout.fillWidth: true

        // Use Matugen
        NToggle {
          label: "Use Matugen"
          description: "Automatically generate colors based on your active wallpaper using Matugen"
          value: Settings.data.colorSchemes.useWallpaperColors
          onToggled: function (newValue) {
            Settings.data.colorSchemes.useWallpaperColors = newValue
            if (Settings.data.colorSchemes.useWallpaperColors) {
              ColorSchemes.changedWallpaper()
            }
          }
        }

        NDivider {
          Layout.fillWidth: true
          Layout.topMargin: Style.marginLarge * scaling
          Layout.bottomMargin: Style.marginLarge * scaling
        }

        ColumnLayout {
          spacing: Style.marginTiniest * scaling
          Layout.fillWidth: true

          NText {
            text: "Predefined Color Schemes"
            font.pointSize: Style.fontSizeLarge * scaling
            font.weight: Style.fontWeightBold
            color: Colors.mOnSurface
            Layout.fillWidth: true
          }

          NText {
            text: "These color schemes only apply when 'Use Matugen' is disabled. When enabled, Matugen will generate colors based on your wallpaper instead."
            font.pointSize: Style.fontSizeSmall * scaling
            color: Colors.mOnSurface
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
          }
        }

        ColumnLayout {
          spacing: Style.marginTiny * scaling
          Layout.fillWidth: true
          Layout.topMargin: Style.marginLarge * scaling

          // Color Schemes Grid
          GridLayout {
            columns: 4
            rowSpacing: Style.marginLarge * scaling
            columnSpacing: Style.marginLarge * scaling
            Layout.fillWidth: true

            Repeater {
              model: ColorSchemes.schemes

              Rectangle {
                id: schemeCard
                Layout.fillWidth: true
                Layout.preferredHeight: 120 * scaling
                radius: Style.radiusMedium * scaling
                color: getSchemeColor(modelData, "mSurface")
                border.width: Math.max(1, Style.borderThick * scaling)
                border.color: Settings.data.colorSchemes.predefinedScheme === modelData ? Colors.mPrimary : Colors.mOutline
                scale: root.cardScaleLow

                property string schemePath: modelData

                // Mouse area for selection
                MouseArea {
                  anchors.fill: parent
                  onClicked: {
                    // Disable useWallpaperColors when picking a predefined color scheme
                    Settings.data.colorSchemes.useWallpaperColors = false
                    Settings.data.colorSchemes.predefinedScheme = schemePath
                    ColorSchemes.applyScheme(schemePath)
                  }
                  hoverEnabled: true
                  cursorShape: Qt.PointingHandCursor

                  onEntered: {
                    schemeCard.scale = root.cardScaleHigh
                  }

                  onExited: {
                    schemeCard.scale = root.cardScaleLow
                  }
                }

                // Card content
                ColumnLayout {
                  anchors.fill: parent
                  anchors.margins: Style.marginXL * scaling
                  spacing: Style.marginSmall * scaling

                  // Scheme name
                  NText {
                    text: {
                      // Remove json and the full path
                      var chunks = schemePath.replace(".json", "").split("/")
                      return chunks[chunks.length - 1]
                    }
                    font.pointSize: Style.fontSizeMedium * scaling
                    font.weight: Style.fontWeightBold
                    color: Colors.mOnSurface
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                  }

                  // Color swatches
                  RowLayout {
                    spacing: Style.marginSmall * scaling
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter

                    // Primary color swatch
                    Rectangle {
                      width: 28 * scaling
                      height: 28 * scaling
                      radius: width * 0.5
                      color: getSchemeColor(modelData, "mPrimary")
                    }

                    // Secondary color swatch
                    Rectangle {
                      width: 28 * scaling
                      height: 28 * scaling
                      radius: Style.radiusSmall * scaling
                      color: getSchemeColor(modelData, "mSecondary")
                    }

                    // Tertiary color swatch
                    Rectangle {
                      width: 28 * scaling
                      height: 28 * scaling
                      radius: width * 0.5
                      color: getSchemeColor(modelData, "mTertiary")
                    }

                    // Error color swatch
                    Rectangle {
                      width: 28 * scaling
                      height: 28 * scaling
                      radius: width * 0.5
                      color: getSchemeColor(modelData, "mError")
                    }
                  }
                }

                // Selection indicator
                Rectangle {
                  visible: Settings.data.colorSchemes.predefinedScheme === schemePath
                  anchors.right: parent.right
                  anchors.top: parent.top
                  anchors.margins: Style.marginSmall * scaling
                  width: 24 * scaling
                  height: 24 * scaling
                  radius: width * 0.5
                  color: Colors.mPrimary

                  NText {
                    anchors.centerIn: parent
                    text: "✓"
                    font.pointSize: Style.fontSizeSmall * scaling
                    font.weight: Style.fontWeightBold
                    color: Colors.mOnPrimary
                  }
                }

                // Smooth animations
                Behavior on scale {
                  NumberAnimation {
                    duration: Style.animationNormal
                    easing.type: Easing.OutCubic
                  }
                }

                Behavior on border.color {
                  ColorAnimation {
                    duration: Style.animationNormal
                  }
                }

                Behavior on border.width {
                  NumberAnimation {
                    duration: Style.animationFast
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

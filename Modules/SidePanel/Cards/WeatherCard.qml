import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Services
import qs.Widgets

// Weather overview card (placeholder data)
NBox {
  id: root

  readonly property real scaling: Scaling.scale(screen)
  readonly property bool weatherReady: (Location.data.weather !== null)

  Layout.fillWidth: true
  // Height driven by content
  implicitHeight: content.implicitHeight + Style.marginLarge * 2 * scaling

  ColumnLayout {
    id: content
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.margins: Style.marginMedium * scaling
    spacing: Style.marginMedium * scaling

    RowLayout {
      spacing: Style.marginSmall * scaling
      NText {
        text: weatherReady ? Location.weatherSymbolFromCode(Location.data.weather.current_weather.weathercode) : ""
        font.family: "Material Symbols Outlined"
        font.pointSize: Style.fontSizeXXL * 1.5 * scaling
        color: Colors.accentSecondary
      }

      ColumnLayout {
        spacing: -Style.marginTiny * scaling
        NText {
          text: {
            // Ensure the name is not too long if one had to specify the country
            const chunks = Settings.data.location.name.split(",")
            return chunks[0]
          }
          font.weight: Style.fontWeightBold
          font.pointSize: Style.fontSizeXL * scaling
        }

        RowLayout {
          NText {
            visible: weatherReady
            text: {
              if (!weatherReady) {
                return ""
              }
              var temp = Location.data.weather.current_weather.temperature
              if (Settings.data.location.useFahrenheit) {
                temp = Location.celsiusToFahrenheit(temp)
              }
              temp = Math.round(temp)
              return `${temp}°`
            }
            font.pointSize: Style.fontSizeXL * scaling
            font.weight: Style.fontWeightBold
          }

          NText {
            text: weatherReady ? `(${Location.data.weather.timezone_abbreviation})` : ""
            font.pointSize: Style.fontSizeSmall * scaling
            visible: Location.data.weather
          }
        }
      }
    }

    NDivider {
      visible: weatherReady
      Layout.fillWidth: true
    }

    RowLayout {
      visible: weatherReady
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignHCenter
      spacing: Style.marginLarge * scaling
      Repeater {
        model: weatherReady ? Location.data.weather.daily.time : []
        delegate: ColumnLayout {
          Layout.alignment: Qt.AlignHCenter
          spacing: Style.marginSmall * scaling
          NText {
            text: Qt.formatDateTime(new Date(Location.data.weather.daily.time[index]), "ddd")
            color: Colors.textPrimary
          }
          NText {
            text: Location.weatherSymbolFromCode(Location.data.weather.daily.weathercode[index])
            font.family: "Material Symbols Outlined"
            font.pointSize: Style.fontSizeXL * scaling
            color: Colors.textSecondary
          }
          NText {
            text: {
              var max = Location.data.weather.daily.temperature_2m_max[index]
              var min = Location.data.weather.daily.temperature_2m_min[index]
              if (Settings.data.location.useFahrenheit) {
                max = Location.celsiusToFahrenheit(max)
                min = Location.celsiusToFahrenheit(min)
              }
              max = Math.round(max)
              min = Math.round(min)
              return `${max}°/${min}°`
            }
            font.pointSize: Style.fontSizeSmall * scaling
            color: Colors.textSecondary
          }
        }
      }
    }

    RowLayout {
      visible: !weatherReady
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignHCenter
      NBusyIndicator {}
    }
  }
}

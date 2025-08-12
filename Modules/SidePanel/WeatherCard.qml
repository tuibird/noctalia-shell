import QtQuick
import QtQuick.Layouts
import qs.Services
import qs.Widgets

// Weather overview card (placeholder data)
NBox {
  id: root

  readonly property real scaling: Scaling.scale(screen)

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
      Text {
        text: Location.weatherSymbolFromCode(Location.data.weather.current_weather.weathercode) 
        font.family: "Material Symbols Outlined"
        font.pointSize: Style.fontSizeXXL * 1.25 * scaling
        color: Colors.accentSecondary
      }
      ColumnLayout {
        RowLayout {
          NText {
            text: Settings.data.location.name 
            font.weight: Style.fontWeightBold
            font.pointSize: Style.fontSizeLarge * scaling
          }
          NText {
            text: "(" + Location.data. weather.timezone_abbreviation + ")"
            font.pointSize: Style.fontSizeTiny * scaling
          }
        }

        NText {
          text: "26°C"
          font.pointSize: Style.fontSizeXL *  scaling
          font.weight: Style.fontWeightBold
        }
      }
    }

    Rectangle {
      height: 1
      width: parent.width
      color: Colors.backgroundTertiary
    }

    RowLayout {
      Layout.fillWidth: true
      spacing: Style.marginMedium * scaling
      Repeater {
        model: 5
        delegate: ColumnLayout {
          spacing: 2 * scaling
          NText {
            text: Qt.formatDateTime(new Date(Location.data.weather.daily.time[index]), "ddd")
            font.weight: Style.fontWeightBold
          }
          NText {
            text: Location.weatherSymbolFromCode(Location.data.weather.daily.weathercode[index])
            font.family: "Material Symbols Outlined"
            font.weight: Style.fontWeightBold
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
              return `${max}° / ${min}°`
            }
            color: Colors.textSecondary
          }
        }
      }
    }
  }
}

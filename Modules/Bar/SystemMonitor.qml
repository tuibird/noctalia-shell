import QtQuick
import Quickshell
import qs.Services
import qs.Widgets

Row {
  id: layout
  anchors.verticalCenter: parent.verticalCenter
  spacing: Style.marginSmall * scaling
  visible: Settings.data.bar.showSystemInfo

  // Ensure our width is an integer
  width: Math.floor(cpuUsageLayout.width + cpuTempLayout.width + memoryUsageLayout.width + (2 * 10))

  Row {
    id: cpuUsageLayout
    spacing: Style.marginTiny * scaling

    NText {
      id: cpuUsageIcon
      text: "speed"
      font.family: "Material Symbols Outlined"
      font.pointSize: Style.fontSizeLarge * scaling
      verticalAlignment: Text.AlignVCenter
      anchors.verticalCenter: parent.verticalCenter
      color: Colors.accentPrimary
    }

    NText {
      id: cpuUsageText
      text: `${SystemStats.cpuUsage}%`
      font.pointSize: Style.fontSizeSmall * scaling
      font.weight: Style.fontWeightBold
      anchors.verticalCenter: parent.verticalCenter
      verticalAlignment: Text.AlignVCenter
    }
  }

  // CPU Temperature Component
  Row {
    id: cpuTempLayout
    spacing: Style.marginTiny * scaling

    NText {
      text: "thermometer"
      font.family: "Material Symbols Outlined"
      font.pointSize: Style.fontSizeLarge * scaling
      color: Colors.accentPrimary
      verticalAlignment: Text.AlignVCenter
      anchors.verticalCenter: parent.verticalCenter
    }

    NText {
      text: `${SystemStats.cpuTemp}°C`
      font.pointSize: Style.fontSizeSmall * scaling
      font.weight: Style.fontWeightBold
      anchors.verticalCenter: parent.verticalCenter
      verticalAlignment: Text.AlignVCenter
    }
  }

  // Memory Usage Component
  Row {
    id: memoryUsageLayout
    spacing: Style.marginTiny * scaling

    NText {
      text: "memory"
      font.family: "Material Symbols Outlined"
      font.pointSize: Style.fontSizeLarge * scaling
      color: Colors.accentPrimary
      verticalAlignment: Text.AlignVCenter
      anchors.verticalCenter: parent.verticalCenter
    }

    NText {
      text: `${SystemStats.memoryUsageGb}G`
      font.pointSize: Style.fontSizeSmall * scaling
      font.weight: Style.fontWeightBold
      anchors.verticalCenter: parent.verticalCenter
      verticalAlignment: Text.AlignVCenter
    }
  }
}

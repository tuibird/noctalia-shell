pragma Singleton

import Quickshell
import QtQuick
import qs.Services

Singleton {
  id: root

  property var date: new Date()
  property string time: Settings.data.location.use12HourClock ? Qt.formatDateTime(date, "h:mm AP") : Qt.formatDateTime(
                                                                  date, "HH:mm")
  readonly property string dateString: {
    let now = date
    let dayName = now.toLocaleDateString(Qt.locale(), "ddd")
    dayName = dayName.charAt(0).toUpperCase() + dayName.slice(1)
    let day = now.getDate()
    let suffix
    if (day > 3 && day < 21)
    suffix = 'th'
    else
    switch (day % 10) {
      case 1:
      suffix = "st"
      break
      case 2:
      suffix = "nd"
      break
      case 3:
      suffix = "rd"
      break
      default:
      suffix = "th"
    }
    let month = now.toLocaleDateString(Qt.locale(), "MMMM")
    let year = now.toLocaleDateString(Qt.locale(), "yyyy")
    return `${dayName}, `
    + (Settings.data.location.reverseDayMonth ? `${month} ${day}${suffix} ${year}` : `${day}${suffix} ${month} ${year}`)
  }

  // Returns a Unix Timestamp (in seconds)
  readonly property int timestamp: {
    return Math.floor(Date.now() / 1000)
  }

  // Format an easy to read approximate duration ex: 4h32m
  // Used to display the time remaining on the Battery widget
  function formatVagueHumanReadableDuration(totalSeconds) {
    const hours = Math.floor(totalSeconds / 3600)
    const minutes = Math.floor((totalSeconds - (hours * 3600)) / 60)
    const seconds = totalSeconds - (hours * 3600) - (minutes * 60)

    var str = ""
    if (hours) {
      str += hours.toString() + "h"
    }
    if (minutes) {
      str += minutes.toString() + "m"
    }
    if (!hours && !minutes) {
      str += seconds.toString() + "s"
    }
    return str
  }

  Timer {
    interval: 1000
    repeat: true
    running: true

    onTriggered: root.date = new Date()
  }
}

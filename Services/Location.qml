import QtQuick
import Quickshell
import Quickshell.Io
import qs.Services
pragma Singleton

// Weather logic and caching
Singleton {
  id: root

  property string locationFile: Quickshell.env("NOCTALIA_WEATHER_FILE") || (Settings.cacheDir + "location.json")
  property int weatherUpdateFrequency: 30 * 60 // 30 minutes expressed in seconds
  property var data: adapter // Used to access via Location.data.xxx.yyy

  FileView {
    path: locationFile
    watchChanges: true
    onFileChanged: reload()
    onAdapterUpdated: writeAdapter()
    Component.onCompleted: function () {
      reload()
    }
    onLoaded: function () {
      updateWeather()
    }
    onLoadFailed: function (error) {
      if (error.toString().includes("No such file") || error === 2) {
        // File doesn't exist, create it with default values
        writeAdapter()
      }
    }

    JsonAdapter {
      id: adapter

      property string latitude: ""
      property string longitude: ""
      property string weatherLastFetch: ""
      property var weather: null
    }
  }


  Timer {
    id: updateTimer
    interval: 60 * 1000
    repeat: true
    onTriggered: {
      updateWeather();
    }
  }

  // --------------------------------
  function init() {
    // does nothing but ensure the singleton is created
  }


  // --------------------------------
  function updateWeather() {
    if ((data.weatherLastFetch === "") || (Time.timestamp >= data.weatherLastFetch + weatherUpdateFrequency)) {
      getFreshWeather()
    }
  }

  // --------------------------------
  function getFreshWeather() {
    if (data.latitude === "" || data.longitude === "") {
      console.log("Geocoding location")
      _geocodeLocation(Settings.data.location.name, function (lat, lon) {
        console.log("Geocoded " + Settings.data.location.name + " to : " + lat + " / " + lon)

        // Save GPS coordinates
        data.latitude = lat
        data.longitude = lon

        _fetchWeather(data.latitude, data.longitude, errorCallback)
      }, errorCallback)
    } else {
      _fetchWeather(data.latitude, data.longitude, errorCallback)
    }
  }

  // --------------------------------
  function _geocodeLocation(locationName, callback, errorCallback) {
    var geoUrl = "https://geocoding-api.open-meteo.com/v1/search?name=" + encodeURIComponent(
          locationName) + "&language=en&format=json"
    var xhr = new XMLHttpRequest()
    xhr.onreadystatechange = function () {
      if (xhr.readyState === XMLHttpRequest.DONE) {
        if (xhr.status === 200) {
          try {
            var geoData = JSON.parse(xhr.responseText)
            if (geoData.results && geoData.results.length > 0) {
              callback(geoData.results[0].latitude, geoData.results[0].longitude)
            } else {
              errorCallback("Location not found.")
            }
          } catch (e) {
            errorCallback("Failed to parse geocoding data.")
          }
        } else {
          errorCallback("Geocoding error: " + xhr.status)
        }
      }
    }
    xhr.open("GET", geoUrl)
    xhr.send()
  }

  // --------------------------------
  function _fetchWeather(latitude, longitude, errorCallback) {
    var url = "https://api.open-meteo.com/v1/forecast?latitude=" + latitude + "&longitude=" + longitude
        + "&current_weather=true&current=relativehumidity_2m,surface_pressure&daily=temperature_2m_max,temperature_2m_min,weathercode&timezone=auto"
    var xhr = new XMLHttpRequest()
    xhr.onreadystatechange = function () {
      if (xhr.readyState === XMLHttpRequest.DONE) {
        if (xhr.status === 200) {
          try {
            var weatherData = JSON.parse(xhr.responseText)

            // Save to json
            data.weather = weatherData
            data.weatherLastFetch = Time.timestamp
            console.log("Cached weather to disk")
          } catch (e) {
            errorCallback("Failed to parse weather data.")
          }
        } else {
          errorCallback("Weather fetch error: " + xhr.status)
        }
      }
    }
    xhr.open("GET", url)
    xhr.send()
  }

    // --------------------------------
  function errorCallback(message) {
    console.error(message)
  }
}

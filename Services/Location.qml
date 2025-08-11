import QtQuick
import Quickshell
import Quickshell.Io
import qs.Services
pragma Singleton

// Weather logic and caching
Singleton {
  id: root

  property string locationFile: Quickshell.env("NOCTALIA_WEATHER_FILE") || (Settings.cacheDir + "location.json")

  // Used to access via Location.data.xxx.yyy
  property var data: adapter

  function quickstart() {
    console.log(locationFile)
  }

  FileView {
    path: locationFile
    watchChanges: true
    onFileChanged: reload()
    onAdapterUpdated: writeAdapter()
    Component.onCompleted: function () {
      reload()
    }
    onLoaded: function () {}
    onLoadFailed: function (error) {
      if (error.toString().includes("No such file") || error === 2)
        // File doesn't exist, create it with default values
        writeAdapter()
    }

    JsonAdapter {
      id: adapter

      // main
      property JsonObject main

      main: JsonObject {
        property string latitude: ""
        property string longitude: ""
        property int weatherLastFetched: 0
      }

      // weather
      property JsonObject weather

      weather: JsonObject {
      }
    }
  }

  // --------------------------------
  function getWeather() {
    if (data.main.latitude === "" || data.main.longitude === "") {
      geocodeLocation(Settings.data.location.name, function (lat, lon) {
        console.log(Settings.data.location.name + ": " + lat + " / " + lon);
      })
    }
  }

  // --------------------------------
  function geocodeLocation(locationName, callback, errorCallback) {
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
  function fetchWeather(latitude, longitude, callback, errorCallback) {
    var url = "https://api.open-meteo.com/v1/forecast?latitude=" + latitude + "&longitude=" + longitude
        + "&current_weather=true&current=relativehumidity_2m,surface_pressure&daily=temperature_2m_max,temperature_2m_min,weathercode&timezone=auto"
    var xhr = new XMLHttpRequest()
    xhr.onreadystatechange = function () {
      if (xhr.readyState === XMLHttpRequest.DONE) {
        if (xhr.status === 200) {
          try {
            var weatherData = JSON.parse(xhr.responseText)
            callback(weatherData)
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

  

  // function fetchCityWeather(city, callback, errorCallback) {
  //   fetchCoordinates(city, function (lat, lon) {
  //     fetchWeather(lat, lon, function (weatherData) {
  //       callback({
  //                  "city": city,
  //                  "latitude": lat,
  //                  "longitude": lon,
  //                  "weather": weatherData
  //                })
  //     }, errorCallback)
  //   }, errorCallback)
  // }
}

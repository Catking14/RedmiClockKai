import QtQuick 2.15
import QtQuick.Controls 2.15
import "../js/traductor.js" as Traduc
import "../js/GetInfoApi.js" as GetInfoApi
import "../js/geoCoordinates.js" as GeoCoordinates
import "../js/GetCity.js" as GetCity
import "../js/GetModelWeather.js" as GetModelWeather

Item {
  signal dataChanged // Define the signal here

  function obtener(texto, indice) {
    var palabras = texto.split(/\s+/); // Split the text into words using whitespace as separator
    return palabras[indice - 1]; // Index - 1 because indices start from 0 in JavaScript
  }

  function fahrenheit(temp) {
    if (temperatureUnit == 0) {
      return temp;
    } else {
      return Math.round((temp * 9 / 5) + 32);
    }
  }

  property string useCoordinatesIp: plasmoid.configuration.useCoordinatesIp
  property string latitudeC: plasmoid.configuration.latitudeC
  property string longitudeC: plasmoid.configuration.longitudeC
  property string temperatureUnit: plasmoid.configuration.temperatureUnit

  property string latitude: (useCoordinatesIp === "true") ? latitudeIP : (latitudeC === "0") ? latitudeIP : latitudeC
  property string longitud: (useCoordinatesIp === "true") ? longitudIP : (longitudeC === "0") ? longitudIP : longitudeC

  property var observerCoordenates: latitude + longitud

  property int currentTime: Number(Qt.formatDateTime(new Date(), "h"))

  property string datosweather: "0"
  property string forecastWeather: "0"  // Initialize forecast weather data
  property string twoMin: "0"  // Temperature minimum for tomorrow
  property string twoMax: "0"  // Temperature maximum for tomorrow
  property string threeMin: "0"  // Temperature minimum for day after tomorrow
  property string threeMax: "0"  // Temperature maximum for day after tomorrow
  property string fourMin: "0"  // Temperature minimum for 3 days later
  property string fourMax: "0"  // Temperature maximum for 3 days later
  property bool isWeatherLoaded: false  // check the weather is loaded or not


  property string day: (Qt.formatDateTime(new Date(), "yyyy-MM-dd"))
  property string therday: Qt.formatDateTime(new Date(new Date().getTime() + (numberOfDays * 24 * 60 * 60 * 1000)), "yyyy-MM-dd")
  property int numberOfDays: 6
  property string temperaturaActual: fahrenheit(obtener(datosweather, 1))
  property string localeFullName: Qt.locale().name
  property string codeleng: {
    var fullLocale = localeFullName;
    // check for zh_TW specifically
    if (fullLocale.indexOf("TW") !== -1) {
      return "zh-tw";
    }
    // otherwise, return first 2 characters for language code
    return fullLocale.substring(0, 2);
  }
  property string codeweather: obtener(datosweather, 4)
  property string codeweatherTomorrow: obtener(forecastWeather, 2)
  property string codeweatherDayAftertomorrow: obtener(forecastWeather, 3)
  property string codeweatherTwoDaysAfterTomorrow: obtener(forecastWeather, 4)
  property string minweatherCurrent: fahrenheit(obtener(datosweather, 2))
  property string maxweatherCurrent: fahrenheit(obtener(datosweather, 3))
  property string minweatherTomorrow: twoMin
  property string maxweatherTomorrow: twoMax
  property string minweatherDayAftertomorrow: threeMin
  property string maxweatherDayAftertomorrow: threeMax
  property string minweatherTwoDaysAfterTomorrow: fourMin
  property string maxweatherTwoDaysAfterTomorrow: fourMax
  property string iconWeatherCurrent: asingicon(codeweather)



  property string completeCoordinates: ""
  property string latitudeIP: {
    // Parse latitude from "lat, lon" format (e.g., "40.7128, -74.0060")
    var commaIndex = completeCoordinates.indexOf(',');
    if (commaIndex !== -1) {
      return completeCoordinates.substring(0, commaIndex).trim();
    }
    return "";
  }
  property string longitudIP: {
    // Parse longitude from "lat, lon" format
    var commaIndex = completeCoordinates.indexOf(',');
    if (commaIndex !== -1) {
      return completeCoordinates.substring(commaIndex + 1).trim();
    }
    return "";
  }

  property string city: ""  // Store the city name

  Component.onCompleted: {
    updateWeather(2);
  }


  function getCoordinatesWithIp() {
    GeoCoordinates.obtenerCoordenadas(function(result) {
      completeCoordinates = result;
    });
  }


  function getWeatherApi() {
    GetInfoApi.obtenerDatosClimaticos(latitude, longitud, day, currentTime, function(result) {
      datosweather = result;
      retry.start()
    });
  }

  function getCityFunction() {
    // Fetch city name using reverse geocoding
    if (latitude && longitud) {
      GetCity.getNameCity(latitude, longitud, codeleng, function(result) {
        city = result;
        console.log(`City name retrieved: ${result}`);
      });
    }
  }

  function asingicon(x, b) {
    let wmocodes = {
      0: "clear",
      1: "few-clouds",
      2: "few-clouds",
      3: "clouds",
      51: "showers-scattered",
      53: "showers-scattered",
      55: "showers-scattered",
      56: "showers-scattered",
      57: "showers-scattered",
      61: "showers",
      63: "showers",
      65: "showers",
      66: "showers-scattered",
      67: "showers",
      71: "snow-scattered",
      73: "snow",
      75: "snow",
      77: "hail",
      80: "showers",
      81: "showers",
      82: "showers",
      85: "snow-scattered",
      86: "snow",
      95: "storm",
      96: "storm",
      99: "storm",
    };
    var cicloOfDay = isday();
    var iconName = "weather-" + (wmocodes[x] || "unknown");
    var iconNamePresicion = cicloOfDay === "day" ? iconName : iconName + "-" + cicloOfDay;
    return b === "preciso" ? iconNamePresicion : iconName;
  }

  function isday() {
    var timeActual = Number(Qt.formatDateTime(new Date(), "h"));
    if (timeActual < 6) {
      if (timeActual > 19) {
        return "night";
      } else {
        return "day";
      }
    } else {
      return "day";
    }
  }

  function updateWeather(x) {
    if (x === 2) {
      if (useCoordinatesIp === "true") {
        getCoordinatesWithIp();
      } else {
        if (latitudeC === "0" || longitudC === "0") {
          getCoordinatesWithIp();
        }
      }
    }
    getWeatherApi();
  }

  Timer {
    id: retry
    interval: 5000
    running: false
    repeat: false
    onTriggered: {
      if (datosweather === "failed 0") {
        if (latitudeC === "0" || longitudC === "0") {
          getCoordinatesWithIp();
        }
        getWeatherApi();
      }
      else
      {
        isWeatherLoaded = true;  // mark the data is loaded
      }
      if (city === "") {
        getCityFunction();
      }
    }
  }

  onDatosweatherChanged: {
    checkDataReady()
  }

  function checkDataReady() {
    // Check if forecastWeather and datosweather are available
    if (forecastWeather !== "0" && datosweather !== "0") {
      dataChanged(); // Emit the dataChanged signal when data is ready
    }
  }

  Timer {
    id: weatherupdate
    interval: 900000
    running: true
    repeat: true
    onTriggered: {
      updateWeather(1);
    }
  }



  onObserverCoordenatesChanged: updateWeather(2)
}


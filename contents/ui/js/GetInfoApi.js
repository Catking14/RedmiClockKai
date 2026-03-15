function obtenerDatosClimaticos(latitud, longitud, fechaInicio, hours, callback) {
     // Ensure latitude and longitude are valid numbers
    if (!latitud || !longitud || isNaN(parseFloat(latitud)) || isNaN(parseFloat(longitud))) {
        console.error("Invalid latitude or longitude provided");
        callback("failed 0");
        return;
     }

     let url = `https://api.open-meteo.com/v1/forecast?latitude=${latitud}&longitude=${longitud}&current=temperature_2m,weather_code,wind_speed_10m&hourly=uv_index&daily=temperature_2m_max,temperature_2m_min,precipitation_probability_max&timezone=auto&start_date=${fechaInicio}&end_date=${fechaInicio}`;

     let req = new XMLHttpRequest();
     req.open("GET", url, true);

     console.error(`Fetching weather data for ${latitud}, ${longitud}`);

     req.onreadystatechange = function () {
         if (req.readyState === 4) {
             if (req.status === 200) {
                 try {
                     let datos = JSON.parse(req.responseText);
                     let currents = datos.current;
                     let temperaturaActual = currents.temperature_2m;
                     let windSpeed = currents.wind_speed_10m;
                     let codeCurrentWeather = currents.weather_code;

                     let datosDiarios = datos.daily;
                     let propabilityPrecipitationCurrent = datosDiarios.precipitation_probability_max[0];

                     let hourly = datos.hourly;
                     // Handle case where UV index is not available for the current hour
                     let propabilityUVindex = (hourly && hourly.uv_index && hourly.uv_index[hours]) ? hourly.uv_index[hours] : 0;

                     let tempMin = datosDiarios.temperature_2m_min[0];
                     let tempMax = datosDiarios.temperature_2m_max[0];

                     let full = temperaturaActual + " " + tempMin + " " + tempMax + " " + codeCurrentWeather + " " + propabilityPrecipitationCurrent + " " + windSpeed + " " + propabilityUVindex;
                     console.log(`Weather data retrieved: ${full}`);
                     callback(full);
                 } catch (e) {
                     console.error(`JSON parse error: ${e}`);
                     callback("failed 0");
                 }
             } else {
                 console.error(`Error in the applet: ${req.status}`);
                 callback("failed 0");
             }
         }
     };

     req.onerror = function() {
         console.error("Network error occurred");
         callback("failed 0");
     };

     req.send();
}


function obtenerCoordenadas(callback) {
    let url = "http://ip-api.com/json/?fields=lat,lon";

    let req = new XMLHttpRequest();
    req.open("GET", url, true);

    req.onreadystatechange = function () {
        if (req.readyState === 4) {
            if (req.status === 200) {
                try {
                    let datos = JSON.parse(req.responseText);
                    let latitud = datos.lat;
                    let longitud = datos.lon;
                    
                    // Validate coordinates are numbers
                    if (typeof latitud !== 'number' || typeof longitud !== 'number') {
                        console.error("Invalid coordinate types from API");
                        callback("0, 0");
                        return;
                    }
                    
                    let full = latitud + ", " + longitud;
                    console.log(`Coordinates retrieved: ${full}`);
                    callback(full);
                } catch (e) {
                    console.error(`JSON parse error in geoCoordinates: ${e}`);
                    callback("0, 0");
                }
            } else {
                console.error(`Error in the applet: ${req.status}`);
                callback("0, 0");
            }
        }
    };

    req.onerror = function() {
        console.error("Network error in geoCoordinates request");
        callback("0, 0");
    };

    req.send();
}

// SPDX-License-Identifier: GPL-3.0-or-later
// Forked from work by zayronxio (https://store.kde.org/p/2175475/)
// Modifications Copyright (C) 2026 Catking14

function getNameCity(latitude, longitud, lang, callback) {
    let url = `https://nominatim.openstreetmap.org/reverse?format=json&lat=${latitude}&lon=${longitud}&accept-language=${lang}`;

    let req = new XMLHttpRequest();
    req.open("GET", url, true);
    
    // Add User-Agent header as required by Nominatim API
    req.setRequestHeader("User-Agent", "RedmiClockKai/0.6.4 (KDE Plasma Widget)");

    req.onreadystatechange = function () {
        if (req.readyState === 4) {
            if (req.status === 200) {
                try {
                    let datos = JSON.parse(req.responseText);
                    let address = datos.address;
                    // Try to get city first, then county, then state/region
                    let cityName = address.city || address.county || address.state || address.region || "";
                    console.log(`[RedmiClockKai] City name retrieved: ${cityName}`);
                    callback(cityName);
                } catch (e) {
                    console.error(`[RedmiClockKai] JSON parse error in GetCity: ${e}`);
                    callback("");
                }
            } else {
                console.error(`[RedmiClockKai] Error in the city request: ${req.status}`);
                callback("");
            }
        }
    };

    req.onerror = function() {
        console.error("[RedmiClockKai] Network error in city request");
        callback("");
    };

    req.send();
}

# Redmi Clock Kai - KDE Plasma Widget

A clean and minimal clock widget for KDE Plasma inspired by Xiaomi Redmi phones. Displays current time, date, weather information, and location. This project is a fork from the "Redmi Clock" Widget created by *zayronxio* at https://store.kde.org/p/2175475/.

## Features

- 🕐 Real-time clock display
- 📅 Current date with day of week
- 🌤️ Current weather conditions with icons
- 📍 Automatic location detection via IP
- 🌡️ Temperature display (Celsius/Fahrenheit)
- 🌐 Multi-language support including Traditional Chinese (繁體中文)
- 🎨 Customizable color scheme
- 📱 Responsive design

## Project Structure

```
KDE_redmi_clock_kai/
├── metadata.json                    # Plugin metadata and configuration
├── README.md                        # This file
│
├── contents/
│   ├── config/
│   │   ├── config.qml             # Configuration UI
│   │   └── main.xml               # Configuration schema
│   │
│   ├── fonts/
│   │   └── Quicksand-Regular.otf  # Custom font
│   │
│   ├── images/                     # Weather and UI icons
│   │
│   └── ui/
│       ├── main.qml               # Main widget UI
│       ├── GeneralConfig.qml      # General settings panel
│       │
│       ├── components/
│       │   └── WeatherData.qml    # Weather data manager and API coordinator
│       │
│       └── js/
│           ├── GetInfoApi.js      # Open-Meteo API for weather data
│           ├── GetCity.js         # OpenStreetMap Nominatim for city names
│           ├── geoCoordinates.js  # IP geolocation via ip-api.com
│           ├── GetModelWeather.js # Extended weather forecast
│           ├── traductor.js       # Multi-language weather descriptions
│           ├── uiTranslator.js    # UI text translations
│           └── funcs.js           # Utility functions
```

## Installation

### Requirements

- KDE Plasma 6.0 or later
- `kpackagetool6` (provided by plasma-framework)
- Internet connection (for weather data and location services)

### Install kpackagetool6

On Debian/Ubuntu-based systems:
```bash
sudo apt install plasma-framework
```

On Fedora:
```bash
sudo dnf install plasma-framework
```

On Arch Linux:
```bash
sudo pacman -S plasma-framework
```

### Install the Widget

Navigate to the project directory:
```bash
cd /path/to/Redmi.Clock.Kai
```

**For first-time installation:**
```bash
kpackagetool6 --type Plasma/Applet --install .
```

**To upgrade after making changes:**
```bash
kpackagetool6 --type Plasma/Applet --upgrade .
```

> **Note:** You may see a DBus warning: `QDBusConnection: error: could not send signal... Invalid object path: /KPackage/`. This is a harmless warning and does **not** affect installation. Look for the success message: `已成功安裝` or `Successfully installed`.

**To uninstall:**

Option 1 - Using kpackagetool6 (without --type flag):
```bash
kpackagetool6 --type Plasma/Applet --remove Redmi.Clock.Kai
```

Option 2 - Direct removal (if Option 1 fails):
```bash
rm -rf ~/.local/share/plasma/plasmoids/Redmi.Clock.Kai/
```

Then restart Plasma to refresh the widget list:
```bash
plasmashell --replace &
```

> **Note:** If you see an error "KPackageStructure does not match requested format", use **Option 2** instead. This is a known issue with some KDE Plasma versions.

### Add to Desktop/Panel

1. Right-click on desktop or panel
2. Select "Add Widgets" or "Add to Panel"
3. Search for "Redmi Clock Kai"
4. Click and drag to desired location

## Preview & Development

### Install Required Tools

```bash
sudo apt install plasma-sdk
```

### Preview the Widget

From the project directory, run:

```bash
plasmoidviewer -a .
```

The widget will open in a preview window. The `plasmoidviewer` tool:
- Opens a standalone window displaying the widget
- Updates in real-time as you modify QML files
- Allows testing without installing to the system
- Useful for debugging and development

**Note:** Configuration changes in `plasmoidviewer` may not persist. For full testing, install the widget first.

### Monitor Logs

While running `plasmoidviewer`, monitor logs in another terminal:

```bash
journalctl --user -f | grep -E "plasma|qml|redmi"
```

Or check specific errors:

```bash
plasmoidviewer -a . 2>&1 | grep -E "Error|error|ReferenceError|TypeError"
```

## Configuration

Right-click the widget and select "Configure Redmi Clock" to access:

- **Color Scheme:** Customize the text color
- **Location:**
  - Auto-detect via IP address (default)
  - Manual entry of latitude and longitude
- **Temperature Unit:** Celsius or Fahrenheit
- **Font Size:** Adjust display size
- **Font Style:** Bold or regular

## Supported Languages

The widget includes weather translations for:
- English (en)
- Spanish (es)
- French (fr)
- German (de)
- Italian (it)
- Portuguese (pt)
- Russian (ru)
- Chinese - Simplified (zh)
- Chinese - Traditional (zh-tw) 🆕
- Japanese (ja)
- Korean (ko)
- Hindi (hi)
- Bengali (bn)
- Arabic (ar)
- Dutch (nl)
- And more...

## Data Sources

### Weather Data
- **Provider:** Open-Meteo API (https://open-meteo.com)
- **Features:** Current temperature, weather code, wind speed, UV index
- **No API Key:** Completely free and open

### Location Detection
- **IP Geolocation:** ip-api.com
- **City Names:** OpenStreetMap Nominatim API
- **User Privacy:** No tracking, processed locally

## Development Notes

### Key Components

**WeatherData.qml** - Central data manager
- Coordinates location via IP or manual input
- Fetches weather data from Open-Meteo
- Retrieves city name from Nominatim
- Manages data loading state

**GetInfoApi.js** - Weather API Interface
- Validates latitude/longitude
- Parses JSON responses
- Handles network errors

**GetCity.js** - Reverse Geocoding
- Converts coordinates to city names
- Sets User-Agent header for Nominatim compliance
- Fallback to "Unknown" on errors

**geoCoordinates.js** - IP Geolocation
- Fetches coordinates from IP address
- Validates numeric values
- Returns "0, 0" on failure

### API Rate Limits

- **Open-Meteo:** 10,000 requests/day (free)
- **Nominatim:** ~1 request/second (follow their Usage Policy)
- **ip-api.com:** 45 requests/minute (free tier)

Respect API terms of service. The widget includes reasonable delays to avoid rate limiting.

## Troubleshooting

### Widget Not Showing
1. Run `plasmoidviewer -a .` to test
2. Check terminal for errors: `journalctl --user -f`
3. Verify installation: `kpackagetool6 --list | grep redmi`

### No Weather Data
1. Check internet connection
2. Verify coordinates in settings (must be valid)
3. Check if IP geolocation is blocked
4. View logs: `plasmoidviewer -a . 2>&1`

### City Name Shows "Unknown"
1. Verify coordinates are correct
2. Check if location is valid in OpenStreetMap
3. Nominatim may not have data for all locations

### API Blocked Error
1. Ensure User-Agent header is set (it is by default)
2. Wait a few minutes if rate-limited
3. Check your IP isn't temporarily blocked

## Contributing

Contributions welcome! Areas for improvement:
- Additional language translations
- More weather data providers
- Enhanced UI customizations
- Performance optimizations

## License

GPL-3.0-or-later - See LICENSE file for details

## Author

- **Original:** zayronxio
- **Maintainer:** catking14
- **Upstream:** https://store.kde.org/p/2175475/
- **Fork Repository:** https://github.com/Catking14/RedmiClockKai

## Changelog

### v0.1.1
- Fix async API caused data undefined error
- Fix looped `onChanged` API calls
- Fix showing "Unknown" as city name when data not retrieved
- Renamed some spanish variables and functions

### v0.1.0
- Added Traditional Chinese (繁體中文) support
- Improved coordinate parsing with comma separation
- Enhanced error handling for all API calls
- Added User-Agent header for Nominatim API
- Fixed undefined variable initialization
- Added city name display on widget
- Improved weather loading state indication

## Support

For issues, suggestions, or questions:
1. Check this README first
2. Review error messages in `plasmoidviewer`
3. Report bugs with logs and system information

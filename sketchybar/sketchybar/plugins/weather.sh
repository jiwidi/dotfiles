#!/bin/bash

# Fetch weather data in JSON format
WEATHER_JSON=$(curl -s 'https://wttr.in/?format=j1')

# Check if the response is empty
if [ -z "$WEATHER_JSON" ]; then
  sketchybar --set weather label="Weather Unavailable"
else
  # Parse the JSON using jq
  TEMP=$(echo "$WEATHER_JSON" | jq -r '.current_condition[0].temp_C')
  WEATHER_DESC=$(echo "$WEATHER_JSON" | jq -r '.current_condition[0].weatherDesc[0].value')
  WIND_SPEED=$(echo "$WEATHER_JSON" | jq -r '.current_condition[0].windspeedKmph')
  WIND_DIR=$(echo "$WEATHER_JSON" | jq -r '.current_condition[0].winddir16Point')
  MAX_TEMP=$(echo "$WEATHER_JSON" | jq -r '.weather[0].maxtempC')
  MIN_TEMP=$(echo "$WEATHER_JSON" | jq -r '.weather[0].mintempC')

  # Remove any decimal points (if temperatures are not integers)
  MAX_TEMP="${MAX_TEMP%.*}"
  MIN_TEMP="${MIN_TEMP%.*}"

  # Create a fraction using the 'Fraction Slash' (U+2044)
  TEMP_RANGE="${MAX_TEMP}⁄${MIN_TEMP}"  # Note: This is a special fraction slash


  # Map weather descriptions to icons
  case "$WEATHER_DESC" in
    "Sunny")
      WEATHER_ICON="☀️"
      ;;
    "Clear")
      WEATHER_ICON="🌙"
      ;;
    "Partly cloudy")
      WEATHER_ICON="⛅️"
      ;;
    "Cloudy" | "Overcast")
      WEATHER_ICON="☁️"
      ;;
    "Light rain shower" | "Patchy rain possible" | "Patchy light rain" | "Light drizzle")
      WEATHER_ICON="🌦️"
      ;;
    "Moderate rain" | "Heavy rain")
      WEATHER_ICON="🌧️"
      ;;
    "Thunderstorm")
      WEATHER_ICON="⛈️"
      ;;
    "Snow" | "Light snow" | "Patchy light snow")
      WEATHER_ICON="❄️"
      ;;
    *)
      WEATHER_ICON="❓"
      ;;
  esac

  # Update SketchyBar with the compact weather info
  sketchybar --set weather label="${TEMP}° ${TEMP_RANGE} ${WIND_SPEED}km/h" \
                         icon="$WEATHER_ICON"
fi

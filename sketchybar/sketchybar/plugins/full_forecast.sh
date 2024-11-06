#!/bin/bash

# Fetch the full weather forecast from wttr.in
FULL_FORECAST=$(curl -s 'https://wttr.in/?format=3') # or try ?0 for detailed forecast

# Display the full forecast using a macOS notification
osascript -e "display notification \"$FULL_FORECAST\" with title \"Full Forecast\""

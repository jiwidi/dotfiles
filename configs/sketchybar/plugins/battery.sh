#!/usr/bin/env bash

# Battery indicator

BATTERY_INFO=$(pmset -g batt | grep -E "([0-9]+\%)")
PERCENTAGE=$(echo "$BATTERY_INFO" | grep -o '[0-9]*%' | head -1)
CHARGING=$(echo "$BATTERY_INFO" | grep -o "AC Power" > /dev/null && echo "true" || echo "false")

if [[ "$CHARGING" == "true" ]]; then
    ICON="󰂄"
else
    ICON="󰁹"
fi

sketchybar --set battery icon="$ICON" label="$PERCENTAGE"
#!/usr/bin/env bash

# WiFi indicator

WIFI_NETWORK=$(networksetup -getairportnetwork en0 | cut -d' ' -f4-)

if [[ "$WIFI_NETWORK" == "You are not associated with an AirPort network." ]]; then
    ICON="󰤭"
    LABEL="Disconnected"
else
    ICON="󰤨"
    LABEL="$WIFI_NETWORK"
fi

sketchybar --set wifi icon="$ICON" label="$LABEL"
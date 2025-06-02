#!/usr/bin/env bash

# Volume indicator

VOLUME=$(osascript -e 'output volume of (get volume settings)')
MUTED=$(osascript -e 'output muted of (get volume settings)')

if [[ "$MUTED" == "true" ]]; then
    ICON="󰖁"
    LABEL="Muted"
else
    ICON="󰕾"
    LABEL="$VOLUME%"
fi

sketchybar --set volume icon="$ICON" label="$LABEL"
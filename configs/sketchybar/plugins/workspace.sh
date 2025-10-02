#!/usr/bin/env bash

# Workspace indicator plugin
# Shows the current AeroSpace workspace number

# Get focused workspace from INFO variable passed by aerospace trigger
if [ -n "$INFO" ]; then
    WORKSPACE="$INFO"
else
    # Fallback: query aerospace directly (for initial load)
    WORKSPACE=$(aerospace list-workspaces --focused 2>/dev/null || echo "1")
fi

# Update the workspace indicator
sketchybar --set "$NAME" label="$WORKSPACE"

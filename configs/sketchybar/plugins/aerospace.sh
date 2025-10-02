#!/usr/bin/env bash

# AeroSpace workspace plugin for individual workspace items
# Called with workspace ID as argument

# Get focused workspace from sketchybar's INFO variable or query directly
if [ -n "$INFO" ]; then
    FOCUSED="$INFO"
else
    FOCUSED=$(aerospace list-workspaces --focused)
fi

# Check if workspace has windows or is focused
if [ "$1" = "$FOCUSED" ]; then
    sketchybar --set space."$1" drawing=on background.drawing=on icon.highlight=on
else
    # Check if workspace has windows
    if [ "$(aerospace list-windows --workspace "$1" | wc -l)" -gt 0 ]; then
        sketchybar --set space."$1" drawing=on background.drawing=off icon.highlight=off
    else
        sketchybar --set space."$1" drawing=off
    fi
fi
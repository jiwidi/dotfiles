#!/usr/bin/env bash

# AeroSpace workspace indicator

if command -v aerospace > /dev/null 2>&1; then
    WORKSPACE=$(aerospace list-workspaces --focused)
    sketchybar --set current_workspace label="󱂬 $WORKSPACE"
else
    sketchybar --set current_workspace label="󱂬 N/A"
fi
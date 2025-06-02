#!/usr/bin/env bash

# Front app indicator

FRONT_APP=$(osascript -e 'tell application "System Events" to return name of first process where frontmost is true')
sketchybar --set front_app label="$FRONT_APP"
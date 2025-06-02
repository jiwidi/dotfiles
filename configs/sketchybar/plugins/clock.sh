#!/usr/bin/env bash

# Clock plugin

DATETIME=$(date '+%a %m/%d %I:%M %p')
sketchybar --set clock label="$DATETIME"
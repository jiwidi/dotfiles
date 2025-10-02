#!/usr/bin/env bash

# AeroSpace workspace items
# This creates individual items for each workspace for better performance

PLUGIN_DIR="$CONFIG_DIR/plugins"

# Create individual workspace items (but hide them by default)
for sid in $(aerospace list-workspaces --all); do
    sketchybar --add event aerospace_workspace_change_"$sid"
    sketchybar --add item space."$sid" left \
        --subscribe space."$sid" aerospace_workspace_change_"$sid" \
        --set space."$sid" \
        background.color=0xff313244 \
        background.corner_radius=5 \
        background.height=24 \
        background.drawing=off \
        icon="$sid" \
        icon.color=0xffcad3f5 \
        icon.highlight_color=0xffed8796 \
        icon.padding_left=8 \
        icon.padding_right=8 \
        label.drawing=off \
        drawing=off \
        click_script="aerospace workspace $sid" \
        script="$PLUGIN_DIR/aerospace.sh $sid"
done

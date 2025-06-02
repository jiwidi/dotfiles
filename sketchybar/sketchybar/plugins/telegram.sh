#!/usr/bin/env sh

# Fetch the StatusLabel from Telegram
STATUS_OUTPUT=$(lsappinfo info -only StatusLabel "Telegram")

# Extract the "label" value from the output
STATUS_LABEL=$(echo "$STATUS_OUTPUT" | sed -n 's/.*"label"="\([^"]*\)".*/\1/p')

ICON=""
# Color white
ICON_COLOR="0xffffffff"
# Trim whitespace from STATUS_LABEL
LABEL=$(echo "$STATUS_LABEL" | xargs)

# Determine the icon color and label based on the status
if [ -z "$LABEL" ]; then
  LABEL="0"
elif [ "$LABEL" = "•" ]; then
  LABEL="0"  # Display '0' when there's a general notification
  # Color red
    ICON_COLOR="0xffff0000"
elif echo "$LABEL" | grep -q '^[0-9]\+$'; then
  # LABEL is already a number; no action needed
  # red
    ICON_COLOR="0xffff0000"
else
  # If LABEL is unexpected, try to parse it as a number
  UNREAD_COUNT=$(echo "$LABEL" | grep -o '[0-9]\+')
  if [ -n "$UNREAD_COUNT" ]; then
    LABEL="$UNREAD_COUNT"
  else
    LABEL="0"
  fi
fi

# Optimize space by adjusting padding and font size
sketchybar --set "$NAME" icon="$ICON" label=" $LABEL" icon.color="$ICON_COLOR" \
           label.padding_left=0 label.padding_right=2 icon.padding_left=0 icon.padding_right=0 \
           label.font="Helvetica Neue:Bold:10.0"

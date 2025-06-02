#!/usr/bin/env sh

# Fetch the StatusLabel from Slack, which often contains the notification count
STATUS_OUTPUT=$(lsappinfo info -only StatusLabel "Slack")

# Extract the "label" value from the output
STATUS_LABEL=$(echo "$STATUS_OUTPUT" | sed -n 's/.*"label"="\([^"]*\)".*/\1/p')

# Slack icon
ICON=""

# Trim whitespace from STATUS_LABEL
LABEL=$(echo "$STATUS_LABEL" | xargs)

# Determine the icon color and label based on the status
if [ -z "$LABEL" ]; then
  LABEL="0"
  ICON_COLOR="0xffa6da95"  # No notifications (green)
elif [ "$LABEL" = "•" ]; then
  ICON_COLOR="0xffeed49f"  # General notification indicator (yellow)
  LABEL="0"  # Display '0' when there's a general notification
elif [[ "$LABEL" =~ ^[0-9]+$ ]]; then
  ICON_COLOR="0xffed8796"  # Unread messages (red)
  # LABEL contains the number of notifications
else
  exit 0  # Exit if LABEL is unexpected
fi

sketchybar --set $NAME icon="$ICON" label="$LABEL" icon.color="$ICON_COLOR" \
           label.padding_left=0 label.padding_right=0 icon.padding_left=0 icon.padding_right=0 \
           label.font="Helvetica Neue:Bold:10.0"

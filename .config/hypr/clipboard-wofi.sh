#!/bin/bash

# Kill any existing wofi instance
pkill wofi || true

# Get clipboard entries
entries=$(cliphist list)

# Exit if no entries
if [ -z "$entries" ]; then
  notify-send "Clipboard" "No history" --expire-time 1000
  exit 0
fi

# Create temp files
id_file=$(mktemp)
trap "rm -f '$id_file'" EXIT

# Line 0 = CLEAR (for clear history option)
# Lines 1+ = cliphist IDs
{
  echo "CLEAR"
  echo "$entries" | awk -F'\t' '{print $1}'
} > "$id_file"

# Build clean display (no IDs visible)
display=$(
  echo "🗑️ Clear History"
  echo "$entries" | sed -E 's/^[0-9]+\t//'
)

# Show in wofi
selected=$(echo "$display" | wofi --dmenu --cache-file=/dev/null)

[ -z "$selected" ] && exit 0

# Handle clear history
if [ "$selected" = "🗑️ Clear History" ]; then
  cliphist wipe
  notify-send "Clipboard" "History cleared"
  exit 0
fi

# Find the line number by matching (first match wins for duplicates)
# Use awk for safer matching
line_num=$(echo "$display" | awk -v sel="$selected" '$0 == sel {print NR; exit}')

[ -z "$line_num" ] && exit 0

# Get corresponding ID
id=$(sed -n "${line_num}p" "$id_file")

if [ -n "$id" ] && [ "$id" != "CLEAR" ]; then
  cliphist decode "$id" | wl-copy
fi

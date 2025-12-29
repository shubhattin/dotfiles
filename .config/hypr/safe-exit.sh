#!/usr/bin/env bash

# Graceful Hyprland logout script
# - Politely asks all visible clients to close
# - Gives them a moment to shut down cleanly
# - Force-closes a few known problematic apps (like Cursor) if still running
# - Finally exits Hyprland

set -euo pipefail

# How long to wait (in seconds) after asking windows to close
GRACE_PERIOD="${GRACE_PERIOD:-3}"

# List of extra apps to make sure are dead before exiting Hyprland.
# Add / remove names here as needed.
APPS_TO_FORCE_CLOSE=(
  cursor
)

echo "[safe-exit] Requesting all Hyprland clients to close..."

if command -v hyprctl > /dev/null 2>&1; then
  if command -v jq > /dev/null 2>&1; then
    # Ask every client known to Hyprland to close gracefully
    hyprctl -j clients | jq -r '.[].address' | while read -r addr; do
      [ -n "$addr" ] || continue
      hyprctl dispatch closewindow "address:$addr" 2> /dev/null || true
    done
  else
    echo "[safe-exit] Warning: jq not found, falling back to killactive loop."
    # Fallback: just loop killactive a bunch of times
    for _ in $(seq 1 20); do
      hyprctl dispatch killactive 2> /dev/null || break
      sleep 0.1
    done
  fi
else
  echo "[safe-exit] hyprctl not found; nothing to do."
fi

echo "[safe-exit] Waiting ${GRACE_PERIOD}s for apps to shut down..."
sleep "$GRACE_PERIOD"

echo "[safe-exit] Force-closing selected apps (if still running)..."
for app in "${APPS_TO_FORCE_CLOSE[@]}"; do
  # Try a polite TERM first
  pkill -TERM "$app" 2> /dev/null || true
done

sleep 1

for app in "${APPS_TO_FORCE_CLOSE[@]}"; do
  # If anything is still hanging, send KILL
  pkill -KILL "$app" 2> /dev/null || true
done

echo "[safe-exit] Exiting Hyprland..."
hyprctl dispatch exit 0

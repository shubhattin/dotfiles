#!/usr/bin/env bash

set -euo pipefail

# Newer hypridle/hyprlock combinations can miss a manual suspend if we jump
# straight to systemctl suspend. Trigger the lock explicitly, then suspend.
loginctl lock-session

if ! pidof hyprlock >/dev/null; then
  hyprlock >/dev/null 2>&1 &

  for _ in {1..20}; do
    if pidof hyprlock >/dev/null; then
      break
    fi

    sleep 0.1
  done
fi

systemctl suspend

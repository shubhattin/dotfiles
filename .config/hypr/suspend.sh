#!/usr/bin/env bash

set -euo pipefail

# Newer hypridle/hyprlock combinations can miss a manual suspend if we jump
# straight to systemctl suspend. Start hyprlock directly, then suspend.
if ! pidof hyprlock >/dev/null; then
  hyprlock --grace 0 >/dev/null 2>&1 &
fi

for _ in {1..20}; do
  if pidof hyprlock >/dev/null; then
    break
  fi

  sleep 0.1
done

systemctl suspend

#!/usr/bin/env bash

# Simple power menu for Hyprland using wofi
# Options:
# - Sleep
# - Shutdown
# - Restart
# - Logout (exit Hyprland)
# - Hibernate

choice="$(printf '%s\n' \
  '󰒲  Sleep' \
  '󰐥  Shutdown' \
  '󰜉  Restart' \
  '󰍃  Logout' \
  '󰒳  Hibernate' \
  | wofi --dmenu --prompt 'Power menu')"

case "$choice" in
  '󰒲  Sleep')
    systemctl suspend
    ;;
  '󰐥  Shutdown')
    systemctl poweroff
    ;;
  '󰜉  Restart')
    systemctl reboot
    ;;
  '󰍃  Logout')
    hyprctl dispatch exit 0
    ;;
  '󰒳  Hibernate')
    systemctl hibernate
    ;;
  *)
    # Cancelled or closed
    exit 0
    ;;
esac



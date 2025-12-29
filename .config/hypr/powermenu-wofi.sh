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
  | wofi --dmenu --cache-file=/dev/null --prompt 'Power menu')"

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
    bash -c '~/.config/hypr/safe-exit.sh'
    ;;
  '󰒳  Hibernate')
    systemctl hibernate
    ;;
  *)
    # Cancelled or closed
    exit 0
    ;;
esac

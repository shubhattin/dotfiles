#!/usr/bin/env bash
# Hyprland is not a full DE, so systemd's graphical-session.target stays inactive
# and xdg-desktop-portal never auto-starts. Screen share (Meet, Zoom, etc.) needs it.

dbus-update-activation-environment --systemd \
  DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_DESKTOP

start_portal() {
  local bin="/usr/lib/$1"
  if ! pgrep -f "${bin}\$" >/dev/null 2>&1; then
    "${bin}" &
  fi
}

start_portal xdg-desktop-portal-hyprland
sleep 0.2
start_portal xdg-desktop-portal-gtk
sleep 0.2
start_portal xdg-desktop-portal

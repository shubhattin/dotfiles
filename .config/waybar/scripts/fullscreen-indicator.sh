#!/usr/bin/env bash
set -euo pipefail

# Hyprland reports fullscreen modes via `hyprctl activewindow -j`:
# - fullscreen == 0 : not fullscreen
# - fullscreen == 1 : "fullscreen, 1" (your SUPER_SHIFT+F - maximized with waybar visible)
# - fullscreen == 2 : "fullscreen" (your SUPER+F - true fullscreen)
# - fullscreen == 3 : "fullscreenstate 4" (your SUPER_ALT+F; bars/spacing hidden)

win_json="$(hyprctl activewindow -j)"
fs="$(jq -r '.fullscreen // 0' <<<"$win_json")"

if [[ "$fs" == "1" ]]; then
    # Return JSON for Waybar custom module (return-type: json)
    # Include a plain-text fallback ("FS") in case the icon glyph is missing.
    printf '%s\n' '{"text":"󰊓","tooltip":"Maximized fullscreen (waybar visible)","class":"fs-maximized"}'
else
    # When not in exclusive fullscreen, output an empty widget.
    # (We also gate visibility using exec-if in the Waybar config.)
    printf '%s\n' '{"text":"","class":"fs-none"}'
fi



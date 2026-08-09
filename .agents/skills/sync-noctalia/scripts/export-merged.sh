#!/usr/bin/env bash
# Export live Noctalia config for manual/agent review before promoting into
# ~/.dotfiles/.config/noctalia. Does not modify repo files.
set -euo pipefail

OUT="${NOCTALIA_SYNC_DIR:-/tmp/noctalia-sync}"
mkdir -p "$OUT"

echo "==> Exporting merged → $OUT/merged.toml"
noctalia config export merged > "$OUT/merged.toml"

echo "==> Exporting full → $OUT/full.toml"
noctalia config export full > "$OUT/full.toml"

SETTINGS="${XDG_STATE_HOME:-$HOME/.local/state}/noctalia/settings.toml"
if [[ -f "$SETTINGS" ]]; then
  cp -f "$SETTINGS" "$OUT/settings.toml"
  echo "==> Copied settings.toml → $OUT/settings.toml"
else
  echo "==> No settings.toml at $SETTINGS"
fi

echo
echo "==> High-signal live values:"
python3 - <<'PY'
import tomllib, pathlib
m = tomllib.loads(pathlib.Path("/tmp/noctalia-sync/merged.toml").read_text())
theme = m.get("theme", {})
wp = m.get("wallpaper", {})
ls = m.get("lockscreen", {})
widgets = (m.get("lockscreen_widgets") or {}).get("widget") or {}
print(f"  theme.source={theme.get('source')} builtin={theme.get('builtin')} custom={theme.get('custom_palette')}")
default = (wp.get("default") or {}).get("path")
print(f"  wallpaper.default={default}")
print(f"  lockscreen.blur_intensity={ls.get('blur_intensity')} wallpaper={ls.get('wallpaper')}")
for name, w in widgets.items():
    if w.get("type") == "login_box":
        s = w.get("settings") or {}
        print(f"  {name}: show_media={s.get('show_media')} show_session_buttons={s.get('show_session_buttons')}")
    if w.get("type") == "media_player":
        print(f"  WARN media_player widget present: {name}")
PY

echo
echo "Next: promote durable deltas into ~/.dotfiles/.config/noctalia/*.toml,"
echo "prune matching keys from settings.toml, then:"
echo "  noctalia config validate ~/.config/noctalia && noctalia msg config-reload"

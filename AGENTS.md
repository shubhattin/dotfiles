# Agent notes — Noctalia / Hyprland dotfiles

## Skills

| Skill | Invoke | Purpose |
|-------|--------|---------|
| `sync-noctalia` | `/sync-noctalia` | Promote live Noctalia GUI/runtime overrides into split `~/.config/noctalia` files in this repo, then prune `~/.local/state/noctalia/settings.toml`. |

Skill path: `.agents/skills/sync-noctalia/SKILL.md`  
Also linked from `~/.agents/skills/sync-noctalia` for personal agent discovery.

## Noctalia config model

- Declarative config: `~/.config/noctalia` (symlink into this repo).
- Runtime/GUI overrides: `~/.local/state/noctalia/settings.toml` (wins when present).
- After GUI tweaks, run `/sync-noctalia` so the repo stays source of truth.
- Desktop wallpaper selection (`wallpaper.default` / `.last` / `.monitors.*`) is
  app-managed state in `settings.toml` — do not prune it during sync, or the
  desktop wallpaper layers go blank (lockscreen wallpaper is separate).

## Lockscreen policy

- No now-playing media on the lock screen (`login_box` → `show_media = false`).
- Keep sleep/suspend session controls (`show_session_buttons = true` + sleep labels).

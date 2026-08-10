---
name: sync-noctalia
description: >-
  Sync Noctalia live/runtime config into the split declarative files in this
  dotfiles repo. Use when the user runs /sync-noctalia, asks to sync Noctalia
  settings from memory/GUI/settings.toml into ~/.config/noctalia, or when
  theme/wallpaper/lockscreen/bar prefs in ~/.local/state/noctalia have diverged
  from the repo.
disable-model-invocation: true
---

# Sync Noctalia

Promote live Noctalia prefs into the split TOML config tracked by this repo,
then prune redundant runtime overrides so the repo stays the source of truth.

## Paths

| Role | Path |
|------|------|
| Repo / live config (symlink) | `~/.config/noctalia` → `~/.dotfiles/.config/noctalia` |
| Runtime overrides (win over config) | `~/.local/state/noctalia/settings.toml` |
| Entry include list | `~/.config/noctalia/config.toml` |

Split files from `[include].files`: `theme.toml`, `shell.toml`, `bar.toml`,
`dock.toml`, `services.toml`, `wallpaper.toml`, `idle.toml`, `lockscreen.toml`,
`plugins.toml`.

## Workflow

Copy this checklist and track progress:

```
Sync Progress:
- [ ] 1. Export live merged config
- [ ] 2. Diff against split repo files
- [ ] 3. Promote durable prefs into the matching *.toml
- [ ] 4. Apply lockscreen media policy
- [ ] 5. Prune matching keys from settings.toml
- [ ] 6. Validate + reload
- [ ] 7. Summarize what changed
```

### 1. Export live merged config

```bash
mkdir -p /tmp/noctalia-sync
noctalia config export merged > /tmp/noctalia-sync/merged.toml
# optional: full defaults+user
noctalia config export full > /tmp/noctalia-sync/full.toml
```

Also read `~/.local/state/noctalia/settings.toml` — those keys **override**
`~/.config/noctalia/*.toml` and are usually what the GUI wrote.

### 2. Diff against split repo files

Compare merged sections to the matching split file. Typical high-signal keys:

- `[theme]` → `theme.toml` (`source`, `builtin`, `custom_palette`, `mode`)
- `[wallpaper]` (fill/directory/automation) → `wallpaper.toml`
- `[lockscreen]` + `[lockscreen_widgets]` → `lockscreen.toml`
- `[bar]` + `[widget.*]` that belong on the bar → `bar.toml`
- `[plugins]` → `plugins.toml`
- `[shell]` / `[osd]` / session → `shell.toml`
- `[idle]` → `idle.toml`
- `[dock]` → `dock.toml`

Do **not** blindly dump the entire merged tree into one file. Keep the split
layout from `config.toml`.

**Wallpaper selection is app-managed state.** Noctalia loads
`wallpaper.default` / `wallpaper.last` / `wallpaper.monitors.*` only from
`~/.local/state/noctalia/settings.toml` (via `extractWallpaperFromOverrides`).
Mirroring those paths in `wallpaper.toml` is fine for recovery/docs, but
pruning them from `settings.toml` blanks the desktop wallpaper layers while
`lockscreen.wallpaper` (a real setting) still works. If desktop wallpaper is
missing, re-seed with:

```bash
noctalia msg wallpaper-set ~/.config/backgrounds/dark/dark-starry-sky.jpg
```

### 3. Promote durable prefs

Update only the split files that actually diverged. Preserve existing comments
and local intentional prefs unless the live state clearly replaced them.

After editing, run:

```bash
noctalia config validate ~/.config/noctalia
```

Fix unknown/deprecated keys reported by validate (for example
`show_password_hint` on `login_box` is deprecated).

### 4. Lockscreen media policy (repo default)

This setup does **not** want the now-playing media indicator on the lock
screen. Sleep / suspend session controls stay.

Enforce when syncing `lockscreen.toml`:

1. Do **not** add `type = "media_player"` widgets under `[lockscreen_widgets]`.
2. On every `login_box` widget settings block, set:

```toml
show_media = false
show_session_buttons = true
```

3. Keep existing sleep/suspend **label** widgets (for example
   `lockscreen-sleep@*`) unless the user asks to remove them.

### 5. Prune `settings.toml`

After promoting keys into `~/.config/noctalia`, remove the same keys from
`~/.local/state/noctalia/settings.toml` so overrides stop winning.

**Never prune** these wallpaper selection keys from `settings.toml`:

- `wallpaper.default`
- `wallpaper.last`
- `wallpaper.monitors.*`
- `wallpaper.favorite` (if present)

If everything else durable is in config, a healthy minimal state file looks like:

```toml
config_version = 12

[wallpaper.default]
path = "~/.config/backgrounds/dark/dark-starry-sky.jpg"

[wallpaper.last]
path = "~/.config/backgrounds/dark/dark-starry-sky.jpg"

[wallpaper.monitors.eDP-1]
path = "~/.config/backgrounds/dark/dark-starry-sky.jpg"

[wallpaper.monitors.DP-1]
path = "~/.config/backgrounds/dark/dark-starry-sky.jpg"
```

Prefer `~/...` paths for portability across usernames. Noctalia expands them on
load (`FileUtils::expandUserPath`). Note: `noctalia msg wallpaper-set` may
rewrite absolute paths into `settings.toml`; convert back to `~/` when syncing
if you want the portable form.

(Keep `config_version` and monitor names in sync with whatever Noctalia last wrote.)

Never delete secrets or unrelated state files under `~/.local/state/noctalia/`
other than pruning redundant keys in `settings.toml`.

### 6. Validate + reload

```bash
noctalia config validate ~/.config/noctalia
noctalia msg config-reload
```

Optionally re-export merged and confirm theme/wallpaper/lockscreen match the
repo, and that login_box has `show_media = false`.

### 7. Summarize

Tell the user:

- which split files changed
- what was pruned from `settings.toml`
- whether validate/reload succeeded
- remind that GUI changes will rewrite `settings.toml` again until the next sync

## Helper script

Optional one-shot export + summary (does not auto-write repo files):

```bash
bash ~/.dotfiles/.agents/skills/sync-noctalia/scripts/export-merged.sh
```

Agents still perform the promote/prune edits deliberately after reviewing the
diff — do not auto-overwrite split files without checking.

## Invocation examples

- `/sync-noctalia`
- "Sync Noctalia settings from the GUI into the repo"
- "settings.toml diverged from .config/noctalia — sync theme/wallpaper"

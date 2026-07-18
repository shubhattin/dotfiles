-- Hyprland Lua config (v0.55+)
-- Migrated from hyprland.conf and reviewed against /usr/share/hypr/hyprland.lua
-- https://wiki.hypr.land/Configuring/Start/

---@module 'hl'

------------------
---- MONITORS ----
------------------

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

hl.monitor({
    output   = "eDP-1",
    mode     = "preferred",
    position = "auto",
    scale    = 1.25,
})

hl.monitor({
    output   = "DP-1",
    mode     = "1920x1080@75",
    position = "auto-left",
    scale    = 1,
})


---------------------
---- MY PROGRAMS ----
---------------------

local terminal     = "ghostty"
local terminal1    = "alacritty"
local fileManager  = "dolphin"
local fileManager1 = "nautilus"
local menu         = "noctalia msg panel-toggle launcher"
local noctalia     = "noctalia msg"
local mainMod      = "SUPER"


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("HYPRSHOT_DIR", (os.getenv("HOME") or "") .. "/Pictures/Screenshots")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("XDG_MENU_PREFIX", "arch-")


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    xwayland = {
        force_zero_scaling = true,
    },

    general = {
        gaps_in  = 2,
        gaps_out = 6,
        border_size = 1,
        col = {
            active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
        resize_on_border = false,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },
        blur = {
            enabled  = true,
            size     = 3,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true, -- was: "yes, please :)"
    },

    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
    },

    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",
        follow_mouse = 1,
        sensitivity  = 0,
        touchpad = {
            natural_scroll = true,
        },
    },
})

-- Curves + animations (hyprconf2lua dropped these)
hl.curve("easeOutQuint",   { type = "bezier", points = { { 0.23, 1 },  { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear",         { type = "bezier", points = { { 0, 0 },     { 1, 1 } } })
hl.curve("almostLinear",   { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick",          { type = "bezier", points = { { 0.15, 0 },  { 0.1, 1 } } })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick" })

-- Noctalia layer surfaces
hl.layer_rule({
    name = "noctalia-surfaces",
    match = {
        namespace = "^(noctalia-(bar-.+|notification|dock|panel|attached-panel|osd))$",
    },
    blur         = true,
    blur_popups  = true,
    no_anim      = true,
    ignore_alpha = 0.5,
})

hl.window_rule({
    name = "noctalia-settings",
    match = {
        class = "^(dev.noctalia.Noctalia)$",
    },
    float  = true,
    size   = { 1080, 920 },
    center = true,
})

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})

-- Example per-device config (unused unless device exists)
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})


---------------------
---- KEYBINDINGS ----
---------------------

hl.bind(mainMod .. " + T",      hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind("SHIFT + ALT + T",      hl.dsp.exec_cmd(terminal1))
hl.bind(mainMod .. " + B",      hl.dsp.exec_cmd("zen-browser"))
hl.bind(mainMod .. " + Q",      hl.dsp.window.close())
hl.bind("ALT + F4",             hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd("bash -c '~/.config/hypr/safe-exit.sh'"), { locked = true })
hl.bind(mainMod .. " + E",      hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + W",      hl.dsp.exec_cmd(fileManager1))
hl.bind(mainMod .. " + CTRL + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R",      hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P",      hl.dsp.window.pseudo())
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.layout("togglesplit"))

-- Move focus
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + j",     hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + k",     hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + l",     hl.dsp.focus({ direction = "right" }))

-- Workspaces 1-10
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,           hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,   hl.dsp.window.move({ workspace = i }))
    hl.bind(mainMod .. " + ALT + " .. key,     hl.dsp.window.move({ workspace = i, follow = false }))
end

-- Resize panes (was resizeactive / binde)
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize({ x = 10,  y = 0,  relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.resize({ x = -10, y = 0,  relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.resize({ x = 0,   y = -10, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.resize({ x = 0,   y = 10,  relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + l",     hl.dsp.window.resize({ x = 10,  y = 0,  relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + h",     hl.dsp.window.resize({ x = -10, y = 0,  relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + k",     hl.dsp.window.resize({ x = 0,   y = -10, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + j",     hl.dsp.window.resize({ x = 0,   y = 10,  relative = true }), { repeating = true })

-- Move workspace to another monitor (was movecurrentworkspacetomonitor)
hl.bind("CTRL + " .. mainMod .. " + SHIFT + left",  hl.dsp.workspace.move({ monitor = "l" }))
hl.bind("CTRL + " .. mainMod .. " + SHIFT + right", hl.dsp.workspace.move({ monitor = "r" }))

-- Special workspace
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Mouse move/resize
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia — Noctalia OSD (bindel → locked + repeating)
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd(noctalia .. " volume-up 3"),          { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd(noctalia .. " volume-down 3"),        { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd(noctalia .. " volume-mute"),          { locked = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd(noctalia .. " mic-mute"),             { locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd(noctalia .. " brightness-up eDP-1"),  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(noctalia .. " brightness-down eDP-1"),{ locked = true, repeating = true })

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Laptop / external brightness
hl.bind("ALT + F10",  hl.dsp.exec_cmd(noctalia .. " brightness-up eDP-1"),   { locked = true, repeating = true })
hl.bind("ALT + F9",   hl.dsp.exec_cmd(noctalia .. " brightness-down eDP-1"), { locked = true, repeating = true })
hl.bind("ALT_R + F10", hl.dsp.exec_cmd(noctalia .. " brightness-up eDP-1"),   { locked = true, repeating = true })
hl.bind("ALT_R + F9",  hl.dsp.exec_cmd(noctalia .. " brightness-down eDP-1"), { locked = true, repeating = true })
hl.bind("ALT + F12",  hl.dsp.exec_cmd("~/.local/bin/daitika up 8 --external"),   { locked = true, repeating = true })
hl.bind("ALT + F11",  hl.dsp.exec_cmd("~/.local/bin/daitika down 8 --external"), { locked = true, repeating = true })
hl.bind("ALT_R + F12", hl.dsp.exec_cmd("~/.local/bin/daitika up 8 --external"),   { locked = true, repeating = true })
hl.bind("ALT_R + F11", hl.dsp.exec_cmd("~/.local/bin/daitika down 8 --external"), { locked = true, repeating = true })

-- Fullscreen (SUPER_SHIFT-style mods → SUPER + SHIFT)
hl.bind("SUPER + F",       hl.dsp.window.fullscreen())
hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind("SUPER + CTRL + F",  hl.dsp.window.fullscreen_state({ internal = 3, client = 3 }))
hl.bind("SUPER + ALT + F",   hl.dsp.window.fullscreen_state({ internal = 3, client = 3 }))

hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd(noctalia .. " config-reload"))

-- App shortcuts
hl.bind("CTRL + ALT + F2", hl.dsp.exec_cmd("zen-browser"))
hl.bind("CTRL + ALT + F3", hl.dsp.exec_cmd("zen-browser --private-window"))
hl.bind("SHIFT + ALT + V", hl.dsp.exec_cmd("cursor"))
hl.bind("SHIFT + ALT + C", hl.dsp.exec_cmd("code"))
hl.bind("CTRL + ALT + B",  hl.dsp.exec_cmd("helium-browser --password-store=basic"))
hl.bind("CTRL + ALT + I",  hl.dsp.exec_cmd("brave --password-store=basic"))
hl.bind("CTRL + ALT + O",  hl.dsp.exec_cmd("helium-browser --password-store=basic --incognito"))

-- Noctalia panels / session
hl.bind("SUPER + V",           hl.dsp.exec_cmd(noctalia .. " panel-toggle clipboard"))
-- SUPER + SPACE: conflicts with fcitx (same action as SUPER + R launcher)
-- hl.bind("SUPER + SPACE",       hl.dsp.exec_cmd(noctalia .. " panel-toggle launcher"))
hl.bind("SUPER + SHIFT + C",   hl.dsp.exec_cmd(noctalia .. " panel-toggle control-center"))
hl.bind("SUPER + comma",       hl.dsp.exec_cmd(noctalia .. " settings-toggle"))
hl.bind("SUPER + SHIFT + slash", hl.dsp.exec_cmd(noctalia .. " panel-toggle shubhattin/keybind_help:help"))
hl.bind(mainMod .. " + L",     hl.dsp.exec_cmd(noctalia .. " session lock"))
hl.bind("CTRL + ALT + DELETE", hl.dsp.exec_cmd(noctalia .. " panel-toggle session"))
hl.bind(mainMod .. " + SHIFT + F7", hl.dsp.exec_cmd(noctalia .. " session lock-and-suspend"), { locked = true })

-- Screenshots
hl.bind(mainMod .. " + SHIFT + Print", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind(mainMod .. " + Print",         hl.dsp.exec_cmd("hyprshot -m output"))
hl.bind(mainMod .. " + CTRL + Print",  hl.dsp.exec_cmd("hyprshot -m window"))


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprctl setcursor catppuccin-mocha-dark-cursors 28")
    hl.exec_cmd("bash ~/.config/hypr/noctalia-wrap.sh")
    hl.exec_cmd("bash ~/.config/hypr/start-portals.sh")
    hl.exec_cmd("dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_DESKTOP")
    hl.exec_cmd("fcitx5 -d")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
end)

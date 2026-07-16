--!nonstrict
-- Floating cheatsheet of the main compositor / shell shortcuts.
-- Toggle with: noctalia msg panel-toggle shubhattin/keybind_help:help

local function bind_row(keys, desc)
	return ui.row({ gap = 14, align = "center" }, {
		ui.label({
			text = keys,
			fontFamily = "JetBrainsMono Nerd Font",
			fontWeight = "bold",
			fontSize = 12,
			color = "primary",
			width = 250,
		}),
		ui.label({
			text = desc,
			fontSize = 12,
			color = "on_surface",
			flexGrow = 1,
		}),
	})
end

local function section(title, rows)
	local children = {
		ui.label({
			text = title,
			fontSize = 13,
			fontWeight = "bold",
			color = "secondary",
		}),
	}
	for _, row in ipairs(rows) do
		table.insert(children, row)
	end
	return ui.column({
		gap = 5,
		padding = 12,
		radius = 10,
		fill = "surface_variant/0.45",
	}, children)
end

local function render()
	panel.render(ui.column({ flexGrow = 1, gap = 12 }, {
		ui.row({ align = "center", justify = "space_between", gap = 8 }, {
			ui.column({ gap = 2, flexGrow = 1 }, {
				ui.label({
					text = "Keyboard Shortcuts",
					fontSize = 18,
					fontWeight = "bold",
					color = "on_surface",
				}),
				ui.label({
					text = "Super + Shift + /  ·  Esc to close",
					fontSize = 11,
					color = "on_surface_variant",
				}),
			}),
			ui.button({ glyph = "close", variant = "ghost", onClick = "onCloseClicked" }),
		}),

		ui.scroll({ flexGrow = 1, gap = 12 }, {
			section("Shell & session", {
				bind_row("Super + V", "Clipboard history"),
				bind_row("Super + Shift + C", "Control center"),
				bind_row("Super + ,", "Noctalia settings"),
				bind_row("Super + L", "Lock screen"),
				bind_row("Ctrl + Alt + Delete", "Session menu"),
				bind_row("Super + Shift + F7", "Lock and suspend"),
				bind_row("Super + Shift + M", "Logout (safe exit)"),
				bind_row("Super + Shift + W", "Reload Noctalia config"),
				bind_row("Super + Shift + /", "This help overlay"),
			}),

			section("Workspaces", {
				bind_row("Super + 1 … 0", "Switch workspace 1–10"),
				bind_row("Super + Shift + 1 … 0", "Move window to workspace"),
				bind_row("Super + Alt + 1 … 0", "Move window silently"),
				bind_row("Super + Shift + S", "Send window to hidden workspace"),
				bind_row("Super + Scroll", "Cycle workspaces"),
			}),

			section("Focus, move & resize", {
				bind_row("Super + ←↑↓→ / JKL", "Move focus"),
				bind_row("Super + Shift + ←↑↓→ / HJKL", "Resize active window"),
				bind_row("Super + LMB / RMB", "Move / resize with mouse"),
				bind_row("Ctrl + Super + Shift + ←→", "Move workspace to monitor"),
			}),

			section("Fullscreen", {
				bind_row("Super + F", "True fullscreen"),
				bind_row("Super + Shift + F", "Maximized (bar stays)"),
				bind_row("Super + Ctrl/Alt + F", "Fullscreen (hide bars)"),
			}),

			section("Media, brightness & capture", {
				bind_row("Media keys", "Volume / mute / mic / playback"),
				bind_row("Alt + F9 / F10", "Laptop brightness down / up"),
				bind_row("Alt + F11 / F12", "External brightness down / up"),
				bind_row("Super + Print", "Screenshot monitor"),
				bind_row("Super + Shift + Print", "Screenshot region"),
				bind_row("Super + Ctrl + Print", "Screenshot window"),
			}),

			section("Apps & windows", {
				bind_row("Super + T / Enter", "Open terminal (Ghostty)"),
				bind_row("Shift + Alt + T", "Open alternate terminal"),
				bind_row("Super + B", "Open Zen browser"),
				bind_row("Super + E / W", "Open file manager"),
				bind_row("Super + R / Space", "App launcher"),
				bind_row("Super + Q / Alt + F4", "Close active window"),
				bind_row("Super + Ctrl + V", "Toggle floating"),
				bind_row("Super + P", "Dwindle pseudo"),
				bind_row("Super + Shift + J", "Toggle dwindle split"),
			}),

			section("Quick apps", {
				bind_row("Ctrl + Alt + F2 / F3", "Zen / Zen private"),
				bind_row("Shift + Alt + V / C", "Cursor / VS Code"),
				bind_row("Ctrl + Alt + B / O", "Helium / Helium incognito"),
				bind_row("Ctrl + Alt + I", "Brave"),
			}),
		}),
	}))
end

function onOpen(_context)
	render()
end

function onCloseClicked()
	panel.close()
end

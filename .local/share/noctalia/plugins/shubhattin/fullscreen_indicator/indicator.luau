--!nonstrict
-- Show an icon when Hyprland fullscreen mode is maximized (1):
-- SUPER+SHIFT+F — window fills the work area, bar stays reserved.
-- True fullscreen (2) hides the bar, so no indicator is shown.

local pending = false

local function mode_number(value)
	if type(value) == "number" then
		return value
	end
	if type(value) == "string" then
		return tonumber(value)
	end
	return nil
end

local function is_maximized_with_bar(win)
	if type(win) ~= "table" then
		return false
	end

	local fs = mode_number(win.fullscreen)
	if fs == 1 then
		return true
	end

	-- Some clients report maximized on the client side while compositor is mode 1/0.
	local client = mode_number(win.fullscreenClient)
	if client == 1 and (fs == nil or fs == 0 or fs == 1) then
		return true
	end

	return false
end

local function render(active)
	if active then
		-- Declarative row avoids zero-size collapse when toggling visibility.
		barWidget.render(ui.row({
			gap = 4,
			align = "center",
			padding = { 4, 6 },
			radius = 8,
			fill = "primary/0.25",
		}, {
			ui.glyph({ name = "arrows-maximize", color = "primary", size = 16 }),
		}))
		barWidget.setTooltip("Maximized (bar visible) — click to toggle")
		barWidget.setVisible(true)
	else
		barWidget.setVisible(false)
		barWidget.render(ui.row({}, {}))
	end
end

function update()
	noctalia.setUpdateInterval(350)

	if pending then
		return
	end

	if not noctalia.commandExists("hyprctl") then
		render(false)
		return
	end

	pending = true
	local ok = noctalia.runAsync("hyprctl activewindow -j", function(result)
		pending = false
		if result == nil or result.exitCode ~= 0 or result.stdout == nil or result.stdout == "" then
			render(false)
			return
		end

		local win, err = noctalia.json.decode(result.stdout)
		if not win then
			noctalia.log("fullscreen_indicator: json decode failed: " .. tostring(err))
			render(false)
			return
		end

		render(is_maximized_with_bar(win))
	end)

	if not ok then
		pending = false
		render(false)
	end
end

function onClick()
	noctalia.runAsync('hyprctl dispatch \'hl.dsp.window.fullscreen({ mode = "maximized" })\'')
end

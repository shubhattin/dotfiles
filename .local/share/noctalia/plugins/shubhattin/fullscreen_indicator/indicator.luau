--!nonstrict
-- Mirror the old Waybar custom/fullscreen module:
-- show an icon only when Hyprland fullscreen mode is 1
-- (SUPER_SHIFT+F — maximized with the bar still reserved).

local pending = false

local function is_maximized_with_bar(win)
	if type(win) ~= "table" then
		return false
	end

	local fs = win.fullscreen
	if type(fs) == "number" then
		return fs == 1
	end

	-- Newer Hyprland shapes (boolean + mode), if they appear.
	if fs == true then
		local mode = win.fullscreenMode or win.fullscreenClient
		return mode == 1
	end

	return false
end

local function render(active)
	if active then
		barWidget.setVisible(true)
		barWidget.setGlyph("arrows-maximize")
		barWidget.setText("")
		barWidget.setTooltip("Maximized fullscreen (bar visible)")
		barWidget.setGlyphColor("primary")
	else
		barWidget.setVisible(false)
	end
end

function update()
	noctalia.setUpdateInterval(500)
	if pending then
		return
	end
	if not noctalia.commandExists("hyprctl") then
		render(false)
		return
	end

	pending = true
	noctalia.runAsync("hyprctl activewindow -j", function(result)
		pending = false
		if result.exitCode ~= 0 or result.stdout == nil or result.stdout == "" then
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
end

-- Click toggles the same Hyprland mode the bind uses (fullscreen, 1).
function onClick()
	noctalia.runAsync("hyprctl dispatch fullscreen 1")
end

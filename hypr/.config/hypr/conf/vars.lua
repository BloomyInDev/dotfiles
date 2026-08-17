-- Shared values for the rest of the config.
-- Each require() is its own lua scope, so other files pull this in with:
--     local v = require("conf.vars")

-- Catppuccin Frappé, the same palette as waybar and hyprtoolkit.
local frappe = {
	surface0 = "414559",
	surface2 = "626880",
	lavender = "babbf1",
	mauve = "ca9ee6",
	crust = "232634",
}

-- "babbf1" -> "rgba(babbf1ff)". Opaque unless an alpha is given.
local function rgba(hex, alpha)
	return ("rgba(%s%s)"):format(hex, alpha or "ff")
end

-- Gradient stops are spaced evenly and cannot be positioned, so a colour is
-- weighted by repeating it. Each argument is { colour, count }, count 1 by
-- default: gradient(60, { frappe.lavender, 6 }) is six lavender stops.
local function gradient(angle, ...)
	local stops = {}
	for _, stop in ipairs({ ... }) do
		for _ = 1, stop[2] or 1 do
			stops[#stops + 1] = rgba(stop[1])
		end
	end
	return { colors = stops, angle = angle }
end

return {
	-- Main modifier key used by (almost) every bind
	mod = "SUPER",

	-- Quick display switches. Every location keeps working with all of these
	-- off -- monitors are matched by description, so just plug in and go.
	-- These only exist for the cases where you want a *different* config for a
	-- screen you already own. Flip one, save, done (monitors hot-reload).
	displays = {
		laptop_gaming = false, -- eDP-1 down to 1280x800, games are heavy
		laptop_rotated = false, -- eDP-1 rotated 90°
		laptop_off = false, -- eDP-1 disabled entirely (overrides the two above)
		samsung_gaming = false, -- gaming on the Samsung (home desk): 1280x720@144, repositioned
		lan = false, -- Lenovo LT2223pwC alone, centered instead of right
	},

	-- Programs
	apps = {
		terminal = "kitty",
		browser = "librewolf",
		editor = "kate",
		launcher = "hyprlauncher",
		file_manager = "thunar",
		window_menu = "rofi -show window",
		clipboard = [[kitty --class clipse -T "clipse" clipse]],
		logout = "wlogout -b 3",
		lock = "hyprlock",
		-- grim writes to stdout ("-") so the image can go to the file *and* the
		-- clipboard. Given a filename instead, nothing reaches the pipe.
		-- slurp runs first so cancelling it leaves no empty file behind.
		screenshot = [[g=$(slurp) && grim -g "$g" - | tee ~/Pictures/$(date +'%s_grim.png') | wl-copy -t image/png]],
	},

	-- Cursor. Used by conf/cursor.lua, conf/environments.lua and conf/autostart.lua
	cursor = {
		theme = "Bibata-Modern-Classic",
		size = 24,
	},

	-- Theme. surface2 and mauve each shade one end of the active border, the
	-- six lavender stops keep the rest of it on the accent. With fewer
	-- lavender stops the surface2 end spreads across the whole top edge,
	-- which reads as an unfocused window.
	colors = {
		active_border = gradient(60, { frappe.surface2 }, { frappe.lavender, 6 }, { frappe.mauve }),
		inactive_border = rgba(frappe.surface0, "aa"),
		shadow = rgba(frappe.crust, "ee"),
	},
}

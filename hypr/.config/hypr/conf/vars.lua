-- Shared values for the rest of the config.
-- Each require() is its own lua scope, so other files pull this in with:
--     local v = require("conf.vars")

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

	-- Theme
	colors = {
		active_border = { colors = { "rgba(33ccffee)", "rgba(c6a0f6ff)" }, angle = 60 },
		inactive_border = "rgba(595959aa)",
		shadow = "rgba(1a1a1aee)",
	},
}

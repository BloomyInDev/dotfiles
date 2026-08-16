-- See https://wiki.hypr.land/Configuring/Basics/Binds/ for more

local v    = require("conf.vars")
local mod  = v.mod
local apps = v.apps

-- Small helper so binds read as `bind("SHIFT + B", dispatcher)` with the main
-- modifier implied. Use hl.bind directly for binds without the main modifier.
local function bind(keys, dispatcher, opts)
    return hl.bind(mod .. " + " .. keys, dispatcher, opts)
end

--------------------
---- LAUNCHERS  ----
--------------------

local launchers = {
    { "T",         apps.terminal },     -- Open the terminal
    { "E",         apps.file_manager }, -- Opens the filemanager
    { "Space",     apps.launcher },
    { "Tab",       apps.window_menu },
    { "O",         apps.editor },
    { "D",         "discord" },
    { "B",         apps.browser },      -- Opens the browser
    { "M",         apps.clipboard },
    -- These two used to call ~/.config/ml4w/scripts/*.sh, which were just
    -- killall + sleep + relaunch. Inlined so the config owns nothing in ml4w.
    { "SHIFT + B", "killall -9 waybar; sleep 1; waybar" },      -- Reload Waybar
    { "SHIFT + W", "killall hyprpaper; sleep 1; hyprpaper" },   -- Reload hyprpaper after changing the wallpaper
}

for _, l in ipairs(launchers) do
    bind(l[1], hl.dsp.exec_cmd(l[2]))
end

------------------
---- WINDOWS  ----
------------------

bind("C", hl.dsp.window.close())                       -- Close current window
hl.bind("ALT + F4", hl.dsp.window.close())
-- bind("M", hl.dsp.exit())                            -- Exit Hyprland
bind("V", hl.dsp.window.float({ action = "toggle" }))  -- Toggle between tiling and floating window
bind("F", hl.dsp.window.fullscreen())                  -- Open the window in fullscreen
bind("P", hl.dsp.window.pseudo())                      -- dwindle
bind("CTRL + P", hl.dsp.window.pin())
-- bind("J", hl.dsp.layout("togglesplit"))             -- dwindle

-- Scrolling layout
bind("period", hl.dsp.layout("move +col"))
bind("semicolon", hl.dsp.layout("swapcol l"))
bind("L", hl.dsp.layout("move +col"), { locked = true })
bind("K", hl.dsp.layout("move -col"), { locked = true })

-- Move focus with mainMod + arrow keys
for _, dir in ipairs({ "left", "right", "up", "down" }) do
    bind(dir, hl.dsp.focus({ direction = dir }))
end

---------------------
---- WORKSPACES  ----
---------------------

-- Switch workspaces with mainMod + [0-9] (azerty top row)
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
local wsKeys = {
    "ampersand", "eacute", "quotedbl", "apostrophe", "parenleft",
    "minus", "egrave", "underscore", "ccedilla", "agrave",
}

for i, key in ipairs(wsKeys) do
    bind(key, hl.dsp.focus({ workspace = i }))
    bind("SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

bind("ALT + left", hl.dsp.focus({ workspace = "-1" }))          -- Switch to workspace before
bind("ALT + right", hl.dsp.focus({ workspace = "+1" }))         -- Switch to workspace after
bind("SHIFT + left", hl.dsp.window.move({ workspace = "-1" }))  -- Move window to workspace before
bind("SHIFT + right", hl.dsp.window.move({ workspace = "+1" })) -- Move window to workspace after

-- Scroll through existing workspaces with mainMod + scroll
bind("mouse_down", hl.dsp.focus({ workspace = "e+1" }))
bind("mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
bind("mouse:272", hl.dsp.window.drag(), { mouse = true })   -- Move window
bind("mouse:273", hl.dsp.window.resize(), { mouse = true }) -- Resize window

-------------------
---- HARDWARE  ----
-------------------

-- Media / brightness keys. All locked so they work on the lockscreen.
local player = "playerctl --ignore-player=kdeconnect"

local mediaKeys = {
    { "XF86MonBrightnessUp",   "brightnessctl set +10%" },
    { "XF86MonBrightnessDown", "brightnessctl set 10%-" },
    { "XF86AudioRaiseVolume",  "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+" },
    { "XF86AudioLowerVolume",  "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-" },
    { "XF86AudioMute",         "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle" },
    { "XF86AudioPlay",         player .. " play-pause" },
    { "XF86AudioPause",        player .. " play-pause" },
    { "XF86AudioNext",         player .. " next" },
    { "XF86AudioPrev",         player .. " previous" },
}

for _, m in ipairs(mediaKeys) do
    hl.bind(m[1], hl.dsp.exec_cmd(m[2]), { locked = true })
end

-- Modified play button skips tracks. These fire on release, not locked.
hl.bind("CTRL + XF86AudioPlay", hl.dsp.exec_cmd(player .. " previous"), { release = true })
hl.bind("ALT + XF86AudioPlay", hl.dsp.exec_cmd(player .. " next"), { release = true })

hl.bind("Print", hl.dsp.exec_cmd(apps.screenshot))

-- Lock on laptop close
hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd(apps.lock .. " --immediate"), { locked = true })
hl.bind("XF86PowerOff", hl.dsp.exec_cmd(apps.logout))
bind("SHIFT + P", hl.dsp.exec_cmd(apps.logout))
bind("XF86PowerOff", hl.dsp.exec_cmd(apps.lock))

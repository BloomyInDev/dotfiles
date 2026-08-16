-- Execute your favorite apps at launch
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

local v = require("conf.vars")

local autostart = {
    -- "hyprlock || hyprctl dispatch exit", -- I use SDDM now

    -- Session services
    "systemctl --user start hyprpolkitagent",
    "systemctl --user start xdg-desktop-portal-hyprland",
    "sleep 1 && /usr/lib/xdg-desktop-portal",
    "/usr/lib/pam_kwallet_init", -- So i can have a wallet for apps that needs it (nextcloud for exemple)

    -- Desktop shell
    ("hyprctl setcursor %s %d"):format(v.cursor.theme, v.cursor.size),
    "hypridle",
    "waybar",
    "hyprpaper",
    "dunst",
    "hyprlauncher -d",
    -- "hyprpanel", -- Waiting for native VPN in the network tab

    -- Tray / background helpers
    "udiskie -aNs",
    "clipse -listen",
    "bitwarden-desktop",
    "galaxybudsclient",
    "flatpak run com.tomjwatson.Emote",
    "kdeconnectd",
    "kbuildsycoca6",
    "kwalletd6",
    "nextcloud",
}

hl.on("hyprland.start", function()
    for _, cmd in ipairs(autostart) do
        hl.exec_cmd(cmd)
    end
end)

-- Galaxy Buds Manager has no "start minimized" option, but it does have
-- MinimizeToTray enabled, so closing the window only sends it to the tray --
-- the app keeps running. Close it the first time it appears so it starts out
-- of the way. Only fires once, so opening it later from the tray still works.
local budsClosed = false

hl.on("window.open", function(w)
    if budsClosed or w == nil or w.class ~= "GalaxyBudsClient" then
        return
    end

    budsClosed = true

    -- The close has to be deferred. Dispatching it directly inside the
    -- window.open callback does nothing -- the event fires (verified), but the
    -- client ignores a close request that early. Half a second is enough.
    hl.timer(function()
        hl.dispatch(hl.dsp.window.close({ window = w }))
    end, { timeout = 500, type = "oneshot" })
end)

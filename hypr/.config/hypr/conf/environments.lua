-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

local v = require("conf.vars")

-- SSH agent
hl.env("SSH_AUTH_SOCK", "/run/user/1000/ssh-agent.socket")
hl.env("SSH_ASKPASS", "/usr/bin/ksshaskpass")
-- hl.env("SSH_ASKPASS_REQUIRE", "force")

-- XDG Desktop Portal
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- QT
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")

-- GTK
hl.env("GDK_SCALE", "1")

-- Mozilla
hl.env("MOZ_ENABLE_WAYLAND", "1")

-- (XCURSOR_SIZE / XCURSOR_THEME live in conf/cursor.lua)

-- Disable appimage launcher by default
hl.env("APPIMAGELAUNCHER_DISABLE", "1")

-- OZONE
hl.env("OZONE_PLATFORM", "wayland")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- KDE apps
hl.env("XDG_MENU_PREFIX", "arch-")

-- Dropped from here: the commented-out NVIDIA block (this machine is AMD) and
-- the KVM block, which used WLR_* variables. Hyprland moved from wlroots to
-- aquamarine, so those names do nothing now -- the equivalents are AQ_*.
-- See https://wiki.hypr.land/Nvidia/ if this ever runs on an NVIDIA GPU.

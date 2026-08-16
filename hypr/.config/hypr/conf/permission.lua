-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Requires ecosystem.enforce_permissions = true (see conf/ecosystem.lua)
-- NOTE: permission changes need a full Hyprland restart, they are not hot-reloaded.

-- Screenshot tool
hl.permission({ binary = "/usr/bin/grim", type = "screencopy", mode = "allow" })

-- Color picker: grabs the screen to read the pixel under the cursor.
hl.permission({ binary = "/usr/bin/hyprpicker", type = "screencopy", mode = "allow" })

-- Lock screen requests screencopy on start even with a static background image.
hl.permission({ binary = "/usr/bin/hyprlock", type = "screencopy", mode = "allow" })

-- The portal is a regular app and goes through permissions too. Without this,
-- every screen share (Discord, browsers, OBS) pops a prompt.
hl.permission({ binary = "/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", type = "screencopy", mode = "allow" })

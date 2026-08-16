-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/

-- 3 fingers to switch workspaces
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- 2 finger zoom (pinch) to fullscreen
hl.gesture({ fingers = 2, direction = "pinch", mods = "SUPER", scale = 1.5, action = "fullscreen" })

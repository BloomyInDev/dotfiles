-- See https://wiki.hypr.land/Configuring/Basics/Variables/
local v = require("conf.vars")

hl.config({
    decoration = {
        rounding       = 8,
        rounding_power = 2,
        -- inactive_opacity = 0.9,

        blur = {
            enabled = false,
            size    = 3,
            passes  = 1,
        },

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = v.colors.shadow,
        },
    },
})

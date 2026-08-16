-- See https://wiki.hypr.land/Configuring/Basics/Variables/
local v = require("conf.vars")

hl.config({
    general = {
        gaps_in     = 5,
        gaps_out    = 8,
        border_size = 3,

        col = {
            active_border   = v.colors.active_border,
            inactive_border = v.colors.inactive_border,
        },

        layout           = "dwindle",
        resize_on_border = false,
    },
})

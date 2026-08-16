-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- NOTE: rule order matters (named rules are evaluated top to bottom).

-- The shipped stub types hl.window_rule()'s argument as HL.WindowRuleSpec,
-- which only declares `name`, `match` and `enabled` -- every actual effect
-- (float, move, size, pin, ...) is missing from it. Going through this wrapper,
-- typed as a plain table, keeps the language server quiet without disabling
-- diagnostics globally. Drop it once the stubs are complete.
---@param spec table
local function rule(spec)
    hl.window_rule(spec)
end

-- Several rules share the same shape: float the window and park it under the
-- top-right corner of the monitor. `gap` is the distance from the right edge.
-- `w`/`h` are monitor fractions and are optional.
local function float_topright(opts)
    rule({
        name  = opts.name,
        match = { title = opts.title },
        float = true,
        move  = { ("(monitor_w*1)-window_w-%d"):format(opts.gap or 8), "55" },
        size  = opts.w and { ("monitor_w*%s"):format(opts.w), ("monitor_h*%s"):format(opts.h) } or nil,
        pin   = opts.pin,
    })
end

-- Floating, sized, no fixed position
local function float_sized(opts)
    rule({
        name  = opts.name,
        match = { title = opts.title },
        float = true,
        size  = opts.size,
    })
end

float_topright({ name = "volume-control", title = "^(Volume Control)$", w = 0.4, h = 0.4, gap = 20 })
float_topright({ name = "network-manager", title = "^(Network Manager)$", w = 0.4, h = 0.4 })

rule({
    name  = "picture-in-picture",
    match = { title = ".*(Picture)$" },
    float = true,
    pin   = true,
})

float_topright({ name = "bluetooth-devices", title = "^(Bluetooth Devices)$", w = 0.4, h = 0.4 })

float_sized({ name = "qalculate", title = "^(Qalculate!)$", size = { "monitor_w*0.2", "monitor_h*0.5" } })
float_sized({ name = "clipse",    title = "^(clipse)$",     size = { 622, 652 } })

-- No size on this one, only position
float_topright({ name = "progress-dialogs", title = ".*(Progress)$", pin = true })

float_sized({ name = "bitwarden-popup", title = ".*(- Bitwarden).*", size = { "monitor_w*0.2", "monitor_h*0.2" } })

rule({
    name            = "bitwarden-no-screenshare",
    match           = { title = "Bitwarden" },
    no_screen_share = true,
})

rule({
    name             = "jetbrains-splash",
    match            = { class = "^jetbrains-(.*)", title = "^win(.*)" },
    no_initial_focus = true,
})

rule({
    name             = "zoom-no-focus",
    match            = { class = "^zoom(.*)" },
    no_initial_focus = true,
})

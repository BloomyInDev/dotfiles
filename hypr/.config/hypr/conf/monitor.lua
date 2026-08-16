-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
--
-- Every monitor here is matched by description, so all locations work at once:
-- plug the laptop in anywhere and the right rule applies. Rules for monitors
-- that aren't connected are simply ignored.
--
-- The toggles in conf/vars.lua (`displays`) only change the config of a screen
-- you already have -- they never gate whether a location works.
--
-- Note: when two hl.monitor() calls target the same output, the LAST one wins.
-- That's why the laptop spec below is built by mutation instead of by adding
-- extra hl.monitor() calls -- it lets several flags compose on one screen.

local d = require("conf.vars").displays

--- Internal monitor
local laptop = { output = "eDP-1", mode = "1920x1200", position = "0x0", scale = 1 }

if d.laptop_gaming then
    laptop.mode = "1280x800" -- reduce res when gaming cuz games are heavy
end
if d.laptop_rotated then
    laptop.transform = 1
end
if d.laptop_off then
    laptop = { output = "eDP-1", disabled = true }
end

hl.monitor(laptop)

--- Parents' house, three separate desks. Only ever one of these at a time.
-- Office room (mom's / dad's desk)
hl.monitor({ output = "desc:Philips Consumer Electronics Company PHL 273V7 UHB2129008074", mode = "preferred", position = "0x-1080", scale = 1 })
hl.monitor({ output = "desc:Lenovo Group Limited T2224pD V902M552", mode = "preferred", position = "0x-1080", scale = 1 })
-- My bedroom, small crappy one
hl.monitor({ output = "desc:AOC 1950w", mode = "1366x768@75", position = "1920x0", scale = 1 })

--- Home desk, double screen (Samsung on the left, Lenovo on the right)
local samsung = { output = "desc:Samsung Electric Company LS24AG30x H4PW103454", mode = "1920x1080@120", position = "-960x-1080", scale = 1 }

if d.samsung_gaming then
    samsung.mode     = "1280x720@144"
    samsung.position = "-320x-720"
end

hl.monitor(samsung)

local lenovoLT = { output = "desc:Lenovo Group Limited LEN LT2223pwC VN-760601", mode = "preferred", position = "960x-1080", scale = 1 }

if d.lan then
    lenovoLT.position = "0x-1080" -- single screen setup (lan mode)
end

hl.monitor(lenovoLT)

--- Single screen at IUT
hl.monitor({ output = "desc:Dell Inc. DELL P2217H RH81R8445KFB", mode = "preferred", position = "0x-1080", scale = 1 })
hl.monitor({ output = "desc:Delta Electronics Inc D557WH 0x01010101", mode = "preferred", position = "1920x0", scale = 1 })
hl.monitor({ output = "desc:NEC Corporation NP-P554U G41000042", mode = "1280x720", position = "-1280x0", scale = 1 })

--- Single screen at Dmoti
hl.monitor({ output = "desc:ASUSTek COMPUTER INC VY249HF SALMRS032036", mode = "1920x1080@100", position = "1920x0", scale = 1 })

-- Fallback rule for any unmatched monitor
hl.monitor({ output = "", mode = "preferred", position = "auto-right", scale = 1 })

-- To give another screen a gaming mode, do the same as above: pull its table
-- out, mutate it under a new flag in vars.displays, then hl.monitor() it.
-- e.g. for the Philips:
--     local philips = { output = "desc:Philips ...", mode = "preferred", position = "0x-1080", scale = 1 }
--     if d.philips_gaming then philips.mode = "1920x1080@144" end
--     hl.monitor(philips)

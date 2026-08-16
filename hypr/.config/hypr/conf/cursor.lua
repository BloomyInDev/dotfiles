local v = require("conf.vars")

hl.env("XCURSOR_SIZE", tostring(v.cursor.size))
hl.env("XCURSOR_THEME", v.cursor.theme)

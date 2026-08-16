hl.config({
    -- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
    dwindle = {
        preserve_split = true, -- you probably want this
    },
})

hl.workspace_rule({ workspace = 1, layout = "scrolling" })

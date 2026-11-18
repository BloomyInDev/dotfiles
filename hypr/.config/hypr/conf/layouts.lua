hl.config({
    -- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
    dwindle = {
        preserve_split = true, -- you probably want this
    },
})

-- Persistent so workspace 1 is always drawn in the bar, even when empty.
-- waybar's ext/workspaces has no "persistent-workspaces" of its own, so the
-- compositor owns this now. It lives on the laptop screen (chat + music).
hl.workspace_rule({ workspace = 1, monitor = "eDP-1", layout = "scrolling", persistent = true })

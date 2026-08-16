# Keybinds

`SUPER` is the main modifier (`mod` in `conf/vars.lua`). Binds written as
`SUPER + X` below go through the local `bind()` helper in `conf/binds.lua`,
which implies the modifier; the rest call `hl.bind` directly.

Keyboard layout is **AZERTY** (`kb_layout = "fr"`), which is why the
workspace keys are named `ampersand`, `eacute`, … rather than `1`, `2`, …

## Launchers

| Bind | Action |
|---|---|
| `SUPER + T` | Terminal (kitty) |
| `SUPER + E` | File manager (thunar) |
| `SUPER + Space` | App launcher (hyprlauncher) |
| `SUPER + Tab` | Window switcher (`rofi -show window`) |
| `SUPER + O` | Editor (kate) |
| `SUPER + B` | Browser (librewolf) |
| `SUPER + D` | Discord |
| `SUPER + M` | Clipboard history (clipse) |
| `SUPER + SHIFT + B` | Restart waybar |
| `SUPER + SHIFT + W` | Restart hyprpaper (after changing wallpaper) |

Programs come from `apps` in `conf/vars.lua`, change them there rather than in the
binds.

## Windows

| Bind | Action |
|---|---|
| `SUPER + C` / `ALT + F4` | Close window |
| `SUPER + V` | Toggle floating |
| `SUPER + F` | Fullscreen |
| `SUPER + P` | Pseudo (dwindle) |
| `SUPER + CTRL + P` | Pin |
| `SUPER + ←↑↓→` | Move focus |
| `SUPER + LMB` drag | Move window |
| `SUPER + RMB` drag | Resize window |

### Scrolling layout

| Bind | Action |
|---|---|
| `SUPER + .` | Move column right |
| `SUPER + ;` | Swap column left |
| `SUPER + L` | Move column right (works while locked) |
| `SUPER + K` | Move column left (works while locked) |

## Workspaces

| Bind | Action |
|---|---|
| `SUPER + &é"'(-è_çà` | Switch to workspace 1–10 (AZERTY top row) |
| `SUPER + SHIFT + &é"'…` | Move window to workspace 1–10 |
| `SUPER + ALT + ←/→` | Previous / next workspace |
| `SUPER + SHIFT + ←/→` | Move window to previous / next workspace |
| `SUPER + scroll` | Cycle through existing workspaces |

## Media & hardware

All media and brightness keys are bound with `locked = true`, so they keep
working on the lockscreen. `playerctl` runs with `--ignore-player=kdeconnect`
so a paired phone doesn't swallow the keypress.

| Bind | Action |
|---|---|
| `XF86MonBrightnessUp/Down` | Brightness ±10% (brightnessctl) |
| `XF86AudioRaise/LowerVolume` | Volume ±5%, capped at 140% (wpctl) |
| `XF86AudioMute` | Mute toggle |
| `XF86AudioPlay` / `Pause` | Play–pause |
| `XF86AudioNext` / `Prev` | Next / previous track |
| `CTRL + XF86AudioPlay` | Previous track (fires on release) |
| `ALT + XF86AudioPlay` | Next track (fires on release) |
| `Print` | Region screenshot: saved to `~/Pictures` and copied to the clipboard |

## Session

| Bind | Action |
|---|---|
| `XF86PowerOff` | Power menu (wlogout) |
| `SUPER + SHIFT + P` | Power menu |
| `SUPER + XF86PowerOff` | Lock (hyprlock) |
| Closing the lid | Lock immediately (`switch:on:Lid Switch`, locked) |

## Gestures

| Gesture | Action |
|---|---|
| 3 fingers horizontal | Switch workspace |
| `SUPER` + 2 finger pinch | Fullscreen |

---

Written by Claude Opus 5 (Claude Code), reviewed by Bastien.

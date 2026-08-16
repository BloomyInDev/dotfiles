# Bloomy's dotfiles

My personal Hyprland setup, based around Arch Linux, the Hyprland suite, waybar, wlogout, and many others.

## Contents

| Package   | Installs to        | What it is                                        |
|-----------|--------------------|---------------------------------------------------|
| `hypr`    | `~/.config/hypr`   | Hyprland (Lua config), hyprlock, hypridle, hyprpaper |
| `waybar`  | `~/.config/waybar` | Status bar, with per-output configs for the laptop and external monitors |
| `wlogout` | `~/.config/wlogout`| Power menu, incl. a reboot-to-Windows button      |

## Install

Managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level
directory is a stow package whose inner structure mirrors `$HOME`.

```bash
sudo pacman -S stow
git clone git@github.com:BloomyInDev/dotfiles.git ~/Dev/dotfiles
cd ~/Dev/dotfiles
stow -t ~ hypr waybar wlogout
```

Remove with `stow -D -t ~ <package>`, re-link after adding files with
`stow -R -t ~ <package>`.

## Notes

**Reboot to Windows** — the wlogout entry calls
`systemctl reboot --boot-loader-entry=auto-windows`. That id comes from
systemd-boot's auto-generated Windows Boot Manager entry; check yours with
`bootctl list` and adjust `wlogout/.config/wlogout/layout` if it differs.
No password prompt is needed because polkit allows
`set-reboot-to-boot-loader-entry` for active local sessions.

**Waybar per-output bars** — `config.jsonc` holds two bar objects: the full
module set on `eDP-1`, and a trimmed one on `["!eDP-1", "*"]` for smaller
external screens (short clock, date on hover). The `"*"` is required
alongside the negation, otherwise waybar spawns no bar at all.

## Credits & licence

Originally based on the [ML4W Hyprland
Starter](https://github.com/mylinuxforwork/hyprland-starter) by Stephan
Raabe (GPL-3.0), and has diverged substantially since — the Hyprland config
was rewritten in Lua, and the waybar/wlogout configs have been reworked.
Files still carrying upstream authorship keep their original headers.

Released under **GPL-3.0**, see [LICENSE](LICENSE).

`wlogout/.config/wlogout/icons/windows.svg` is the Windows icon from
[Font Awesome Free](https://fontawesome.com) 6.7.2, used under
**CC BY 4.0**; the licence notice is retained inside the SVG.

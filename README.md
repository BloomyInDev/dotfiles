# Bloomy's dotfiles

My personal Hyprland setup, based around Arch Linux, the Hyprland suite, waybar, wlogout, and many others.

## Contents

| Package   | Installs to        | What it is                                        |
|-----------|--------------------|---------------------------------------------------|
| `hypr`    | `~/.config/hypr`   | Hyprland (Lua config), hyprlock, hypridle, hyprpaper |
| `waybar`  | `~/.config/waybar` | Status bar, with per-output configs for the laptop and external monitors |
| `wlogout` | `~/.config/wlogout`| Power menu, incl. a reboot-to-Windows button      |
| `git`     | `~/.gitconfig`, `~/.config/gitremote` | Per-forge identities and SSH commit signing |
| `kitty`   | `~/.config/kitty`  | Terminal                                          |
| `rofi`    | `~/.config/rofi`   | Application launcher, called from the hypr binds  |
| `zed`     | `~/.config/zed`    | Editor settings                                   |

## Install

Managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level
directory is a stow package whose inner structure mirrors `$HOME`.

```bash
sudo pacman -S stow
git clone git@github.com:BloomyInDev/dotfiles.git ~/Dev/dotfiles
cd ~/Dev/dotfiles
stow -t ~ hypr waybar wlogout git kitty rofi zed
```

Remove with `stow -D -t ~ <package>`, re-link after adding files with
`stow -R -t ~ <package>`.

## Documentation

[**Configuration choices**](docs/choices.md) — why each config is set up the
way it is, and the non-obvious bits worth knowing before editing them.

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

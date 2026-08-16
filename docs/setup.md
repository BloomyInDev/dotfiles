# Fresh machine setup

What has to exist outside this repo before the configs work. Everything here
is Arch Linux with `pacman` / an AUR helper.

## Packages

### Core session

```
hyprland hyprlock hypridle hyprpaper hyprlauncher
hyprpolkitagent xdg-desktop-portal-hyprland
waybar wlogout dunst
```

`hyprpolkitagent` and `xdg-desktop-portal-hyprland` are started as user units
from `conf/autostart.lua`; without the portal, screen sharing and file
pickers break.

### Applications referenced by the config

```
kitty thunar librewolf kate rofi-wayland clipse udiskie
```

These are the values of `apps` in `conf/vars.lua`. Swapping any of them is a
one-line change there; the binds follow automatically.

### Keybind dependencies

```
playerctl brightnessctl wireplumber pipewire
grim slurp wl-clipboard
```

Media keys call `playerctl` and `wpctl` (from wireplumber), brightness keys
call `brightnessctl`, and `Print` pipes `grim` through `slurp` into
`wl-copy`. A missing one fails silently: the key does nothing.

### Fonts

```
ttf-fira-code ttf-fira-sans otf-font-awesome ttf-jetbrains-mono-nerd
```

`ttf-fira-sans` and `otf-font-awesome` are not optional for waybar. The
stylesheet names `Font Awesome 7 Free` explicitly, and a missing family
sends fontconfig looking for the icon codepoints in whatever font it finds
first, which renders them as unrelated letters.

### Cursor

`bibata-cursor-git` (AUR). The theme name and size live in `vars.cursor` and
are applied at session start via `hyprctl setcursor`.

### Tooling

```
stow
```

Optional, per taste: `bitwarden-desktop`, `nextcloud`, `kdeconnect`,
`galaxybudsclient`, all launched from `conf/autostart.lua`. Trim that list
on a machine that does not need them.

## SSH

The git identities expect **one key per context**, each in its own
directory, rather than a single key reused everywhere:

```
~/.ssh/
├── config                  # per-host User / IdentityFile / IdentitiesOnly
├── allowed_signers         # needed to verify signatures, see below
├── <context>/
│   ├── main                # private key
│   └── main.pub            # public key, referenced as signingkey
└── <context>/
    ├── main
    └── main.pub
```

A context is whatever you want to keep separable: one per forge you push to,
one per infrastructure group, one throwaway for everything else. A context
that needs several keys just adds them alongside `main` under a descriptive
name. For example:

```
~/.ssh/
├── config
├── allowed_signers
├── github/
│   ├── main
│   └── main.pub
├── work/
│   ├── main
│   └── main.pub
├── homelab/
│   ├── main
│   ├── main.pub
│   ├── forge           # separate key, used to sign commits on that forge
│   └── forge.pub
└── scratch/
    ├── id_ed25519
    └── id_ed25519.pub
```

Two reasons for the split. A key that leaks or gets rotated affects one
context instead of every host you touch, and with `IdentitiesOnly yes` in
`~/.ssh/config` the agent stops offering every key you own to every server
you connect to.

The paths in `~/.config/gitremote/*.gitconfig` have to match whatever
structure you pick, both for `signingkey` and for the matching
`IdentityFile` in `~/.ssh/config`.

`~/.ssh/config` is **not** in this repo, since it names internal hosts. It
has to be copied across by hand.

### Agent

`SSH_AUTH_SOCK` is set to `${XDG_RUNTIME_DIR}/ssh-agent.socket` by
`~/.config/environment.d/ssh.conf`, which is part of the repo. The socket
itself comes from whatever agent you run (`ssh-agent.service`, or the
Bitwarden desktop agent).

### Commit signing

Each identity in `~/.config/gitremote/` sets `gpg.format = ssh` and signs
with the matching `.pub`. Signing works as soon as the key exists.

**Verification needs one more file that is not created automatically:**
`~/.ssh/allowed_signers`, referenced by every identity as
`gpg.ssh.allowedSignersFile`. Without it, `git log --show-signature` reports

```
Unable to open allowed keys file "~/.ssh/allowed_signers"
```

on your own commits, even though the signature itself is good. Create it
with one line per address and key:

```
you@example.com ssh-ed25519 AAAAC3Nza...
```

---

Written by Claude Opus 5 (Claude Code), reviewed by Bastien.

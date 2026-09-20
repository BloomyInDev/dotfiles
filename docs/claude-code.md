# Claude Code

`~/.claude` mixes configuration with a lot of runtime state: transcripts under
`projects/` (hundreds of megabytes), `history.jsonl`, `sessions/`, caches,
`.credentials.json`. The `claude` stow package tracks only the configuration,
and stow symlinks it file by file, so nothing else in the directory is touched.

## What is tracked here

| Path | What it is |
|------|------------|
| `settings.json` | model, effort level, statusline, enabled plugins and their marketplaces |
| `hooks/` | `statusline-custom.sh`, the only hook script left |
| `skills/` | only `~/.claude/skills` *links*, recreated by `make claude-skills`, never stowed |

The skills themselves are in the separate `agents` package, at
`~/.agents/skills`. That is where the `skills` CLI installs them and where the
other agents (zed, codex, opencode and the rest listed in `.skill-lock.json`)
read them from; `~/.claude/skills` only holds links into it.

Those links cannot be stow symlinks. A relative link stored in the repo
resolves against the repo directory, not against `$HOME`, so it would point at
`~/Dev/dotfiles/.agents/skills/...` and dangle. `make claude-skills` creates
them directly instead.

`improve`, `grill-me` and `grilling` come from upstream repos and are recorded
in `.skill-lock.json`; `unslop` and `plan-runner` are vendored.

## What is deliberately not tracked

- **`CLAUDE.md` and the `homelab` / `pro-infra` skills** live in the private
  dotfiles repo. They name real hosts, VLANs and client environments, and this
  repo is public.
- **`plugins/`** (17 MB of cloned marketplaces). `enabledPlugins` and
  `extraKnownMarketplaces` in `settings.json` are enough: Claude Code clones
  the marketplaces again on a new machine.
- Everything under `projects/`, `sessions/`, `cache/`, `file-history/`,
  `shell-snapshots/`, `session-env/`: per-machine runtime state.

## Installing on a new machine

Install Claude Code first, and run it once so `~/.claude` exists. Then:

```bash
mkdir -p ~/.claude/skills ~/.claude/hooks   # keep them real dirs, see below
make install PKG="claude agents"
make claude-skills
```

The `mkdir` matters. Without it stow *folds* the tree: it makes
`~/.claude/skills` a symlink to the package directory, and the private repo can
no longer add its own skills next to these ones. Creating the directories first
forces stow to link each skill individually.

Plugins restore themselves on the next `claude` start, from
`extraKnownMarketplaces`.

## Paths inside `settings.json`

Hook and statusline commands run through a shell, so they use `$HOME` rather
than a hardcoded `/home/bastien`, and call `node` from `PATH` rather than the
nvm install path this machine happens to have.

## One caveat

Claude Code rewrites `settings.json` itself when you change the model, the
theme, or enable a plugin. `claude plugin uninstall` was observed writing
through the symlink and leaving it in place, so the package keeps tracking
those changes, but the file is edited behind your back: check `git status`
after fiddling with plugins. If a rewrite ever replaces the link with a regular
file, tracking stops silently. `ls -l
~/.claude/settings.json` tells you; `make reinstall PKG=claude` puts the link
back, after copying anything worth keeping back into the repo.

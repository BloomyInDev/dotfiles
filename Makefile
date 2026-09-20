# Stow wrapper. `make help` lists what is available.
#
# Every top-level directory except docs/ is a stow package. Act on all of
# them, or on a subset:
#
#     make install
#     make install PKG=waybar
#     make remove PKG="waybar wlogout"

TARGET ?= $(HOME)
AUR    ?= yay

# Stow packages: top-level dirs, minus docs/ and anything hidden.
ALL_PKG := $(shell find . -mindepth 1 -maxdepth 1 -type d \
             -not -name '.*' -not -name docs -printf '%f\n' | sort)
PKG     ?= $(ALL_PKG)

STOW := stow --target=$(TARGET) --dir=$(CURDIR)

.PHONY: help install remove reinstall list check deps claude-skills

help:
	@echo "make install    [PKG=...]  symlink packages into $(TARGET)"
	@echo "make remove     [PKG=...]  remove those symlinks"
	@echo "make reinstall  [PKG=...]  re-link, picking up added or removed files"
	@echo "make check      [PKG=...]  dry run, show what would change"
	@echo "make list                  list available packages"
	@echo "make deps                  install packages.txt with $(AUR)"
	@echo "make claude-skills         link ~/.agents/skills into ~/.claude/skills"
	@echo
	@echo "PKG defaults to every package: $(ALL_PKG)"

install:
	$(STOW) --stow $(PKG)
	@echo "linked: $(PKG)"

remove:
	$(STOW) --delete $(PKG)
	@echo "unlinked: $(PKG)"

reinstall:
	$(STOW) --restow $(PKG)
	@echo "relinked: $(PKG)"

check:
	$(STOW) --simulate --verbose --stow $(PKG)

list:
	@printf '%s\n' $(ALL_PKG)

# Claude Code only reads ~/.claude/skills, while the skills themselves live in
# ~/.agents/skills so the other agents share them. The links cannot be stowed:
# a relative link stored in the repo would resolve against the repo, not $HOME.
claude-skills:
	@mkdir -p $(TARGET)/.claude/skills
	@for s in $(TARGET)/.agents/skills/*/; do \
	  ln -sfn "../../.agents/skills/$$(basename $$s)" "$(TARGET)/.claude/skills/$$(basename $$s)"; \
	done
	@echo "linked $(TARGET)/.agents/skills/* into $(TARGET)/.claude/skills"

deps:
	@command -v $(AUR) >/dev/null || { echo "$(AUR) not found, install it first"; exit 1; }
	$(AUR) -S --needed $(shell grep -vE '^\s*(#|$$)' packages.txt)

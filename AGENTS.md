# AGENTS.md

## Repository Type
NixOS/home-manager dotfiles with literate programming from `readme.org`.

## Key Files
| File | Purpose |
|------|---------|
| `readme.org` | Source of truth - tangles to all Nix files |
| `flake.nix` | Flake inputs and outputs |
| `configuration.nix` | System config (requires sudo) |
| `home.nix` | User config |

## Workflow

```bash
# 1. Edit readme.org with doom +org tangle
doom +org tangle ~/.dotfiles/readme.org

# 2. Apply home-manager changes
cd ~/.dotfiles && home-manager switch --flake .

# 3. For system changes, also run:
cd ~/.dotfiles && sudo nixos-rebuild switch --flake .
```

## Common Commands

```bash
# Home only
home-manager switch --flake .

# Home + System
home-manager switch --flake . && sudo nixos-rebuild switch --flake .

# With updates
home-manager switch --flake . --update && sudo nixos-rebuild switch --flake . --update

# Update packages
sudo nixos-rebuild switch --flake . --upgrade
```

## Literate Programming

- Edit `readme.org`, not any .nix files directly
- Files like `flake.nix`, `configuration.nix`, `home.nix`, and `modules/*.nix` are regenerated on tangle
- Tangle command: `doom +org tangle ~/.dotfiles/readme.org`

## Inbox Workflow

- New packages or settings go to the **Inbox** section at the top of `readme.org` first
- After verifying they work, move to the appropriate module

## Module Organization

| Location | Purpose |
|----------|---------|
| `modules/*.nix` | Home-manager modules |
| `modules/python-packages/*.nix` | Custom Python packages |
| `modules/npm-packages/*.nix` | Custom npm packages |
| `modules/wm/*.nix` | Window manager modules |
| `modules/xfce/`, `modules/hyprland/` | WM-specific subdirectories |
| `system/*.nix` | System-level modules |

## Important Notes

- Edit `readme.org`, not any of the .nix files directly. Upon tangling they will be repopulated.
- `configuration.nix` requires sudo for ownership: `sudo chown root configuration.nix`
- When creating new module files, stage them with `git add` before running home-manager switch
- Window manager is configured via `userSettings.wm` in readme.org's flake.nix section
- When creating new files (especially *.nix), add them to readme.org using `#+begin_src nix :tangle ./path/to/module.nix` blocks so they are tracked by the literate programming workflow

## Module Locations
- System modules: `~/.dotfiles/modules/*.nix`
- Home modules referenced in `home.nix` imports

## System vs Home-Manager Split

Window manager and other compositor-specific configs should be split:
- **System config** (`system/*.nix`): Login managers, compositor services, seat management
- **Home config** (`modules/*-home.nix`): User packages, dotfiles, activation scripts

This allows cleaner WM switching - changing `userSettings.wm` loads the right modules automatically.

## Reference
See loaded `nixos-config` skill for detailed guidance.

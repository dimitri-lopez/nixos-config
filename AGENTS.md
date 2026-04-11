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

## Important Notes
- Edit `readme.org`, not any of the .nix files directly. Upon tangling they will be repopulated.
- User needs new shell session for PATH/env changes to take effect
- `configuration.nix` requires sudo for ownership: `sudo chown root configuration.nix`

## Module Locations
- System modules: `~/.dotfiles/modules/*.nix`
- Home modules referenced in `home.nix` imports

## Reference
See loaded `nixos-config` skill for detailed guidance.

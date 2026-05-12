# SRWC Handoff

## Issues Found

### Issue 1: Missing defaultSession
LightDM greeter couldn't find session `xfce` (doesn't exist) instead of `srwc`.

**Root Cause**: `services.displayManager.defaultSession` was never set, so the greeter fell back to a non-existent `xfce` session. The NixOS lightdm module uses `set-session` script (from accounts-daemon) to set the default, but this only runs when `defaultSession` is configured.

**Fix**: Added `defaultSession = "srwc"` to `services.displayManager` in:
- `configuration.nix` (line 103)

### Issue 2: xsession-wrapper runs X11-specific commands
Even after fixing the default session, the session wrapper (`xsession-wrapper`) runs X11/Wayland-incompatible commands:
- `xrdb` (X resource database)
- `systemctl --user import-environment` (no user systemd in LightDM context)
- `systemctl --user start nixos-fake-graphical-session.target` (fails silently)

**Status**: These are non-critical failures. The session may still start.

### Issue 3: sessionPackages duplicated
`sessionPackages` was defined in both `configuration.nix` and `modules/srwc/srwc.nix`. NixOS merges lists, so not a blocker.

## Files Modified

### `flake.nix`
- Restored `nixpkgs-unstable` input (removed by tangle)
- Restored `srwcPackage` definition (removed by tangle)
- `srwc` system modules: `[ ./modules/srwc/srwc.nix ]` (was `[]`)

### `configuration.nix`
- Added `services.displayManager.defaultSession = "srwc";`
- Uses `inputs.srwc.packages.${pkgs.stdenv.system}.default` for sessionPackages and systemPackages

### `modules/srwc/srwc.nix`
- Cleaned up (removed duplicate sessionPackages, kept defaultSession + lightdm config)

## IMPORTANT: Do NOT tangle readme.org

The tangle process **overwrites** changes to Nix files with content from readme.org. Any edits to `configuration.nix`, `flake.nix`, or other `.nix` files will be lost.

**Current workflow**: Edit `.nix` files directly. Only update readme.org if you want to document/track changes there.

## Next Steps

```bash
sudo nixos-rebuild switch --flake .
```

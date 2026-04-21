# Handoff: Spatial Wayland Session (srwc) Implementation

## Current Status
- **Success:** The system now boots directly into a `srwc` Wayland session via `greetd` and `uwsm`.
- **Graphical Apps:** Native Wayland support for Emacs (`emacs-pgtk`) and terminal (`foot`) is confirmed working.
- **System Stability:** Fixed boot timeouts by removing the missing `/mnt/data` mount.
- **Hibernation:** Configured for resurrection from swap; triggered via `Super + h`.

## Changes Made

### 1. Session & Display Manager (`configuration.nix`)
- **UWSM Wrapper:** Fixed `srwc` startup by wrapping the binary with the `start` argument.
- **Login Manager:** Switched from LightDM (X11) to **`greetd` with `tuigreet`** (TUI).
- **Default Session:** Configured `tuigreet` to automatically run `uwsm start -S srwc`.
- **Pure Wayland:** Disabled X server and LightDM to prevent GPU access conflicts.

### 2. Desktop Environment (`modules/srwc-home.nix`)
- **Core Apps:** Installed `foot` (Terminal) and `fuzzel` (App Launcher).
- **Native Wayland Emacs:** Switched to `emacs-pgtk` to resolve graphical rendering issues in Wayland.
- **Keybindings Updated:**
  - **Terminal:** `Super + Return`
  - **Launcher:** `Super + Space`
  - **Emacs:** `Alt + e`
  - **Task Manager:** `Super + Escape` (opens `btm`)
  - **Hibernation:** `Super + h`
  - **Spatial Controls:** `Super + c` (Center), `Super + w` (Zoom to fit), `Super + Arrows` (Snap camera).

### 3. System Fixes
- **Boot Timeout:** Commented out the failing `/mnt/data` mount in `hardware-configuration.nix`.
- **Hibernation:** Enabled kernel `resume` parameters and mapped the swap partition UUID.
- **Conflict Resolution:** Disabled `redshift` in `modules/common.nix` to prevent it from blocking `uwsm` startup.

## Quick Reference: Spatial Keybindings

| Action | Keybinding |
| :--- | :--- |
| **Terminal** | `Super + Return` |
| **Launcher** | `Super + Space` |
| **Emacs** | `Alt + e` |
| **Hibernate** | `Super + h` |
| **Cycle Windows**| `Alt + Tab` |
| **Snap Camera** | `Super + Arrow Keys` |
| **Pan Canvas** | `Super + Ctrl + Arrow Keys` |
| **Zoom In/Out** | `Super + =` / `Super + -` |
| **Close Window** | `Super + q` |
| **Quit Session** | `Super + Ctrl + Shift + q` |

## Next Steps for User
1. **Apply remaining system changes** (if prompted by password):
   ```bash
   sudo nixos-rebuild switch --flake .
   ```
2. **Explore your source**:
   The `srwc` compositor source code is cloned at `~/src/srwc` for your reference.
3. **Usage**:
   Use **`Super + Return`** to open a terminal and run **`btm`** to monitor your system.

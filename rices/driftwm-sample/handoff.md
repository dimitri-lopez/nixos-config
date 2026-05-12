# driftwm-sample Handoff

## What is this?

A Nix-ified version of the upstream driftwm `extras/` example rice (the full desktop configuration from the driftwm author's dotfiles). It is organized as a self-contained module that lives in `rices/driftwm-sample/` so it does not interfere with the base `driftwm` or any other window manager configs.

- **Upstream source:** https://github.com/malbiruk/driftwm/tree/main/extras
- **Local module:** `rices/driftwm-sample/`
- **System module:** `rices/driftwm-sample/system.nix` (imports base `system/driftwm.nix`)
- **Home module:** `rices/driftwm-sample/home.nix`

---

## What's Included

| Component | Tool | Notes |
|-----------|------|-------|
| **Compositor** | driftwm | Base compositor from flake input |
| **GTK Theme** | Everforest Light | Cream background, green accents |
| **Icons** | elementary-xfce-icon-theme | Upstream uses Mignon-pastel hybrid (not in nixpkgs) |
| **Wallpaper** | `pink_cloud.glsl` | GLSL shader shipped with driftwm nix package |
| **Taskbar** | waybar (left) | `wlr/taskbar` module — vertical 48px strip |
| **Tray** | waybar (bottom) | System tray strip |
| **Notifications** | swaync | Styled control center + notification bubbles |
| **OSD** | swayosd | Volume/brightness on-screen display |
| **Launcher** | fuzzel | Configured for elementary-pastel icon theme |
| **Lock** | swaylock | grim screenshot → ffmpeg blur |
| **Idle** | swayidle | Dims at 300s, locks at 330s, suspends at 600s |
| **Widgets** | Python (rich + art) | 8 dashboard widgets in alacritty |
| **Scripts** | bash | lock, battery notify, window search |
| **Auth** | polkit_gnome | Authentication agent for elevated prompts |

### Dashboard Widgets (Python)

All run inside `alacritty --class "drift-xxx"` terminals and are positioned on the canvas via driftwm window rules:

| Widget | File | What it shows |
|--------|------|---------------|
| Clock | `clock_widget.py` | Big block-digit clock + date. Click opens gnome-clocks |
| Stats | `stats_widget.py` | CPU/RAM/disk/network sparklines |
| Canvas | `canvas_widget.py` | Mini viewport preview map |
| Layout | `layout_widget.py` | Keyboard layout indicator |
| Calendar | `calendar_widget.py` | Month calendar view |
| Weather | `weather_widget.py` | Current conditions |
| Notifications | `notif_widget.py` | Notification bell |
| Power | `power_widget.py` | Power button. Click opens power menu |
| Power Menu | `power_menu.py` | Shutdown / reboot / suspend / lock menu |

### Scripts

| Script | Purpose |
|--------|---------|
| `lock.sh` | grim screenshot → ffmpeg boxblur → swaylock |
| `battery_notify.sh` | Daemon: notifies at 15% and 5% with cooldown |
| `window-search.sh` | wlrctl toplevel list → fuzzel picker → focus window |
| `launch.sh` | Launches all dashboard widgets |

---

## How to Activate

1. Edit `readme.org`:
   ```nix
   userSettings = {
     # Options: "xfce", "vxwm", "hyprland", "srwc", "driftwm", "driftwm-sample"
     wm = "driftwm-sample";
   };
   ```

2. Tangle and rebuild:
   ```bash
   cd ~/.dotfiles
   doom +org tangle readme.org
   home-manager switch --flake .
   sudo nixos-rebuild switch --flake .
   ```

3. Log out and select **driftwm** from the greetd session menu (or it auto-starts via `uwsm start`).

---

## Key Differences from Upstream

| Upstream | Our Nix version | Reason |
|----------|----------------|--------|
| `uv` for Python env | `python3.withPackages (ps: [ps.rich ps.art])` | Pure Nix, no lockfiles or `uv` dependency |
| `~/Documents/work/scripts/driftwm/extras/...` | `~/.local/share/driftwm-sample/...` | Standardized, non-hardcoded path |
| `/usr/libexec/polkit-gnome-authentication-agent-1` | `${pkgs.polkit_gnome}/libexec/...` | Nix store path |
| `/usr/local/share/driftwm/wallpapers/...` | `${inputs.driftwm.packages...}/share/driftwm/...` | Nix store path |
| Mignon-pastel icons | elementary-xfce-icon-theme | Not available in nixpkgs |
| `elementary` cursor theme | Adwaita (base driftwm) | elementary cursor not in nixpkgs |

---

## Known Issues / Notes

- **Widget positioning** is calibrated for ~1920x1080. If your resolution differs, adjust the `position = [x, y]` values in the `[[window_rules]]` sections of `config.toml`.
- **Taskbar/tray hardcoded to `eDP-1`** in `waybar/taskbar.jsonc` and `tray.jsonc`. Change the `"output"` field if your primary display has a different connector name (check with `wlr-randr`).
- **Battery notify script** polls `/sys/class/power_supply/BAT*/capacity`. If your laptop uses a different battery naming scheme (e.g., `BAT1`, `BATT`), adjust the glob in `battery_notify.sh`.
- **Qt apps** use `QT_QPA_PLATFORMTHEME=qt6ct`. Install `qt6ct` manually if you want Qt theming to match GTK.
- **Focus follows mouse** is enabled in the rice config. If you prefer click-to-focus, set `focus_follows_mouse = false`.
- **GNOME Keyring** autostart is included in the rice's `autostart` array. It may conflict if your system already starts it via systemd.

---

## Files

```
rices/driftwm-sample/
├── system.nix          # imports ../../system/driftwm.nix
└── home.nix            # packages, configs, scripts, widgets
```

---

## Maintenance

If upstream driftwm `extras/` changes:

1. Pull the driftwm flake input: `nix flake lock --update-input driftwm`
2. Widget scripts are sourced from the flake input automatically (`inputs.driftwm/extras/widgets/...`)
3. Configs (TOML, CSS, JSON) are embedded in `home.nix` and may need manual syncing if upstream changes significantly

---

## Credits

- Compositor, rice design, and widget scripts: [malbiruk/driftwm](https://github.com/malbiruk/driftwm)
- GTK theme: [Everforest](https://github.com/Fausto-Korpsvart/Everforest-GTK-Theme)
- Icons: elementary project + Xfce variant

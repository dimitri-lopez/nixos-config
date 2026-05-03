{ config, pkgs, lib, ... }:

let
  driftwmConfig = pkgs.writeText "driftwm-config.toml" ''
      # driftwm — config managed via Nix, editable at ~/.config/driftwm/config.toml

    mod_key = "super"

    [input.keyboard]
    repeat_rate = 75
    repeat_delay = 185

    [input.trackpad]
    tap_to_click = true
    natural_scroll = false
    tap_and_drag = true

    [input.mouse]
    accel_speed = 0.0
    accel_profile = "flat"
    natural_scroll = false

    [cursor]
    theme = "Adwaita"
    size = 24
    inactive_opacity = 0.5

    [navigation]
    trackpad_speed = 1.5
    mouse_speed = 1.0
    friction = 0.94
    animation_speed = 0.3
    nudge_step = 20
    pan_step = 100.0

    [zoom]
    step = 1.1

    [snap]
    enabled = true
    gap = 12.0
    distance = 24.0
    break_force = 32.0

    [decorations]
    bg_color = "#242223"
    fg_color = "#FFFFFF"
    corner_radius = 8
    default_mode = "client"

    [effects]
    blur_radius = 2
    blur_strength = 1.1

    [background]
    # driftwm ships built-in shaders in its nix package:
    # shader_path = "/run/current-system/sw/share/driftwm/wallpapers/dot_grid.glsl"
    # shader_path = "/run/current-system/sw/share/driftwm/wallpapers/animated_squares.glsl"

    [keybindings]
    "super+ctrl+r" = "reload-config"

    "alt+w" = "fit-window"
    "super+m" = "fit-window"

    "alt+e" = "exec emacsclient -c -a 'emacs'"

    "super+space" = "exec fuzzel"

    "super+return" = "exec foot"
    "alt+return" = "exec foot"

    "super+escape" = "exec xfce4-taskmanager"

    "super+equal" = "zoom-in"
    "super+minus" = "zoom-out"
    "super+0" = "zoom-reset"

    "alt+tab" = "cycle-windows forward"
    "alt+shift+tab" = "cycle-windows backward"
    "super+q" = "close-window"
    "super+f" = "toggle-fullscreen"
    "super+c" = "center-window"

    "super+ctrl+up" = "pan-viewport up"
    "super+ctrl+down" = "pan-viewport down"
    "super+ctrl+left" = "pan-viewport left"
    "super+ctrl+right" = "pan-viewport right"

    "super+up" = "center-nearest up"
    "super+down" = "center-nearest down"
    "super+left" = "center-nearest left"
    "super+right" = "center-nearest right"

    "super+shift+up" = "nudge-window up"
    "super+shift+down" = "nudge-window down"
    "super+shift+left" = "nudge-window left"
    "super+shift+right" = "nudge-window right"

    "super+ctrl+shift+q" = "quit"

    "super+h" = "exec systemctl hibernate"

    [[outputs]]
    name = "eDP-1"
    scale = 1.5

    [[window_rules]]
    app_id = ".*"
    opacity = 0.95
    blur = true

    [[window_rules]]
    app_id = "emacs"
    opacity = 0.85
    blur = true
    decoration = "none"

    [[window_rules]]
    app_id = "Emacs"
    opacity = 0.85
    blur = true
    decoration = "none"
  '';
in
{
  # check config on home-manager actiavation
  home.activation.checkDriftwmConfig = lib.hm.dag.entryBefore ["copyDriftwmConfig"] ''
    /run/current-system/sw/bin/driftwm --config ${driftwmConfig} --check-config || true
  '';

  # Write to the home directory, so auto hotloading works. 
  home.activation.copyDriftwmConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -f "${config.home.homeDirectory}/.config/driftwm/config.toml" ]; then
      mkdir -p "${config.home.homeDirectory}/.config/driftwm"
      install -m644 "${driftwmConfig}" "${config.home.homeDirectory}/.config/driftwm/config.toml"
    fi
  '';

  home.packages = with pkgs; [
    waybar
    xdg-utils
    libnotify
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
    xdg-desktop-portal
    wl-clipboard
    brightnessctl
    playerctl
    jumpapp
    fuzzel
    wmenu
    foot
    alacritty
    xfce.xfce4-taskmanager
  ];

  home.file = {
    ".config/waybar/config".text = ''
      {
        "layer": "top",
        "position": "top",
        "height": 30,
        "modules-left": ["clock"],
        "modules-center": [],
        "modules-right": ["battery", "pulseaudio"],

        "clock": {
          "format": "{:%H:%M}",
          "tooltip-format": "<big>{:%Y-%m-%d}</big>\n<tt>{:%H:%M:%S}</tt>"
        },

        "battery": {
          "format": "{icon} {capacity}%",
          "format-icons": ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"],
          "states": {
            "warning": 30,
            "critical": 15
          }
        },

        "pulseaudio": {
          "format": "{icon} {volume}%",
          "format-muted": "󰝟",
          "format-icons": {
            "default": ["󰕿", "󰖀", "󰕾"]
          },
          "on-click": "pactl set-sink-mute @DEFAULT_SINK@ toggle"
        }
      }
    '';

    ".config/waybar/style.css".text = ''
      * {
        border: none;
        font-family: "Iosevka";
        font-size: 12px;
      }

      window#waybar {
        background: rgba(30, 30, 30, 0.9);
        color: #d3c6aa;
      }

      #clock {
        padding: 0 15px;
      }

      #battery, #pulseaudio {
        padding: 0 10px;
      }
    '';

    ".xprofile".text = ''
      #!/bin/sh
      # Wayland session - xprofile runs before compositor
      # Start xdg-desktop-portal after compositor is ready
    '';
  };
}

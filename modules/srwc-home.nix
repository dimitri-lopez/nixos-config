{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    waybar
    xdg-utils
    libnotify
    xwayland-satellite
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
    xdg-desktop-portal
    wl-clipboard
    brightnessctl
    playerctl
    emenu
    jumpapp
  ];

  home.file = {
    ".config/srwc/config.toml".text = ''
      # srwc configuration
      # https://github.com/infraflakes/srwc

      [mod]
      super = true

      [input.keyboard]
      repeat_rate = 75
      repeat_delay = 185

      [cursor]
      hide_timeout = 0
      hide_on_key_press = false

      [input]
      follow_cursor = "always"

      [background]
      # shader_path = "~/.config/srwc/bg.glsl"
      # or use tiled image:
      # tile_path = "~/.config/srwc/tile.png"

      [workspaces]
      # workspace_labels = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

      [keybindings]
      # Maximize (fit window to viewport)
      "alt+w" = "fit-window"
      "super+m" = "fit-window"

      # Open emacs
      "alt+e" = "exec emacsclient -c -a 'emacs'"

      # emenu (application launcher)
      "super+space" = "exec emenu"

      # Zoom controls
      "super+equal" = "zoom-in"
      "super+minus" = "zoom-out"
      "super+0" = "zoom-reset"

      # Window navigation
      "alt+tab" = "cycle-windows forward"
      "alt+shift+tab" = "cycle-windows backward"
      "super+q" = "close-window"

      # Quit
      "super+ctrl+shift+q" = "quit"

      [[window_rules]]
      app_id = "emacs"
      opacity = 0.95
      blur = true

      [[window_rules]]
      app_id = "foot"
      opacity = 0.95
      blur = true

      [[window_rules]]
      app_id = "Alacritty"
      opacity = 0.95
      blur = true
    '';

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
      # XDG portals for screen sharing
      xdg-desktop-portal &

      # Start waybar
      waybar &
    '';
  };

  wayland.windowManager.srwc = {
    enable = true;
  };
}

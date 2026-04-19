{ config, pkgs, ... }:

{
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
  ];

  home.file = {
    ".config/srwc/config.toml".text = ''
      # srwc configuration
      # https://github.com/infraflakes/srwc

      [input.keyboard]
      repeat_rate = 75
      repeat_delay = 185

      [cursor]

      [background]
      # shader_path = "~/.config/srwc/bg.glsl"
      # or use tiled image:
      # tile_path = "~/.config/srwc/tile.png"

      [keybindings]
      # Maximize (fit window to viewport)
      "alt+w" = "fit-window"
      "super+m" = "fit-window"

      # Open emacs
      "alt+e" = "exec emacsclient -c -a 'emacs'"

      # emenu (application launcher)
      "super+space" = "exec fuzzel"

      # Terminal
      "super+return" = "exec foot"
      "alt+return" = "exec foot"

      # Task Manager
      "super+escape" = "exec foot btm"

      # Zoom controls
      "super+equal" = "zoom-in"
      "super+minus" = "zoom-out"
      "super+0" = "zoom-reset"

      # Window navigation
      "alt+tab" = "cycle-windows forward"
      "alt+shift+tab" = "cycle-windows backward"
      "super+q" = "close-window"
      "super+f" = "toggle-fullscreen"
      "super+c" = "center-window"

      # Panning
      "super+ctrl+up" = "pan-viewport up"
      "super+ctrl+down" = "pan-viewport down"
      "super+ctrl+left" = "pan-viewport left"
      "super+ctrl+right" = "pan-viewport right"

      # Center nearest window in direction (Snap Camera)
      "super+up" = "center-nearest up"
      "super+down" = "center-nearest down"
      "super+left" = "center-nearest left"
      "super+right" = "center-nearest right"

      # Nudge window (pseudo-tiling alignment)
      "super+shift+up" = "nudge-window up"
      "super+shift+down" = "nudge-window down"
      "super+shift+left" = "nudge-window left"
      "super+shift+right" = "nudge-window right"

      # Quit
      "super+ctrl+shift+q" = "quit"

      # Hibernation
      "super+h" = "exec systemctl hibernate"

      [[window_rules]]
      app_id = ".*"
      opacity = 0.95
      blur = true

      [[window_rules]]
      app_id = "emacs"
      opacity = 0.95
      blur = true
      decoration = "none"
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
      # Wayland session - xprofile runs before compositor
      # Start xdg-desktop-portal after compositor is ready
    '';
  };

}

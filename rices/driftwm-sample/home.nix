{ config, pkgs, inputs, ... }:

let
  pythonWithWidgets = pkgs.python3.withPackages (ps: [ ps.rich ps.art ]);
  driftwmPkg = inputs.driftwm.packages.${pkgs.stdenv.system}.default;
in
{
  home.packages = (with pkgs; [
    waybar
    fuzzel
    swaynotificationcenter
    swayosd
    swaylock
    swayidle
    wlrctl
    alacritty
    grim
    ffmpeg
    vorta
    polkit_gnome
    elementary-xfce-icon-theme
    everforest-gtk-theme
    ptyxis
    gnome-clocks
    brightnessctl
    libnotify
    wtype
    xwayland
  ]);

  home.file = {
    ".config/driftwm/config.toml".text = ''
      # driftwm — Example Rice config
      # https://github.com/malbiruk/driftwm/tree/main/extras

      autostart = [
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1",
          "swayosd-server --top-margin 0.95",
          "swaync",
          "waybar -c ~/.config/waybar/taskbar.jsonc -s ~/.config/waybar/taskbar.css",
          "sleep 1 && waybar -c ~/.config/waybar/tray.jsonc -s ~/.config/waybar/tray.css",
          "vorta -d",
          "${config.home.homeDirectory}/.local/share/driftwm-sample/widgets/launch.sh",
          "${config.home.homeDirectory}/.local/share/driftwm-sample/scripts/battery_notify.sh",
          "swayidle -w timeout 300 'brightnessctl -s set 10%' resume 'brightnessctl -r' timeout 330 '${config.home.homeDirectory}/.local/share/driftwm-sample/scripts/lock.sh' timeout 600 'systemctl suspend' before-sleep '${config.home.homeDirectory}/.local/share/driftwm-sample/scripts/lock.sh'",
     ]

      focus_follows_mouse = false

      [input.keyboard]
      repeat_rate = 75
      repeat_delay = 185

      [env]
      QT_QPA_PLATFORMTHEME = "qt6ct"

      [cursor]
      theme = "elementary"

      [decorations]
      bg_color = "#2A2829"
      fg_color = "#E6E1E0"

      [background]
      shader_path = "${driftwmPkg}/share/driftwm/wallpapers/dot_grid.glsl"

      [output.outline]
      color="#2A2829"

      [mouse]
      decoration_resize_snapped = true
      decoration_fit_snapped = true

      [keybindings]
      "mod+return" = "exec ptyxis -s"
      "mod+d" = "exec fuzzel"
      "mod+l" = "spawn ${config.home.homeDirectory}/.local/share/driftwm-sample/scripts/lock.sh"
      "mod+n" = "spawn swaync-client -t"
      "XF86AudioRaiseVolume" = "spawn swayosd-client --output-volume raise"
      "XF86AudioLowerVolume" = "spawn swayosd-client --output-volume lower"
      "XF86AudioMute" = "spawn swayosd-client --output-volume mute-toggle"
      "XF86MonBrightnessUp" = "spawn swayosd-client --brightness raise"
      "XF86MonBrightnessDown" = "spawn swayosd-client --brightness lower"
      "mod+s" = "exec ${config.home.homeDirectory}/.local/share/driftwm-sample/scripts/window-search.sh"
      "mod+m" = "fit-window-snapped"
      "mod+shift+m" = "fit-window"
      "super+ctrl+r" = "reload-config"

      [gestures.on-window]
      "alt+3-finger-swipe" = "resize-window-snapped"
      "alt+shift+3-finger-swipe" = "resize-window"

      [[outputs]]
      name = "HDMI-A-1"
      transform = "90"

      [[window_rules]]
      app_id = "drift-*"
      widget = true
      decoration = "none"

      [[window_rules]]
      app_id = "drift-clock"
      position = [-93, 205]

      [[window_rules]]
      app_id = "drift-stats"
      position = [-93, 0]

      [[window_rules]]
      app_id = "drift-canvas"
      position = [-129, -185]

      [[window_rules]]
      app_id = "drift-layout"
      position = [42, -185]

      [[window_rules]]
      app_id = "drift-calendar"
      position = [186, 0]

      [[window_rules]]
      app_id = "drift-weather"
      position = [186, 205]

      [[window_rules]]
      app_id = "drift-notif"
      position = [190, -185]

      [[window_rules]]
      app_id = "drift-power"
      position = [274, -259]

      [[window_rules]]
      app_id = "drift-power-menu"
      position = [274, -370]
      decoration = "server"

      [[window_rules]]
      app_id = "waybar"
      position = [-289, 21]
      widget = true
      decoration = "none"

      [[window_rules]]
      app_id = "waybar"
      position = [126, -259]
      widget = true
      decoration = "none"

      [[window_rules]]
      title = "winit window"
      widget = true

      [[window_rules]]
      app_id = "com.system76.CosmicSettings"
      size=[500, 725]

      [[window_rules]]
      app_id = "org.telegram.desktop"
      decoration = "server"

      [[window_rules]]
      app_id = "swaync-control-center"
      blur = true

      [[window_rules]]
      app_id = "swaync-notification-window"
      blur = true

      [[window_rules]]
      app_id = "Alacritty"
      opacity = 0.8
      blur = true

      [[window_rules]]
      app_id = "emacs"
      opacity = 0.90
      blur = true
      decoration = "none"
    '';

    ".config/waybar/taskbar.jsonc".text = ''
      {
          "output": "eDP-1",
          "layer": "top",
          "position": "left",
          "width": 48,
          "height": 511,
          "modules-center": ["wlr/taskbar"],

          "wlr/taskbar": {
              "format": "{icon}",
              "icon-size": 36,
              "sort-by-app-id": true,
              "tooltip-format": "{title}",
              "on-click": "activate",
              "on-click-middle": "close"
          }
      }
    '';

    ".config/waybar/taskbar.css".text = ''
      * {
          font-family: sans-serif;
          font-size: 14px;
      }

      window#waybar {
          background: #FDF6E3;
      }

      #taskbar {
          background: transparent;
          padding: 0;
      }

      #taskbar button {
          background: transparent;
          border: none;
          border-radius: 0;
          padding: 4px 6px;
          margin: 0;
          color: #8a9199;
      }

      #taskbar button:hover {
          background: rgba(92, 106, 114, 0.12);
      }

      #taskbar button.active {
          background: #A7C080;
          color: #FDF6E3;
      }

      tooltip {
          background: #FDF6E3;
          border: 1px solid rgba(92, 106, 114, 0.2);
          border-radius: 0;
          color: #5C6A72;
          font-size: 10px;
      }
    '';

    ".config/waybar/tray.jsonc".text = ''
      {
        "output": "eDP-1",
        "layer": "top",
        "position": "bottom",
        "width": 239,
        "height": 27,
        "modules-center": ["tray"],

        "tray": {
          "icon-size": 16,
          "spacing": 4,
        },
      }
    '';

    ".config/waybar/tray.css".text = ''
      * {
          font-family: sans-serif;
          font-size: 10px;
      }

      window#waybar {
          background: #FDF6E3;
      }

      #tray {
          background: transparent;
          padding: 2px 4px;
      }

      #tray > .passive {
          -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
          -gtk-icon-effect: highlight;
      }

      tooltip {
          background: #FDF6E3;
          border: 1px solid rgba(92, 106, 114, 0.2);
          border-radius: 0;
          color: #5C6A72;
          font-size: 10px;
      }
    '';

    ".config/fuzzel/fuzzel.ini".text = ''
      [main]
      font=monospace:size=14
      dpi-aware=no
      icon-theme=elementary-pastel
    '';

    ".config/swaync/config.json".source = "${inputs.driftwm}/extras/swaync/config.json";
    ".config/swaync/style.css".source = "${inputs.driftwm}/extras/swaync/style.css";

    ".local/share/icons/elementary-pastel/index.theme".text = ''
      [Icon Theme]
      Name=elementary-pastel
      Comment=Elementary icons with Mignon-pastel app icons
      Inherits=elementary,Adwaita,hicolor

      Directories=scalable/apps
      ScaledDirectories=scalable@2x/apps

      [scalable/apps]
      Context=Applications
      Size=64
      MinSize=16
      MaxSize=512
      Type=Scalable

      [scalable@2x/apps]
      Context=Applications
      Scale=2
      Size=64
      MinSize=16
      MaxSize=512
      Type=Scalable
    '';

    ".config/gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=Everforest-Light
      gtk-icon-theme-name=elementary-pastel
      gtk-cursor-theme-name=elementary
      gtk-application-prefer-dark-theme=0
    '';

    ".local/share/driftwm-sample/scripts/lock.sh".text = ''
      #!/bin/sh
      ${pkgs.grim}/bin/grim -l 0 /tmp/lockscreen.png
      ${pkgs.ffmpeg}/bin/ffmpeg -y -i /tmp/lockscreen.png -vf "boxblur=8:2" /tmp/lockblur.png 2>/dev/null
      ${pkgs.swaylock}/bin/swaylock -f -i /tmp/lockblur.png
    '';

    ".local/share/driftwm-sample/scripts/battery_notify.sh".text = ''
      #!/bin/bash
      BATTERY_LOW=15
      BATTERY_CRITICAL=5
      COOLDOWN=300
      STATE_DIR="/tmp/driftwm-battery-notify"
      mkdir -p "$STATE_DIR"

      check_cooldown() {
          local key="$1"
          local now=$(date +%s)
          local state_file="$STATE_DIR/$key"
          if [ -f "$state_file" ]; then
              local last=$(cat "$state_file")
              [ $((now - last)) -lt $COOLDOWN ] && return 1
          fi
          echo "$now" > "$state_file"
          return 0
      }

      trap 'rm -rf "$STATE_DIR"; exit 0' EXIT INT TERM

      while true; do
          bat=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -1)
          status=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -1)

          if [ -n "$bat" ] && [ "$status" = "Discharging" ]; then
              if [ "$bat" -le "$BATTERY_CRITICAL" ]; then
                  check_cooldown critical && \\
                      notify-send -u critical "Critical Battery" "''${bat}% — plug in immediately"
              elif [ "$bat" -le "$BATTERY_LOW" ]; then
                  check_cooldown low && \\
                      notify-send -u normal "Low Battery" "''${bat}% — consider charging soon"
              fi
          fi

          sleep 60
      done
    '';

    ".local/share/driftwm-sample/scripts/window-search.sh" = {
      text = ''
      #!/bin/sh
      XDG_DATA_DIRS="''${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"

      lookup_desktop() {
          id="$1"
          for dir in "$HOME/.local/share/applications" $(printf '%s' "$XDG_DATA_DIRS" | tr ':' ' '); do
              for f in "$dir/$id.desktop" "$dir"/*"$id"*.desktop; do
                  [ -f "$f" ] || continue
                  name=$(grep -m1 '^Name=' "$f" | cut -d= -f2-)
                  icon=$(grep -m1 '^Icon=' "$f" | cut -d= -f2-)
                  [ -n "$name" ] && printf '%s\t%s' "$name" "''${icon:-$id}" && return
              done
          done
          for dir in "$HOME/.local/share/applications" $(printf '%s' "$XDG_DATA_DIRS" | tr ':' ' '); do
              [ -d "$dir" ] || continue
              f=$(grep -rl "^StartupWMClass=$id$" "$dir"/*.desktop 2>/dev/null | head -1)
              if [ -n "$f" ]; then
                  name=$(grep -m1 '^Name=' "$f" | cut -d= -f2-)
                  icon=$(grep -m1 '^Icon=' "$f" | cut -d= -f2-)
                  [ -n "$name" ] && printf '%s\t%s' "$name" "''${icon:-$id}" && return
              fi
          done
          printf '%s\t%s' "$id" "$id"
      }

      display=$(mktemp)
      lookup=$(mktemp)
      trap 'rm -f "$display" "$lookup"' EXIT

      i=0
      wlrctl toplevel list | while IFS= read -r line; do
          app_id="''${line%%: *}"
          title="''${line#*: }"
          desktop=$(lookup_desktop "$app_id")
          app_name="''${desktop%%\t*}"
          icon="''${desktop#*\t}"
          printf '%s  %s\0icon\x1f%s\n' "$title" "$app_name" "$icon" >> "$display"
          printf '%s\t%s\n' "$app_id" "$title" >> "$lookup"
          i=$((i + 1))
      done

      [ -s "$display" ] || exit 0

      selected=$(fuzzel --dmenu \
          --prompt="Window: " \
          --no-run-if-empty \
          --index \
          < "$display")

      [ -z "$selected" ] && exit 0

      line_num=$((selected + 1))
      match=$(sed -n "''${line_num}p" "$lookup")
      sel_app_id="$(printf '%s' "$match" | cut -f1)"
      sel_title="$(printf '%s' "$match" | cut -f2)"

      exec wlrctl toplevel focus "app_id:$sel_app_id" "title:$sel_title"
      '';
      executable = true;
    };

      DIR="$(cd "$(dirname "$0")" && pwd)"
      export PATH="$HOME/.local/bin:$PATH"

      PYTHON="${pythonWithWidgets}/bin/python"

      launch() {
          local name="$1" cols="$2" lines="$3" script="$4"
          ${pkgs.alacritty}/bin/alacritty --class "drift-''${name}" \\
              -o "window.dimensions.columns=''${cols}" \\
              -o "window.dimensions.lines=''${lines}" \\
              -o "window.padding.x=8" \\
              -o "window.padding.y=8" \\
              -o "window.decorations=\"None\"" \\
              -e "$PYTHON" "$DIR/''${script}" &
      }

      launch clock       34 6  clock_widget.py
      launch stats       34 11 stats_widget.py
      launch canvas      26 4  canvas_widget.py
      launch layout      6 4  layout_widget.py
      launch calendar    22 11  calendar_widget.py
      launch weather     22 6  weather_widget.py
      launch notif       21 4  notif_widget.py

      ${pkgs.alacritty}/bin/alacritty --class "drift-power" \\
          -o "window.dimensions.columns=3" \\
          -o "window.dimensions.lines=1" \\
          -o "window.padding.x=5" \\
          -o "window.padding.y=3" \\
          -o "window.decorations=\"None\"" \\
          -e "$PYTHON" "$DIR/power_widget.py" &

      wait
    '';

    ".local/share/driftwm-sample/widgets/common.py".source = "${inputs.driftwm}/extras/widgets/common.py";
    ".local/share/driftwm-sample/widgets/clock_widget.py".source = "${inputs.driftwm}/extras/widgets/clock_widget.py";
    ".local/share/driftwm-sample/widgets/stats_widget.py".source = "${inputs.driftwm}/extras/widgets/stats_widget.py";
    ".local/share/driftwm-sample/widgets/canvas_widget.py".source = "${inputs.driftwm}/extras/widgets/canvas_widget.py";
    ".local/share/driftwm-sample/widgets/layout_widget.py".source = "${inputs.driftwm}/extras/widgets/layout_widget.py";
    ".local/share/driftwm-sample/widgets/calendar_widget.py".source = "${inputs.driftwm}/extras/widgets/calendar_widget.py";
    ".local/share/driftwm-sample/widgets/weather_widget.py".source = "${inputs.driftwm}/extras/widgets/weather_widget.py";
    ".local/share/driftwm-sample/widgets/notif_widget.py".source = "${inputs.driftwm}/extras/widgets/notif_widget.py";
    ".local/share/driftwm-sample/widgets/power_widget.py".source = "${inputs.driftwm}/extras/widgets/power_widget.py";
    ".local/share/driftwm-sample/widgets/power_menu.py".source = "${inputs.driftwm}/extras/widgets/power_menu.py";
  };
}

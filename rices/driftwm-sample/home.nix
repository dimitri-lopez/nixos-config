{ config, pkgs, inputs, ... }:

let
  driftwmPkg = inputs.driftwm.packages.${pkgs.stdenv.system}.default;
in
{
  imports = [ inputs.noctalia.homeModules.default ];
  home.packages = with pkgs; [
    fuzzel
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
    cliphist
    wl-clipboard
  ];

  programs.noctalia-shell = {
    enable = true;
    settings = {
      settingsVersion = 0;
      bar = {
        position = "right";
        displayMode = "auto_hide";
        autoHideDelay = 500;
        autoShowDelay = 150;
        widgets = {
          left = [
            { id = "Launcher"; }
            { id = "Clock"; }
            { id = "SystemMonitor"; }
            { id = "ActiveWindow"; }
            { id = "MediaMini"; }
          ];
          center = [ ];
          right = [
            { id = "Tray"; }
            { id = "NotificationHistory"; }
            { id = "Battery"; }
            { id = "Volume"; }
            { id = "Brightness"; }
            { id = "ControlCenter"; }
          ];
        };
      };
      general = {
        radiusRatio = 0.2;
        enableBlurBehind = true;
        showScreenCorners = false;
      };
      colorSchemes = {
        predefinedScheme = "Noctalia (default)";
        darkMode = true;
        syncGsettings = true;
      };
      appLauncher = {
        enableWindowsSearch = true;
        enableSettingsSearch = true;
        enableSessionSearch = true;
        enableClipboardHistory = true;
        clipboardWatchTextCommand = "wl-paste --type text --watch cliphist store";
        clipboardWatchImageCommand = "wl-paste --type image --watch cliphist store";
      };
      notifications.enabled = true;
      osd.enabled = true;
      dock.enabled = false;
      desktopWidgets.enabled = false;
    };
  };

  home.file = {
    ".config/driftwm/config.toml".text = ''
      # driftwm — Example Rice config
      # https://github.com/malbiruk/driftwm/tree/main/extras

      autostart = [
          "noctalia-shell",
          "wl-paste --type text --watch cliphist store",
          "wl-paste --type image --watch cliphist store",
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1",
          "vorta -d",
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
      "mod+d" = "exec noctalia-shell ipc call launcher toggle"
      "mod+shift+s" = "exec noctalia-shell ipc call launcher toggle"
      "mod+s" = "exec ${config.home.homeDirectory}/.local/share/driftwm-sample/scripts/window-search.sh"
      "mod+l" = "exec noctalia-shell ipc call lockScreen lock"
      "mod+shift+l" = "spawn ${config.home.homeDirectory}/.local/share/driftwm-sample/scripts/lock.sh"
      "mod+n" = "exec noctalia-shell ipc call notificationHistory toggle"
      "XF86AudioRaiseVolume" = "exec noctalia-shell ipc call volume increase"
      "XF86AudioLowerVolume" = "exec noctalia-shell ipc call volume decrease"
      "XF86AudioMute" = "exec noctalia-shell ipc call volume muteOutput"
      "XF86MonBrightnessUp" = "exec noctalia-shell ipc call brightness increase"
      "XF86MonBrightnessDown" = "exec noctalia-shell ipc call brightness decrease"
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
      app_id = "Alacritty"
      opacity = 0.8
      blur = true

      [[window_rules]]
      app_id = "emacs"
      opacity = 0.90
      blur = true
      decoration = "none"
    '';



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
      gtk-theme-name=Adwaita-dark
      gtk-icon-theme-name=elementary-pastel
      gtk-cursor-theme-name=elementary
      gtk-application-prefer-dark-theme=1
    '';

    ".local/share/driftwm-sample/scripts/lock.sh" = {
      text = ''
      #!/bin/sh
      ${pkgs.grim}/bin/grim -l 0 /tmp/lockscreen.png
      ${pkgs.ffmpeg}/bin/ffmpeg -y -i /tmp/lockscreen.png -vf "boxblur=8:2" /tmp/lockblur.png 2>/dev/null
      ${pkgs.swaylock}/bin/swaylock -f -i /tmp/lockblur.png
      '';
      executable = true;
    };

    ".local/share/driftwm-sample/scripts/battery_notify.sh" = {
      text = ''
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
      executable = true;
    };

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


  };
}

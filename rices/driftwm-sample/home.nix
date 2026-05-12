{ config, pkgs, inputs, lib, ... }:

let
  driftwmPkg = inputs.driftwm.packages.${pkgs.stdenv.system}.default;
  driftwmConfig = pkgs.writeText "driftwm-config.toml" ''
    # ── All driftwm settings explicitly set ──────────────────────────
    # Preserves your custom values; fills everything else with defaults.
    
    # ── Top-level ─────────────────────────────────────────────────────
    
    # Window manager modifier key: "super" (default) or "alt"
    # mod_key = "super"
    
    # Window cycling modifier: "alt" (default) or "ctrl"
    # cycle_modifier = "alt"
    
    # Sloppy focus: keyboard focus follows the pointer to windows
    # focus_follows_mouse = false
    
    # Where new windows spawn when no rule positions them:
    #   "center" (default) — viewport center
    #   "cursor"           — centered on cursor (clamped to output)
    #   "auto"             — snap-place adjacent to focused window's cluster
    window_placement = "auto"
    
    # Commands to run at startup (sh -c), after WAYLAND_DISPLAY is set
    autostart = [
        # "noctalia-shell",
        # "wl-paste --type text --watch cliphist store",
        # "wl-paste --type image --watch cliphist store",
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1",
        "vorta -d",
        # "/home/dimitril/.local/share/driftwm-sample/scripts/battery_notify.sh",
        "swayidle -w timeout 300 'brightnessctl -s set 10%' resume 'brightnessctl -r' timeout 330 '/home/dimitril/.local/share/driftwm-sample/scripts/lock.sh' timeout 600 'systemctl suspend' before-sleep '/home/dimitril/.local/share/driftwm-sample/scripts/lock.sh'",
    ]
    
    # Environment variables set before any clients launch
    [env]
    QT_QPA_PLATFORMTHEME = "qt6ct"
    
    # ── Input: Keyboard ───────────────────────────────────────────────
    
    [input.keyboard]
    # layout = "us"
    # variant = ""
    # options = ""
    # model = ""
    repeat_rate = 75
    repeat_delay = 185
    # layout_independent = true
    num_lock = true
    # caps_lock = false
    
    # ── Input: Trackpad ───────────────────────────────────────────────
    
    [input.trackpad]
    tap_to_click = true
    natural_scroll = true
    tap_and_drag = true
    # accel_speed = 0.0
    # accel_profile = "adaptive"
    # click_method = "none"
    # disable_while_typing = true
    
    # ── Input: Mouse ──────────────────────────────────────────────────
    
    [input.mouse]
    # accel_speed = 0.0
    # accel_profile = "flat"
    # natural_scroll = false
    
    # ── Cursor ────────────────────────────────────────────────────────
    
    [cursor]
    theme = "elementary"
    # size = 24
    # inactive_opacity = 0.5
    
    # ── Navigation ────────────────────────────────────────────────────
    
    [navigation]
    # trackpad_speed = 0.5
    # mouse_speed = 1.4
    # friction = 0.92
    # animation_speed = 0.95
    # nudge_step = 20
    # pan_step = 100.0
    # anchors = [[0, 0]]
    
    [navigation.edge_pan]
    # zone = 100.0
    # speed_min = 4.0
    # speed_max = 10.0
    
    # ── Zoom ──────────────────────────────────────────────────────────
    
    [zoom]
    # step = 1.1
    # fit_padding = 80.0
    # reset_on_new_window = true
    # reset_on_activation = true
    
    # ── Snap ──────────────────────────────────────────────────────────
    
    [snap]
    # enabled = true
    # gap = 15.0
    # distance = 24.0
    # break_force = 32.0
    # same_edge = false
    
    # ── Decorations ───────────────────────────────────────────────────
    
    [decorations]
    bg_color = "#2A2829"
    fg_color = "#E6E1E0"
    corner_radius = 10
    # default_mode = "client"
    
    # ── Effects ───────────────────────────────────────────────────────
    
    [effects]
    blur_radius = 1
    blur_strength = 1.9
    
    # ── Backend ───────────────────────────────────────────────────────
    
    [backend]
    # wait_for_frame_completion = false
    # disable_direct_scanout = false
    
    # ── Output outlines ───────────────────────────────────────────────
    
    [output.outline]
    color = "#2A2829"
    # thickness = 1
    # opacity = 0.5
    
    # ── Background ────────────────────────────────────────────────────
    
    [background]
    type = "shader"
    path = "/home/dimitril/driftwm/extras/wallpapers/static/dark_sea.glsl"
    
    # ── XWayland ──────────────────────────────────────────────────────
    
    [xwayland]
    enabled = true
    path = "xwayland-satellite"
    
    # ── Mouse decoration propagation ──────────────────────────────────
    
    [mouse]
    decoration_resize_snapped = true
    decoration_fit_snapped = true
    
    # ── Mouse bindings: on-window ─────────────────────────────────────
    
    [mouse.on-window]
    "alt+left" = "move-window"
    "alt+shift+left" = "move-snapped-windows"
    "alt+right" = "resize-window"
    "alt+shift+right" = "resize-window-snapped"
    "alt+middle" = "fit-window"
    "alt+shift+middle" = "fit-window-snapped"
    "mod+middle" = "toggle-fullscreen"
    
    # ── Mouse bindings: on-canvas ─────────────────────────────────────
    
    [mouse.on-canvas]
    "left" = "pan-viewport"
    "trackpad-scroll" = "pan-viewport"
    "wheel-scroll" = "zoom"
    
    # ── Mouse bindings: anywhere ──────────────────────────────────────
    
    [mouse.anywhere]
    "mod+left" = "pan-viewport"
    "mod+ctrl+left" = "center-nearest"
    "mod+trackpad-scroll" = "pan-viewport"
    "mod+wheel-scroll" = "zoom"
    
    # ── Gesture thresholds ────────────────────────────────────────────
    
    [gestures]
    # swipe_threshold = 12.0
    # pinch_in_threshold = 0.85
    # pinch_out_threshold = 1.15
    
    # ── Gesture bindings: on-window ───────────────────────────────────
    
    [gestures.on-window]
    "alt+3-finger-swipe" = "resize-window-snapped"
    "alt+shift+3-finger-swipe" = "resize-window"
    "3-finger-doubletap-swipe" = "move-window"
    "alt+2-finger-pinch-in" = "fit-window"
    "alt+2-finger-pinch-out" = "fit-window"
    "alt+shift+2-finger-pinch-in" = "fit-window-snapped"
    "alt+shift+2-finger-pinch-out" = "fit-window-snapped"
    "alt+3-finger-pinch-in" = "toggle-fullscreen"
    "alt+3-finger-pinch-out" = "toggle-fullscreen"
    
    # ── Gesture bindings: on-canvas ───────────────────────────────────
    
    [gestures.on-canvas]
    "2-finger-pinch" = "zoom"
    
    # ── Gesture bindings: anywhere ────────────────────────────────────
    
    [gestures.anywhere]
    "3-finger-swipe" = "pan-viewport"
    "4-finger-swipe" = "center-nearest"
    "mod+3-finger-swipe" = "center-nearest"
    "mod+2-finger-pinch" = "zoom"
    "3-finger-pinch" = "zoom"
    "4-finger-pinch-in" = "zoom-to-fit"
    "4-finger-pinch-out" = "home-toggle"
    "mod+4-finger-pinch-in" = "zoom-to-fit-snapped"
    "mod+3-finger-pinch-in" = "zoom-to-fit"
    "mod+3-finger-pinch-out" = "home-toggle"
    "4-finger-hold" = "center-window"
    "mod+3-finger-hold" = "center-window"
    
    # ── Keybindings ───────────────────────────────────────────────────
    # All defaults written out. Your overrides replace the relevant defaults.
    
    [keybindings]
    "mod+d" = "exec noctalia-shell ipc --any-display call launcher toggle"
    "mod+q" = "close-window"
    "mod+f" = "toggle-fullscreen"
    "mod+m" = "fit-window-snapped"
    "mod+shift+m" = "fit-window-snapped"
    "mod+c" = "center-window"
    "mod+x" = "focus-center"
    "mod+a" = "home-toggle"
    "mod+up" = "center-nearest up"
    "mod+down" = "center-nearest down"
    "mod+left" = "center-nearest left"
    "mod+right" = "center-nearest right"
    "mod+shift+up" = "nudge-window up"
    "mod+shift+down" = "nudge-window down"
    "mod+shift+left" = "nudge-window left"
    "mod+shift+right" = "nudge-window right"
    "mod+ctrl+up" = "pan-viewport up"
    "mod+ctrl+down" = "pan-viewport down"
    "mod+ctrl+left" = "pan-viewport left"
    "mod+ctrl+right" = "pan-viewport right"
    "alt+tab" = "cycle-windows forward"
    "alt+shift+tab" = "cycle-windows backward"
    "mod+equal" = "zoom-in"
    "mod+minus" = "zoom-out"
    "mod+0" = "zoom-reset"
    "mod+z" = "zoom-reset"
    "mod+w" = "zoom-to-fit"
    "mod+shift+w" = "zoom-to-fit-snapped"
    "mod+1" = "go-to -1750 1750"
    "mod+2" = "go-to 1750 1750"
    "mod+3" = "go-to 1750 -1750"
    "mod+4" = "go-to -1750 -1750"
    "mod+alt+up" = "send-to-output up"
    "mod+alt+down" = "send-to-output down"
    "mod+alt+left" = "send-to-output left"
    "mod+alt+right" = "send-to-output right"
    "mod+s" = "exec /home/dimitril/.local/share/driftwm-sample/scripts/window-search.sh"
    "mod+l" = "exec noctalia-shell ipc --any-display call lockScreen lock"
    "mod+semicolon" = "spawn /home/dimitril/.local/share/driftwm-sample/scripts/lock.sh"
    "mod+n" = "exec noctalia-shell ipc --any-display call notificationHistory toggle"
    "mod+r" = "reload-config"
    "mod+period" = "fit-window"
    "mod+ctrl+shift+q" = "quit"
    "XF86AudioRaiseVolume" = "exec noctalia-shell ipc --any-display call volume increase"
    "XF86AudioLowerVolume" = "exec noctalia-shell ipc --any-display call volume decrease"
    "XF86AudioMute" = "exec noctalia-shell ipc --any-display call volume muteOutput"
    "XF86MonBrightnessUp" = "exec noctalia-shell ipc --any-display call brightness increase"
    "XF86MonBrightnessDown" = "exec noctalia-shell ipc --any-display call brightness decrease"
    "Print" = "spawn grim - | wl-copy"
    "shift+Print" = "spawn grim -g \"$(slurp -d)\" - | wl-copy"
    
    # ── Output configs ────────────────────────────────────────────────
    
    [[outputs]]
    name = "HDMI-A-1"
    transform = "90"
    
    # ── Window rules ──────────────────────────────────────────────────
    
    [[window_rules]]
    app_id = "Alacritty"
    opacity = 0.8
    blur = true
    
    [[window_rules]]
    app_id = "emacs"
    opacity = 0.95
    blur = true
    decoration = "none"
    
    [[window_rules]]
    app_id = "Emacs"
    decoration = "none"
    widget = true
  '';
in
{
  imports = [ inputs.noctalia.homeModules.default ./noctalia-shell.nix ];

  home.activation.checkDriftwmConfig = lib.hm.dag.entryBefore ["copyDriftwmConfig"] ''
    ${driftwmPkg}/bin/driftwm --config ${driftwmConfig} --check-config || true
  '';

  home.activation.copyDriftwmConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -f "${config.home.homeDirectory}/.config/driftwm/config.toml" ]; then
      mkdir -p "${config.home.homeDirectory}/.config/driftwm"
      install -m644 "${driftwmConfig}" "${config.home.homeDirectory}/.config/driftwm/config.toml"
    fi
  '';

  home.packages = with pkgs; [
    driftwmPkg
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
    xwayland-satellite
    xfce.xfce4-taskmanager
    cliphist
    wl-clipboard
  ];


  home.file = {
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

    ".local/share/driftwm-sample/scripts/sync-noctalia.sh" = {
      text = ''
        #!/bin/sh
        set -e
        SRC="${config.home.homeDirectory}/.config/noctalia/settings.json"
        DST="${config.home.homeDirectory}/.dotfiles/rices/driftwm-sample/noctalia.json"
        chmod +w "$DST" 2>/dev/null || true
        cp "$SRC" "$DST"
        cd "${config.home.homeDirectory}/.dotfiles"
        git add "rices/driftwm-sample/noctalia.json" 2>/dev/null || true
        echo "noctalia.json synced from GUI settings"
      '';
      executable = true;
    };

    # ".local/share/driftwm-sample/scripts/battery_notify.sh" = {
    #   text = ''
    #   #!/bin/bash
    #   BATTERY_LOW=15
    #   BATTERY_CRITICAL=5
    #   COOLDOWN=300
    #   STATE_DIR="/tmp/driftwm-battery-notify"
    #   mkdir -p "$STATE_DIR"

    #   check_cooldown() {
    #       local key="$1"
    #       local now=$(date +%s)
    #       local state_file="$STATE_DIR/$key"
    #       if [ -f "$state_file" ]; then
    #           local last=$(cat "$state_file")
    #           [ $((now - last)) -lt $COOLDOWN ] && return 1
    #       fi
    #       echo "$now" > "$state_file"
    #       return 0
    #   }

    #   trap 'rm -rf "$STATE_DIR"; exit 0' EXIT INT TERM

    #   while true; do
    #       bat=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -1)
    #       status=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -1)

    #       if [ -n "$bat" ] && [ "$status" = "Discharging" ]; then
    #           if [ "$bat" -le "$BATTERY_CRITICAL" ]; then
    #               check_cooldown critical && \\
    #                   notify-send -u critical "Critical Battery" "''${bat}% — plug in immediately"
    #           elif [ "$bat" -le "$BATTERY_LOW" ]; then
    #               check_cooldown low && \\
    #                   notify-send -u normal "Low Battery" "''${bat}% — consider charging soon"
    #           fi
    #       fi

    #       sleep 60
    #   done
    #   '';
    #   executable = true;
    # };

    # ".local/share/driftwm-sample/wallpapers/cloudy_fractal.glsl".source = ./assets/wallpapers/cloudy_fractal.glsl;
    # ".local/share/driftwm-sample/scripts/window-search.sh" = {
    #   text = ''
    #   #!/bin/sh
    #   XDG_DATA_DIRS="''${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"

    #   lookup_desktop() {
    #       id="$1"
    #       for dir in "$HOME/.local/share/applications" $(printf '%s' "$XDG_DATA_DIRS" | tr ':' ' '); do
    #           for f in "$dir/$id.desktop" "$dir"/*"$id"*.desktop; do
    #               [ -f "$f" ] || continue
    #               name=$(grep -m1 '^Name=' "$f" | cut -d= -f2-)
    #               icon=$(grep -m1 '^Icon=' "$f" | cut -d= -f2-)
    #               [ -n "$name" ] && printf '%s\t%s' "$name" "''${icon:-$id}" && return
    #           done
    #       done
    #       for dir in "$HOME/.local/share/applications" $(printf '%s' "$XDG_DATA_DIRS" | tr ':' ' '); do
    #           [ -d "$dir" ] || continue
    #           f=$(grep -rl "^StartupWMClass=$id$" "$dir"/*.desktop 2>/dev/null | head -1)
    #           if [ -n "$f" ]; then
    #               name=$(grep -m1 '^Name=' "$f" | cut -d= -f2-)
    #               icon=$(grep -m1 '^Icon=' "$f" | cut -d= -f2-)
    #               [ -n "$name" ] && printf '%s\t%s' "$name" "''${icon:-$id}" && return
    #           fi
    #       done
    #       printf '%s\t%s' "$id" "$id"
    #   }

    #   display=$(mktemp)
    #   lookup=$(mktemp)
    #   trap 'rm -f "$display" "$lookup"' EXIT

    #   i=0
    #   wlrctl toplevel list | while IFS= read -r line; do
    #       app_id="''${line%%: *}"
    #       title="''${line#*: }"
    #       desktop=$(lookup_desktop "$app_id")
    #       app_name="''${desktop%%\t*}"
    #       icon="''${desktop#*\t}"
    #       printf '%s  %s\0icon\x1f%s\n' "$title" "$app_name" "$icon" >> "$display"
    #       printf '%s\t%s\n' "$app_id" "$title" >> "$lookup"
    #       i=$((i + 1))
    #   done

    #   [ -s "$display" ] || exit 0

    #   selected=$(fuzzel --dmenu \
    #       --prompt="Window: " \
    #       --no-run-if-empty \
    #       --index \
    #       < "$display")

    #   [ -z "$selected" ] && exit 0

    #   line_num=$((selected + 1))
    #   match=$(sed -n "''${line_num}p" "$lookup")
    #   sel_app_id="$(printf '%s' "$match" | cut -f1)"
    #   sel_title="$(printf '%s' "$match" | cut -f2)"

    #   exec wlrctl toplevel focus "app_id:$sel_app_id" "title:$sel_title"
    #   '';
    #   executable = true;
    # };

      # while true; do
      #     bat=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -1)
      #     status=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -1)

      #     if [ -n "$bat" ] && [ "$status" = "Discharging" ]; then
      #         if [ "$bat" -le "$BATTERY_CRITICAL" ]; then
      #             check_cooldown critical && \\
      #                 notify-send -u critical "Critical Battery" "''${bat}% — plug in immediately"
      #         elif [ "$bat" -le "$BATTERY_LOW" ]; then
      #             check_cooldown low && \\
      #                 notify-send -u normal "Low Battery" "''${bat}% — consider charging soon"
      #         fi
      #     fi
  };

  systemd.user.startServices = "sd-switch";

  systemd.user.services.noctalia-shell = {
    Unit = {
      Description = "Noctalia Shell";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${config.home.profileDirectory}/bin/noctalia-shell";
      Restart = "always";
      RestartSec = 3;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}

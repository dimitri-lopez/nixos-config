{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    (pkgs.writeScriptBin "dl-xfce-autostart" ''
#!/usr/bin/env bash
dl-switch-caps-lock-to-control &
dropbox &
dl-restart-emacs &
redshift -l 42.361145:-71.057083 &
    '')

    ];
  home.file."/home/dimitril/.themes/Everforest-Dark-Soft" = {
    source = ./themes/everforest-xfce-now-window-borders;
    recursive = true;
  };
  gtk = {
    enable = true;
      iconTheme = {
      name = "elementary-Xfce-dark";
      package = pkgs.elementary-xfce-icon-theme;
    };
    theme = {
      name = "Everforest-Dark-Soft";
    #   name = "zukitre-dark";
    #   package = pkgs.zuki-themes;
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };
  xfconf = {
    enable = true;
    settings = {
      keyboards = {
        "Default/KeyRepeat" = true;
        "Default/KeyRepeat/Delay" = 185;
        "Default/KeyRepeat/Rate" = 75;
      };
      xfce4-panel = {
        "panels" = [1];
        "panels/panel-1/position" = "p=2;x=3420;y=720";
        "panels/panel-1/size" = 40;
        "panels/panel-1/autohide-behavior" = 2;
        "panels/panel-1/icon-size" = 0;
        "panels/panel-1/length" = 100.0;
        "panels/panel-1/mode" = 1;
        "panels/panel-1/plugin-ids" = [13 2 1 4 6 5 8 9 10];
        "panels/panel-1/position-locked" = false;
        "panels/panel-1/length-adjust" = true;
        "panels/panel-1/background-style" = 0;
        "panels/darkmode" = true;

        "plugins/plugin3" = "separator";
        "plugins/plugin3/expand" = true;
        "plugins/plugin3/style" = 1;
        "plugins/plugin4" = "pager";
        "plugins/plugin5" = "separator";
        "plugins/plugin5/style" = 0;
        "plugins/plugin6" = "systray";
        "plugins/plugin6/square-icons" = true;
        "plugins/plugin7" = "separator";
        "plugins/plugin7/style" = 0;
        "plugins/plugin8" = "clock";
        "plugins/plugin8/mode" = 2;
        "plugins/plugin9" = "separator";
        "plugins/plugin9/style" = 0;
        "plugins/plugin-4" = "pager";
        "plugins/plugin-4/rows" = 1;
        "plugins/plugin-4/miniature-view" = true;
        "plugins/plugin-4/wrap-workspaces" = true;
        "plugins/plugin-6" = "systray";
        "plugins/plugin-6/square-icons" = true;
        "plugins/plugin-6/mode" = 2;
        "plugins/plugin-6/hide-new-items" = false;
        "plugins/plugin-6/single-row" = true;
        "plugins/plugin-6/icon-size" = 24;
        "plugins/plugin-6/menu-is-primary" = false;
        "plugins/plugin-6/symbolic-icons" = false;
        "plugins/plugin-8/mode" = 2;
        "plugins/plugin-8/show-week-numbers" = true;
        "plugins/plugin-8/digital-layout" = 1;
        "plugins/plugin-8/digital-date-font" = "Sans 10";
        "plugins/plugin-8/digital-time-format" = "%l:%M:%S %P";
        "plugins/plugin-8/digital-time-font" = "Sans 10";
        "plugins/plugin-8/digital-date-format" = "%m/%d/%Y";
        "plugins/plugin-13" = "whiskermenu";
        "plugins/plugin-13/view-mode" = 1;
        "plugins/plugin-13/launcher-icon-size" = 3;
        "plugins/plugin-13/category-icon-size" = 2;
        "plugins/plugin-13/position-categories-horizontal" = false;
        "plugins/plugin-13/position-categories-alternate" = true;
        "plugins/plugin-13/button-icon" = "org.xfce.panel.showdesktop";
        "plugins/plugin-13/position-profile-alternate" = true;
        "plugins/plugin-13/position-search-alternate" = true;
        "plugins/plugin-13/position-commands-alternate" = false;
        "plugins/plugin-13/default-category" = 2;
        "plugins/plugin-13/menu-width" = 750;
        "plugins/plugin-2" = "tasklist";
        "plugins/plugin-2/show-labels" = false;
        "plugins/plugin-2/show-handle" = true;
        "plugins/plugin-2/flat-buttons" = false;
        "plugins/plugin-2/show-tooltips" = true;
        "plugins/plugin-2/sort-order" = 0;
        "plugins/plugin-2/middle-click" = 1;
        "plugins/plugin-2/grouping" = true;
        "plugins/plugin-2/switch-workspace-on-unminimize" = true;
        "plugins/plugin-10" = "actions";
        "plugins/plugin-10/appearance" = 1;
        "plugins/plugin-10/button-title" = 1;
        "plugins/plugin-10/items" = ["+lock-screen" "+switch-user" "+separator" "+suspend" "+hibernate" "-hybrid-sleep" "-separator" "+shutdown" "+restart" "+separator" "+logout" "-logout-dialog"];
        "plugins/plugin-1/expand" = true;
        "plugins/plugin-3/expand" = true;
        "plugins/plugin-5" = "pulseaudio";
        "plugins/plugin-5/enable-keyboard-shortcuts" = true;
        "plugins/plugin-5/rec-indicator-persistent" = true;
        "plugins/plugin-9" = "xfce4-clipman-plugin";
      };
      xfce4-desktop = {
        "backdrop/screen0/monitoreDP-1/workspace0/last-image" =
          "/home/dimitril/Dropbox/images/Tranquil_Solitude_social.jpg";
        "desktop-icons/style" = 0;

      };

      xfce4-keyboard-shortcuts = {
        "commands/custom/override" = true;

        # Scripts
        "commands/custom/<Super>Print" = "dl-simulate-keystrokes";
        "commands/custom/<Primary><Alt>c" = "xdotool mousemove 1750 60 click 1";
        "commands/custom/<Super>q" = "pkill -USR1 '^redshift$'";

        # Emacs Scripts
        "commands/custom/<Super>Insert" = "emacsclient --eval \"(emacs-everywhere)\"";
        "commands/custom/<Super>i" = "emacsclient --eval \"(emacs-everywhere)\"";
        "commands/custom/<Super>BackSpace" = "/home/dimitril/.config/emacs/bin/org-capture";
        "commands/custom/<Alt>Favorites" = "/home/dimitril/.config/emacs/bin/org-capture";

        # Launching apps
        "commands/custom/<Super>space" = "xfce4-appfinder";
        "commands/custom/<Alt>0" = "dl-restart-emacs-daemon";
        "commands/custom/<Alt>e" = "dl-jumpapp-emacs";
        "commands/custom/<Super>Tab" = "jumpapp -m thunar";
        "commands/custom/<Super>b" = "jumpapp -m blueman-manager";
        "commands/custom/<Super>c" = "jumpapp -m brave";
        "commands/custom/<Super>e" = "jumpapp-emacs";
        "commands/custom/<Super>t" = "jumpapp xfce4-terminal";
        "commands/custom/<Primary><Alt>Delete" = "xfce4-session-logout";
        "commands/custom/<Primary><Shift>Escape" = "xfce4-taskmanager";
        "commands/custom/<Super>minus" = "xkill";

        # Screenshot
        "commands/custom/<Alt>Print" = "xfce4-screenshooter -w";
        "commands/custom/Print" = "xfce4-screenshooter";
        "commands/custom/<Shift>Print" = "xfce4-screenshooter -r";

        # xfwm4/custom
        "xfwm4/custom/override" = true;

        "xfwm4/custom/<Alt>Tab" = "cycle_windows_key";
        "xfwm4/custom/<Shift><Alt>ISO_Left_Tab" = "cycle_reverse_windows_key";

        "xfwm4/custom/<Shift><Super>space" = "popup_menu_key"; # window menu options
        "xfwm4/custom/<Super>Delete" = "close_window_key";

        # Move windows
        "xfwm4/custom/<Alt><Super>1" = "move_window_workspace_1_key";
        "xfwm4/custom/<Alt><Super>2" = "move_window_workspace_2_key";
        "xfwm4/custom/<Super>bracketright" = "move_window_to_monitor_right_key";
        "xfwm4/custom/<Super>bracketleft" = "move_window_to_monitor_left_key";

        # Resize windows
        "xfwm4/custom/<Alt>w" = "maximize_window_key";
        "xfwm4/custom/<Alt>m" = "move_window_key";
        "xfwm4/custom/<Alt>r" = "resize_window_key";
        "xfwm4/custom/<Alt>v" = "maximize_vert_key";
        "xfwm4/custom/<Super>f" = "fullscreen_key";

        # Tile windows
        "xfwm4/custom/<Super>h" = "tile_left_key";
        "xfwm4/custom/<Super>l" = "tile_right_key";
        # "xfwm4/custom/<Shift><Super>h" = "tile_up_left_key";
        # "xfwm4/custom/<Shift><Super>j" = "tile_down_left_key";
        # "xfwm4/custom/<Shift><Super>k" = "tile_down_right_key";
        # "xfwm4/custom/<Shift><Super>Left" = "move_window_left_key";
        "xfwm4/custom/<Shift><Super>Right" = "move_window_right_key";
        "xfwm4/custom/<Shift><Super>Up" = "move_window_up_key";
        "xfwm4/custom/<Shift><Super>Down" = "move_window_down_key";
      };
     xsettings = {
       "Gtk/FontName" = "Sans 14";
       "ThemeName" = "Everforest-Dark-Soft";
       "IconThemeName" = "elementary-Xfce-dark";
     };
      xfwm4 = {
        "general/theme" = "Everforest-Dark-Soft";
      };
    };
  };
  programs.gpg.enable = true;
  services.gpg-agent.enable = true;


}

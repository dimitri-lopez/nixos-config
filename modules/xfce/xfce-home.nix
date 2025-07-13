{ config, pkgs, lib, ... }:

{
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
        "panels/" = [1];
        "panels/darkmode" = true;
        "panels/panel-1/autohide-behavior" = 2;
        "panels/panel-1/plugin-ids" = [11 2 3 4 5 6 7 8 9 10];
        "panels/panel-1/position" = "p=2;x=3420;y=720";
        "panels/panel-1/size" = 40;
        "panels/panel-1/length" = 100.0;
        "plugins/plugin2" = "tasklist";
        "plugins/plugin2/grouping" = 1;
        "plugins/plugin3" = "separator";
        "plugins/plugin3/expand" = true;
        "plugins/plugin3/style" = 0;
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
        "plugins/plugin10" = "actions";
        "plugins/plugin11" = "whiskermenu";
      };
      xfce4-keyboard-shortcuts = {
        "commands/custom/override" = true;

        # Scripts
        "commands/custom/<Super>Print" = "/home/dimitril/bin/simulate-keystrokes";
        "commands/custom/<Primary><Alt>c" = "xdotool mousemove 1750 60 click 1";
        "commands/custom/<Super>q" = "pkill -USR1 '^redshift$'";

        # Emacs Scripts
        "commands/custom/<Super>Insert" = "emacsclient --eval \"(emacs-everywhere)\"";
        "commands/custom/<Super>i" = "emacsclient --eval \"(emacs-everywhere)\"";
        "commands/custom/<Super>BackSpace" = "/home/dimitril/.config/emacs/bin/org-capture";
        "commands/custom/<Alt>Favorites" = "/home/dimitril/.config/emacs/bin/org-capture";

        # Launching apps
        "commands/custom/<Super>space" = "xfce4-popup-whiskermenu";
        "commands/custom/<Alt>0" = "/home/dimitril/bin/restart-emacs-daemon";
        "commands/custom/<Alt>e" = "/home/dimitril/bin/jumpapp-emacs";
        "commands/custom/<Super>Tab" = "jumpapp -m thunar";
        "commands/custom/<Super>b" = "jumpapp -m blueman-manager";
        "commands/custom/<Super>c" = "jumpapp -m brave";
        "commands/custom/<Super>e" = "/home/dimitril/bin/jumpapp-emacs";
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
      xfwm4 = {
        "general/theme" = "Everforest-Dark-Soft";
      };
    };
  };
  programs.gpg.enable = true;
  services.gpg-agent.enable = true;
}

{ config, pkgs, lib, ... }:

{
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
      xfce4-keyboard-shortcuts = {
        "commands/custom/<Alt>0" = "/home/dimitril/bin/restart-emacs-daemon";
        "commands/custom/<Super>t" = "jumpapp xfce4-terminal";
        "commands/custom/<Super>b" = "jumpapp -m blueman-manager";
        "commands/custom/<Super>c" = "jumpapp -m brave";
        "commands/custom/<Super>e" = "/home/dimitril/bin/jumpapp-emacs";
        "commands/custom/<Super>Tab" = "jumpapp -m thunar";
        "commands/custom/<Super>BackSpace" = "/home/dimitril/.config/emacs/bin/org-capture";
        "commands/custom/<Super>minus" = "xkill";
        "xfwm4/custom/<Alt>m" = "move_window_key";
        "xfwm4/custom/<Alt>r" = "resize_window_key";
        "xfwm4/custom/<Alt>w" = "maximize_window_key";
        "xfwm4/custom/<Alt><Super>1" = "move_window_workspace_1_key";
        "xfwm4/custom/<Alt><Super>2" = "move_window_workspace_2_key";
        "xfwm4/custom/<Super>h" = "tile_left_key";
        "xfwm4/custom/<Super>l" = "tile_right_key";
      };
      xfwm4 = {
        "general/theme" = "Everforest-Dark-Soft";
      };

    };
  };

  programs.gpg.enable = true;

  services.gpg-agent.enable = true;
}

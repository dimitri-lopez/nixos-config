{ config, lib, pkgs, ... }:

{
  # Import wayland config
  imports = [ ./wayland.nix
              ./pipewire.nix
              ./dbus.nix
            ];

  # Security
  security = {
    pam.services.login.enableGnomeKeyring = true;
  };

  services.gnome.gnome-keyring.enable = true;
  # services.xserver.displayManager.sddm.enable = true; # Replaced by below
  services.displayManager.sddm.enable = true; # This line enables sddm
  services.xserver.enable = true; # Might need this for Xwayland


  programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true; # Enable UWSM (Universal Wayland Session Manager)
    };

  # services.xserver.excludePackages = [ pkgs.xterm ];

  # services.xserver = {
  #   enable = true;
  #   displayManager = {
  #     sddm = {
  #       enable = true;
  #       # theme = sddm-chili-theme.override {
  #       #   themeConfig = {
  #       #     background = config.stylix.image;
  #       #     ScreenWidth = 1920;
  #       #     ScreenHeight = 1080;
  #       #     blur = true;
  #       #     recursiveBlurLoops = 3;
  #       #     recursiveBlurRadius = 5;
  #       #   };
  #       # };
  #     };
  #   };
  #   desktopManager.hyprland.enable = true;
  #   windowManager.hyprland.enable = true;
  # };
}

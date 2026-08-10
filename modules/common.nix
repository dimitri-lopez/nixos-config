{ config, pkgs, inputs, ... }:

let
  unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
in
{
  # Packages that work across all desktop environments
  home.packages = with pkgs; [
    unstable.dropbox
    syncthing
    vim
    htop
    bottom
  ];

  # Home-manager services (auto-managed by home-manager)
  services.gammastep = {
    enable = false; # Disabled to prevent premature graphical-session.target activation
    latitude = "42.36";
    longitude = "-71.06";
    provider = "manual";
    tray = false;
  };
  
    # Unified autostart script - detects session type
    home.file.".local/bin/common-autostart" = {
      executable = true;
      text = ''
  #!/bin/sh
  # Common autostart for all desktop environments
  
  # Fix stale steam bootstrap dir (must be symlink, not directory)
  if [ -d "$HOME/.steam/steam" ] && [ ! -L "$HOME/.steam/steam" ]; then
    rm -rf "$HOME/.steam/steam"
  fi
  
  # Caps lock to control (works everywhere)
  dl-caps-lock-to-control &
  
  # Emacs daemon
  sleep 3 && restart-emacs-daemon &
  
  case "$XDG_SESSION_TYPE" in
    x11)
      # X11 desktops (vxwm, xfce)
      DISPLAY="" dropbox start &
      syncthing --no-browser &
      ;;
    wayland)
      # Wayland desktops - services handled by home-manager services
      # but we still need dropbox/syncthing
      DISPLAY="" dropbox start &
      syncthing --no-browser &
      ;;
  esac
    '';
    };
    home.file.".xprofile".text = ''
  # Source common autostart for X11
  [ -f ~/.local/bin/common-autostart ] && ~/.local/bin/common-autostart &
    '';
}

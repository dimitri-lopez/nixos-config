{ config, pkgs, ... }:

{
  # Packages that work across all desktop environments
  home.packages = with pkgs; [
    dropbox
    redshift
    syncthing
    vim
    htop
    bottom
  ];

  # Home-manager services (auto-managed by home-manager)
  services.redshift = {
    enable = true; # Disabled to prevent premature graphical-session.target activation
    latitude = "42.36";
    longitude = "-71.06";
  };
  
  # Unified autostart script - detects session type
  home.file.".local/bin/common-autostart" = {
    executable = true;
    text = ''
#!/bin/sh
# Common autostart for all desktop environments

# Caps lock to control (works everywhere)
dl-caps-lock-to-control &

# Emacs daemon
sleep 1 && restart-emacs-daemon &

case "$XDG_SESSION_TYPE" in
  x11)
    # X11 desktops (vxwm, xfce)
    dropbox start &
    syncthing --no-browser &
    redshift -l 42.361145:-71.057083 &
    ;;
  wayland)
    # Wayland desktops - services handled by home-manager services
    # but we still need dropbox/syncthing
    dropbox start &
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

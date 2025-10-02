{ config, lib, pkgs, ... }:

# https://gist.github.com/nat-418/1101881371c9a7b419ba5f944a7118b0
{
  environment = {
    systemPackages = with pkgs; [
      redshift
      geoclue2
      dropbox
      blueman
      vim
      git
      firefox
      font-manager
      # file-roller # broken
      gnome-disk-utility
      libreoffice
      orca
      pavucontrol # pulseaudio
      wmctrl
      xclip
      xcolor
      xcolor
      xdo
      xdotool
      xfce.catfish
      xfce.gigolo
      xfce.orage
      xfce.xfburn
      xfce.xfce4-appfinder
      xfce.xfce4-clipman-plugin
      xfce.xfce4-cpugraph-plugin
      xfce.xfce4-dict
      xfce.xfce4-fsguard-plugin
      xfce.xfce4-genmon-plugin
      xfce.xfce4-netload-plugin
      xfce.xfce4-panel
      xfce.xfce4-pulseaudio-plugin
      xfce.xfce4-systemload-plugin
      xfce.xfce4-weather-plugin
      xfce.xfce4-whiskermenu-plugin
      xfce.xfce4-xkb-plugin
      xfce.xfdashboard
      xorg.xev
      xorg.xf86inputsynaptics
      xorg.xkill
      xsel
      xwinmosaic
    ];
  };
  hardware = {
    bluetooth.enable = true;
  };

  programs = {
    dconf.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-media-tags-plugin
        thunar-volman
      ];
    };
  };

  # security.pam.services.gdm.enableGnomeKeyring = true;

  services = {
    blueman.enable = true;
    # gnome.gnome-keyring.enable = true;
    pipewire = { # multimedia framework
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
    xserver = {
      enable = true;
      excludePackages = with pkgs; [
        xterm
      ];
      displayManager = {
        lightdm = {
          enable = true;
          greeters.slick = {
            enable = true;
            theme.name = "Zukitre-dark";
          };
        };
      };
      desktopManager.xfce.enable = true;
    };
  };
}

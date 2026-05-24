{ config, pkgs, inputs, ... }:

{
  imports = [ ../../system/wayland.nix ];

  services.xserver.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-session --cmd 'uwsm start driftwm'";
        user = "greeter";
      };
    };
  };
  services.xserver.displayManager.lightdm.enable = false;
  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      driftwm = {
        prettyName = "driftwm";
        comment = "driftwm Wayland compositor managed by UWSM";
        binPath = "${pkgs.writeShellScript "driftwm-uwsm-wrapper" "exec ${inputs.driftwm.packages.${pkgs.stdenv.system}.default}/bin/driftwm start"}";
      };
    };
  };
  services.seatd.enable = true;
  services.dbus.enable = true;

  # PAM services for screen lockers
  security.pam.services.swaylock = {};
  security.pam.services.hyprlock = {};

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
    configPackages = [ inputs.driftwm.packages.${pkgs.stdenv.system}.default ];
  };

  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
}

{ config, pkgs, inputs, ... }:

let
  driftwmPkg = (inputs.driftwm.packages.${pkgs.stdenv.system}.default).overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      patch -d "$NIX_BUILD_TOP/cargo-vendor-dir" -p1 < ${./libdisplay-info-sys.patch}
    '';
  });
in
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
        binPath = "${pkgs.writeShellScript "driftwm-uwsm-wrapper" "exec ${driftwmPkg}/bin/driftwm"}";
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
    configPackages = [ driftwmPkg ];
  };

  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
}

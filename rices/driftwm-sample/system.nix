{ config, pkgs, inputs, ... }:

{
  imports = [ ../../system/driftwm.nix ];

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
    configPackages = [ inputs.driftwm.packages.${pkgs.stdenv.system}.default ];
  };

  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
}

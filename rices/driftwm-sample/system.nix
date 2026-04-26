{ config, pkgs, inputs, ... }:

{
  imports = [ ../../system/driftwm.nix ];

  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
}

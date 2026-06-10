{ config, pkgs, lib, settingsFile, ... }:
let
  settings = builtins.fromJSON (builtins.readFile settingsFile);
in
{
  programs.noctalia-shell = {
    enable = true;
    inherit settings;
  };
}

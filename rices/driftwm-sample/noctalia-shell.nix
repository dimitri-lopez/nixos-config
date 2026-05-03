{ config, pkgs, lib, ... }:
let
  settings = builtins.fromJSON (builtins.readFile ./noctalia.json);
in
{
  programs.noctalia-shell = {
    enable = true;
    inherit settings;
  };
}

{ config, pkgs, lib, settingsFile, inputs, ... }:
let
  noctaliaPkg = inputs.noctalia.packages.${pkgs.stdenv.system}.default;
in
{
  home.packages = [ noctaliaPkg ];

  # Create noctalia configuration file (TOML format for v5)
  xdg.configFile."noctalia/config.toml".text = builtins.readFile settingsFile;
}

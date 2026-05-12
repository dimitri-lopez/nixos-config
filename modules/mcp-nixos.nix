{ pkgs, inputs, ... }:

{
  home.packages = [
    inputs.mcp-nixos.packages.${pkgs.system}.default
  ];
}

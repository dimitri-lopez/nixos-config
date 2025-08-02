{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    # minecraft
    # atlauncher
    prismlauncher
  ];
}

{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    esptool
    platformio
    arduino
  ];
}

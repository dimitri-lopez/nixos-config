{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    jumpapp
    libnotify # for sending notifications
    wmctrl # for window management
    <<scripting.scripts>>
  ];
}

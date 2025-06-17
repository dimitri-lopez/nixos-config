{ config, lib, pkgs, ... }:

{

  home.packages = with pkgs; [
    jumpapp
    libnotify # forr sending notifcations
    wmctrl #for window management
  ];
}

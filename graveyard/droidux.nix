{ pkgs, ... }:

{
  home.packages = with pkgs; [
    xournalpp
    weylus
    android-tools
  ];

  programs.bash = {
    enable = true;
shellAliases = {
      weylus-start = "weylus";
      weylus-usb = "adb reverse tcp:1701 tcp:1701 && adb reverse tcp:9001 tcp:9001 && weylus";
    };
  };
}

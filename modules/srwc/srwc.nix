{ inputs, srwc, pkgs, ... }:

{
  services.displayManager = {
    defaultSession = "srwc";
  };

  services.xserver.displayManager.lightdm = {
    enable = true;
    greeters.slick = {
      enable = true;
      theme.name = "Zukitre-dark";
    };
  };
}

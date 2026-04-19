{ config, pkgs, inputs, ... }:

{
  imports = [ ./pipewire.nix ./dbus.nix ];

  services.xserver.enable = false;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd 'uwsm start -S srwc'";
        user = "greeter";
      };
    };
  };
  services.xserver.displayManager.lightdm.enable = false;
  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      srwc = {
        prettyName = "srwc";
        comment = "srwc Wayland compositor managed by UWSM";
        binPath = "${pkgs.writeShellScript "srwc-uwsm-wrapper" "exec ${inputs.srwc.packages.${pkgs.stdenv.system}.default}/bin/srwc start"}";
      };
    };
  };
  services.displayManager = {
    defaultSession = "srwc-uwsm";
  };
  services.seatd.enable = true;
  services.dbus.enable = true;
}

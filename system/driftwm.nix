{ config, pkgs, inputs, ... }:

{
  imports = [ ./pipewire.nix ./dbus.nix ];

  services.xserver.enable = false;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-session --cmd 'uwsm start driftwm'";
        user = "greeter";
      };
    };
  };
  services.xserver.displayManager.lightdm.enable = false;
  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      driftwm = {
        prettyName = "driftwm";
        comment = "driftwm Wayland compositor managed by UWSM";
        binPath = "${pkgs.writeShellScript "driftwm-uwsm-wrapper" "exec ${inputs.driftwm.packages.${pkgs.stdenv.system}.default}/bin/driftwm start"}";
      };
    };
  };
  services.seatd.enable = true;
  services.dbus.enable = true;
}

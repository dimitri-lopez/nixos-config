{ config, pkgs, lib, settingsFile, inputs, ... }:
let
  settings = builtins.fromJSON (builtins.readFile settingsFile);
  noctaliaPkg = inputs.noctalia.packages.${pkgs.stdenv.system}.default;
  settingsJson = builtins.toJSON settings;
in
{
  home.packages = [ noctaliaPkg ];
  
  # Create noctalia configuration file
  xdg.configFile."noctalia/config.json".text = settingsJson;
  
  # Simple service to run noctalia-shell (commented out for now to avoid conflicts)
  # systemd.user.services.noctalia-shell = {
  #   Unit = {
  #     Description = "Noctalia Shell";
  #     After = [ "graphical-session-pre.target" ];
  #     PartOf = [ "graphical-session.target" ];
  #   };
  #   Service = {
  #     ExecStart = "${noctaliaPkg}/bin/noctalia-shell";
  #     Restart = "always";
  #   };
  #   Install = {
  #     WantedBy = [ "graphical-session.target" ];
  #   };
  # };
}

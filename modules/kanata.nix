{ config, pkgs, ... }:

{
  services.kanata = {
    enable = true;
    keyboards = {
      default = {
        # Empty devices list allows kanata to auto-detect all keyboards
        devices = [ ];
        config = ''
          (defsrc
            caps
          )

          (deflayer base
            lctl
          )
        '';
      };
    };
  };
}

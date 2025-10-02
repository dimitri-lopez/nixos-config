{ config, lib, pkgs, ... }:

{
  services.syncthing = {
    enable = true;
    group = "users";
    user = "dimitril";
    overrideDevices = true;
    overrideFolders = true;
    key = "";
    cert = "";
    settings = {
      gui = {
        user = "username";
        password = "password";
      };
      devices = {
        "new-phone" = { id = "5OVC5WF-ZUNOOGO-IKIRYIP-IMIFYVL-6VKXJZT-352QMSM-2QDXBEZ-D2BV7QL"; };
        "old-phone" = { id = "MK7D4CK-M5CO223-RGFT5B5-M7AJQWE-HIA7GBN-KJHB7P3-6KQMZTF-ODXA5AY"; };
      };
      folders = {
        "org-notes" = {
          path = "/home/dimitril/sync-temp";
          devices = [ "new-phone" "old-phone" ];
          ignorePerms = false;
        };
      };
    };
  };
}

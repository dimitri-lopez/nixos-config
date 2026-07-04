{ modulesPath, inputs, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./hardware-configuration.nix
    ../../configuration.nix
    ../../modules/driftwm/system.nix
  ];

  networking.hostName = "t14s";

  boot.resumeDevice = "/dev/disk/by-uuid/75bde775-be2a-4135-a34d-c18cd526f54e";
  boot.kernelParams = [ "resume=UUID=75bde775-be2a-4135-a34d-c18cd526f54e" ];
}

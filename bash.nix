{ config, lib, pkgs, ... }:

{
  bash.enable = lib.mkForce true;
}

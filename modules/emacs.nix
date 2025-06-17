{ config, lib, pkgs, ... }:

{

  home.packages = with pkgs; [
    emacs    # Emacs 27.2
    ripgrep
    # optional dependencies
    coreutils # basic GNU utilities
    fd
    clang

    cmake
    gnumake
    libtool

    graphviz

    texliveFull

    stdenv.cc.cc.lib
    nodejs # needed for github copilot
  ];
}

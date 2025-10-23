{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    gephi
    # R and dependencies
    R
    zlib
    libxmlb
    libxml2
    gpick
    # (rWrapper.withPackages (p: with p; [
    #   tidyverse
    #   ggplot2
    #   # Add other R packages here
    # ]))
  ];
}

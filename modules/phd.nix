{ config, lib, pkgs, ... }:

let
  rEnv = pkgs.rWrapper.override {
    packages = with pkgs.rPackages; [
      ggcorrplot
      tidyverse
      ggplot2
      openintro
      infer
      GGally
      NHANES
    ];
  };
in
{
  home.packages = with pkgs; [
    gephi
    gpick

    # Include the R environment
    rEnv

    # Other system packages
    zlib
    libxmlb
    libxml2
  ];

  # Ensure R can find its user-installed packages
  # This might be implicitly handled by rEnv, but explicit is safer
  # If you encounter issues, you might need to adjust R_LIBS_USER
  # home.sessionVariables = {
  #   R_LIBS_USER = "${pkgs.rWrapper}/lib/R/library";
  # };
}

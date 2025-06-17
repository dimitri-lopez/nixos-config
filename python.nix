{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    (python312.withPackages (python3Packages: with python3Packages; [
      numpy
      sympy
      pandas
      scipy
      matplotlib
      seaborn
      plotly
      networkx
      requests
    ]))
  ];
}

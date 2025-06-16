{ config, lib, pkgs, ... }:

{
  home.packages = [
    (pkgs.python312.withPackages (ppkgs: [
      ppkgs.numpy
      ppkgs.sympy
      ppkgs.pandas
      ppkgs.scipy
      ppkgs.matplotlib
      ppkgs.seaborn
      ppkgs.plotly
      ppkgs.networkx
      ppkgs.requests
    ]))
  ];
}

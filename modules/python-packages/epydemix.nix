{
  lib,
  python3,
  fetchFromGitHub,
  fetchurl,
}:
let
  evalidate = import ./evalidate.nix { inherit lib python3 fetchurl; };
in
python3.pkgs.buildPythonPackage rec {
  pname = "epydemix";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "epistorm";
    repo = "epydemix";
    rev = "v${version}";
    hash = "sha256-BFzL4MPfWhAfNIyCxFZ/UrgQKz3n0REWeYivLrBAj0E=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    evalidate
    matplotlib
    numpy
    pandas
    scipy
    seaborn
  ];

  pythonImportsCheck = [
    "epydemix"
  ];

  meta = {
    description = "A Python package for epidemic modeling, simulation, and calibration";
    homepage = "https://github.com/epistorm/epydemix";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ];
  };
}

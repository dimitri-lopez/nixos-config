{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "tailestim";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mu373";
    repo = "tailestim";
    rev = "v${version}";
    hash = "sha256-mPHM0ch/vFt+HuLTr9NDBSZ/bydOPYU+6W0+IIoztNA=";
  };

  build-system = [
    python3.pkgs.hatchling
  ];

  dependencies = with python3.pkgs; [
    matplotlib
    numpy
  ];

  pythonImportsCheck = [
    "tailestim"
  ];

  meta = {
    description = "Estimate tail parameters of heavy-tailed distributions (including power law exponent gamma) in Python";
    homepage = "https://github.com/mu373/tailestim";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "tailestim";
  };
}

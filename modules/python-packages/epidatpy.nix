{
  lib,
  python3,
  fetchFromGitHub,
}:
let
  epiweeks = import ./epiweeks.nix { inherit lib python3 fetchFromGitHub; };
in
python3.pkgs.buildPythonPackage rec {
  pname = "epidatpy";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cmu-delphi";
    repo = "epidatpy";
    rev = "v${version}";
    hash = "sha256-cQcCgX+pAYeTJ1Nev/VagXn7cCzsIdQqek/9nlVbWe8=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    appdirs
    diskcache
    epiweeks
    pandas
    requests
    tenacity
  ];

  optional-dependencies = with python3.pkgs; {
    dev = [
      ipykernel
      matplotlib
      mypy
      nbsphinx
      pylint
      pytest
      recommonmark
      ruff
      sphinx
      sphinx-autodoc-typehints
      sphinx-rtd-theme
      twine
      types-requests
    ];
  };

  pythonImportsCheck = [
    "epidatpy"
  ];

  meta = {
    description = "Delphi Epidata API Python Client";
    homepage = "https://github.com/cmu-delphi/epidatpy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}

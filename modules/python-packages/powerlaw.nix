{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "powerlaw";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jeffalstott";
    repo = "powerlaw";
    rev = "v${version}";
    hash = "sha256-ZLpO1x8Uq+Yh6tD8v8xtjMT9Oq3njUc/7oaxisIp6Jw=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.setuptools-scm
    python3.pkgs.wheel
  ];

  dependencies = with python3.pkgs; [
    matplotlib
    mpmath
    numpy
    scipy
    tqdm
  ];

  optional-dependencies = with python3.pkgs; {
    docs = [
      furo
      numpydoc
      sphinx-subfigure
    ];
  };

  pythonImportsCheck = [
    "powerlaw"
  ];

  meta = {
    description = "";
    homepage = "https://github.com/jeffalstott/powerlaw";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "powerlaw";
  };
}

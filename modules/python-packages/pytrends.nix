{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pytrends";
  version = "4.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GeneralMills";
    repo = "pytrends";
    rev = "v${version}";
    hash = "sha256-Y+rNdGQ9pLJH6U/zt9ftrmzU2ENOXwFJ/9BbPlr0kNQ=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.setuptools-scm
  ];

  dependencies = with python3.pkgs; [
    lxml
    pandas
    requests
  ];

  pythonImportsCheck = [
    "pytrends"
  ];

  meta = {
    description = "Pseudo API for Google Trends";
    homepage = "https://github.com/GeneralMills/pytrends";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "pytrends";
  };
}

{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "doi2bib";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bibcure";
    repo = "doi2bib";
    rev = version;
    hash = "sha256-KECMtr4QOfqWwVeycak9srgO9lecJknnwD8hYxxWd7E=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies = with python3.pkgs; [
    requests
    bibtexparser
    future
  ];

  pythonImportsCheck = [
    "doi2bib"
  ];

  meta = {
    description = "Get the bibtex string given a doi";
    homepage = "https://github.com/bibcure/doi2bib";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "doi2bib";
  };
}

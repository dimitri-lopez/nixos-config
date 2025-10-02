{
  lib,
  python3,
  fetchFromGitHub,
}:

let
  arxivcheck = import ./arxivcheck.nix { inherit lib python3 fetchFromGitHub; };
  doi2bib = import ./doi2bib.nix { inherit lib python3 fetchFromGitHub; };
in
python3.pkgs.buildPythonApplication rec {
  pname = "title2bib";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bibcure";
    repo = "title2bib";
    rev = version;
    hash = "sha256-2Zf+M4SBebt81E5Wly5IomCBxrpUvAGohO4kNCsmMAg=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    requests
    future
    doi2bib
    arxivcheck
    unidecode
  ];

  pythonImportsCheck = [
    "title2bib"
  ];

  meta = {
    description = "Given a title returns the bibtex";
    homepage = "https://github.com/bibcure/title2bib";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "title2bib";
  };
}

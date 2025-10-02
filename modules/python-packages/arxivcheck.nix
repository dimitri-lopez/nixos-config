{
  lib,
  python3,
  fetchFromGitHub,
}:

let
  doi2bib = import ./doi2bib.nix { inherit lib python3 fetchFromGitHub; };
in
python3.pkgs.buildPythonApplication rec {
  pname = "arxivcheck";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bibcure";
    repo = "arxivcheck";
    rev = version;
    hash = "sha256-GHoQMdUi3M6IF02Km0VzAF51xj0oulOZJYyyRdLt8Nc=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    future
    unidecode
    feedparser
    bibtexparser
    doi2bib
  ];

  pythonImportsCheck = [
    "arxivcheck"
  ];

  meta = {
    description = "Given an arixiv id or title, check if has been published, and then returns the updated bib";
    homepage = "https://github.com/bibcure/arxivcheck";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "arxivcheck";
  };
}

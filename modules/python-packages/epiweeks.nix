{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "epiweeks";
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dralshehri";
    repo = "epiweeks";
    rev = "v${version}";
    hash = "sha256-ZcNOcyUN0YrJvU6vJ19rZHWfGZ1VHthR4maR8WVQXM0=";
  };

  build-system = [
    python3.pkgs.hatch-fancy-pypi-readme
    python3.pkgs.hatchling
  ];

  pythonImportsCheck = [
    "epiweeks"
  ];

  meta = {
    description = "Epidemiological weeks calculation based on CDC (MMWR) and ISO week numbering systems";
    homepage = "https://github.com/dralshehri/epiweeks";
    changelog = "https://github.com/dralshehri/epiweeks/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}

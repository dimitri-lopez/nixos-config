{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pytrends";
  version = "4.9.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aRxuNrGuqkdU82kr260N/0RuUo/7BS7uLn8TmqosaYk=";
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
    homepage = "https://pypi.org/project/pytrends/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "pytrends";
  };
}

{
  lib,
  python3,
  fetchFromGitHub,
}:

let
  pyobjc = import ./pyobjc.nix { inherit lib python3 fetchFromGitHub; };
in
python3.pkgs.buildPythonApplication rec {
  pname = "py5";
  version = "5-1306-0027-0.10.7a0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "py5coding";
    repo = "py5";
    rev = "py${version}";
    hash = "sha256-m8w6rbPXrGBMBwDyt7YMYYhEHz3qgia0g9cuqGm6zig=";
  };

  build-system = [
    python3.pkgs.hatchling
  ];

  dependencies = with python3.pkgs; [
    autopep8
    jpype1
    line-profiler
    numpy
    pillow
    pyobjc
    pywin32
    requests
    stackprinter
  ];

  optional-dependencies = with python3.pkgs; {
    extras = [
      colour
      matplotlib
      py5jupyter
      shapely
      trimesh
    ];
    jupyter = [
      py5jupyter
    ];
  };

  pythonImportsCheck = [
    "py5"
  ];

  meta = {
    description = "A Python library that makes Processing available to the CPython interpreter using JPype";
    homepage = "https://github.com/py5coding/py5";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "py5";
  };
}

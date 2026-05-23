{
  lib,
  python3,
  fetchurl,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "evalidate";
  version = "2.1.4";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/7a/a3/651a90aa0b4cc1dc3c7905de3a8f2173ecc6dfb997318f042957521d4e8a/evalidate-${version}-py3-none-any.whl";
    hash = "sha256-4pUJjn9+6vHHfILzFRgO7xUigL2U9GTtouCTQl+X//s=";
  };

  format = "wheel";

  pythonImportsCheck = [
    "evalidate"
  ];

  meta = {
    description = "Python library for evaluating expressions";
    homepage = "https://github.com/gradefoot/evalidate";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}

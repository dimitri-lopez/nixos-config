{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "free-coding-models";
  version = "0.3.25";

  src = fetchFromGitHub {
    owner = "vava-nessa";
    repo = "free-coding-models";
    rev = "v${version}";
    hash = "sha256-QOWyF+4vJgqn8FCqaQIEkDEa9sJHqMAcaOnoj0v3O/M=";
  };

  npmDepsHash = "sha256-9yQLGKitdMDVCWncYHvvj8fb1FCS5KtQ9+OKcViGApM=";

  meta = {
    description = "CLI tool to find and use free AI coding models";
    homepage = "https://github.com/vava-nessa/free-coding-models";
    license = lib.licenses.mit;
    mainProgram = "free-coding-models";
  };
}

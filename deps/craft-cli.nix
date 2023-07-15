{ pkgs
, lib
, ...
}:
let
  pname = "craft-cli";
  version = "1.2.0";
in
pkgs.python3Packages.buildPythonPackage rec {
  inherit pname version;

  src = pkgs.fetchFromGitHub {
    owner = "canonical";
    repo = pname;
    rev = version;
    sha256 = "sha256-kNaAvuZarAq/qo7g9htd0Y65SQ/zjrbKmDSAfAj+ydw=";
  };

  propagatedBuildInputs = with pkgs.python3Packages; [
    platformdirs
    pydantic
    pyyaml
  ];

  doCheck = false;

  meta = {
    description = "A Command Line Client builder that follows the Canonical's Guidelines for a Command Line Interface.";
    homepage = "https://github.com/canonical/craft-cli";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}

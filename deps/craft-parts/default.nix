{ pkgs
, lib
, ...
}:
let
  pname = "craft-parts";
  version = "1.26.2";
in
pkgs.python3Packages.buildPythonPackage rec {
  inherit pname version;

  src = pkgs.fetchFromGitHub {
    owner = "canonical";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-wHv0JWffS916RK4Kgk+FuRthx+ajh0Ka4DBwGrLdUBs=";
  };

  patches = [
    ./bash-path.patch
  ];

  propagatedBuildInputs = with pkgs.python3Packages;[
    overrides
    pydantic
    pydantic-yaml
    pyxdg
    pyyaml
    requests
    requests-unixsocket
    types-pyyaml
  ];

  doCheck = false;

  meta = {
    description = "Software artifact parts builder from Canonical.";
    homepage = "https://github.com/canonical/craft-parts";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}

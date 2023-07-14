{ pkgs
, lib
, ...
}: pkgs.python3Packages.buildPythonPackage rec {
  pname = "craft-parts";
  version = "1.19.3";

  src = pkgs.fetchFromGitHub {
    owner = "canonical";
    repo = "craft-parts";
    rev = "v${version}";
    sha256 = "sha256-CQKzZ5rhPku6wkANiknpZnNikFMmJE8jTelbwOgpxjg=";
  };

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

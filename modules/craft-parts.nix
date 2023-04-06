{ pkgs
, lib
, outputs
, ...
}:
let
  pydantic-yaml = pkgs.callPackage ./deps/pydantic-yaml.nix { inherit outputs; };
  overrides = pkgs.callPackage ./deps/overrides.nix { };
  pydantic = outputs.overlays.${pkgs.system}.pydantic.pkgs.pydantic;
in
pkgs.python3Packages.buildPythonPackage rec {
  pname = "craft-parts";
  version = "1.17.1";

  src = pkgs.fetchFromGitHub {
    owner = "canonical";
    repo = "craft-parts";
    rev = "v${version}";
    sha256 = "sha256-Lo26q0HjytJaF7lcM/ltYqa5Yd1GDO+YqydOgS1sROU=";
  };

  propagatedBuildInputs = with pkgs.python3Packages;
    [
      pyxdg
      pyyaml
      requests
      requests-unixsocket
    ]
    ++ [
      overrides
      pydantic
      pydantic-yaml
    ];

  doCheck = false;

  meta = with lib; {
    description = "Software artifact parts builder from Canonical.";
    homepage = "https://github.com/canonical/craft-parts";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ jnsgruk ];
  };
}

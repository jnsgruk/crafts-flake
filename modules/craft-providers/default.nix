{
  pkgs,
  lib,
  outputs,
  ...
}: let
  pydantic = outputs.overlays.${pkgs.system}.pydantic.pkgs.pydantic;
in
  pkgs.python3Packages.buildPythonPackage rec {
    pname = "craft-providers";
    version = "1.7.0";

    src = pkgs.fetchFromGitHub {
      owner = "canonical";
      repo = "craft-providers";
      rev = "v${version}";
      sha256 = "sha256-V9y6GFML/4vN5e3fJlWk4yZoXbjtNTimpYQBHbg5muA=";
    };

    patches = [
      ./lxd-socket-path.patch
      ./no-inject-snap.patch
    ];

    propagatedBuildInputs = with pkgs.python3Packages;
      [
        pyyaml
        requests
        requests-unixsocket
      ]
      ++ [pydantic];

    doCheck = false;

    meta = with lib; {
      description = "Python interfaces for instantiating and executing builds for a variety of target environments..";
      homepage = "https://github.com/canonical/craft-providers";
      license = licenses.lgpl3;
      maintainers = with maintainers; [jnsgruk];
    };
  }

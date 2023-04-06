{ pkgs
, lib
, outputs
, ...
}:
let
  pydantic = outputs.overlays.${pkgs.system}.pydantic.pkgs.pydantic;
in
pkgs.python3Packages.buildPythonPackage rec {
  pname = "craft-providers";
  version = "1.7.1";

  src = pkgs.fetchFromGitHub {
    owner = "canonical";
    repo = "craft-providers";
    rev = "v${version}";
    sha256 = "sha256-PUYD8+aOP5AKdUDwQ8SWd8MM7gzLVsYNPhFM55P/7NY=";
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
    ++ [ pydantic ];

  doCheck = false;

  meta = with lib; {
    description = "Python interfaces for instantiating and executing builds for a variety of target environments..";
    homepage = "https://github.com/canonical/craft-providers";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ jnsgruk ];
  };
}

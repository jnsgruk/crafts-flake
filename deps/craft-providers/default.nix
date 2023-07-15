{ pkgs
, lib
, ...
}:
let
  pname = "craft-providers";
  version = "1.11.0";
in
pkgs.python3Packages.buildPythonPackage rec {
  inherit pname version;

  src = pkgs.fetchFromGitHub {
    owner = "canonical";
    repo = pname;
    rev = version;
    sha256 = "sha256-ORwwHEYeqf50vwriGpGFQNl2XJQGITLoPu/ddoM02Jw=";
  };

  patches = [
    ./lxd-socket-path.patch
    ./no-inject-snap.patch
  ];

  propagatedBuildInputs = with pkgs.python3Packages; [
    pydantic
    pyyaml
    requests
    requests-unixsocket
  ];

  doCheck = false;

  meta = {
    description = "Python interfaces for instantiating and executing builds for a variety of target environments..";
    homepage = "https://github.com/canonical/craft-providers";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}

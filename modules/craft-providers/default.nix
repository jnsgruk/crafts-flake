{ pkgs
, lib
, ...
}: pkgs.python3Packages.buildPythonPackage rec {
  pname = "craft-providers";
  version = "1.11.0";

  src = pkgs.fetchFromGitHub {
    owner = "canonical";
    repo = "craft-providers";
    rev = "${version}";
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

  meta = with lib; {
    description = "Python interfaces for instantiating and executing builds for a variety of target environments..";
    homepage = "https://github.com/canonical/craft-providers";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ jnsgruk ];
  };
}

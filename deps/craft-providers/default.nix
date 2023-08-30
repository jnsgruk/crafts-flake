{ pkgs
, lib
, ...
}:
let
  pname = "craft-providers";
  version = "1.15.0";
in
pkgs.python3Packages.buildPythonPackage rec {
  inherit pname version;
  format = "pyproject";

  src = pkgs.fetchFromGitHub {
    owner = "canonical";
    repo = pname;
    rev = version;
    sha256 = "sha256-Yy3ZINItHi+/xqot8BesaGEkqFPKgTiK3vf8gKN2McA=";
  };

  patches = [
    ./lxd-socket-path.patch
    ./python-submodules.patch
  ];

  postPatch = ''
    substituteInPlace craft_providers/__init__.py \
      --replace "dev" "${version}"
    
    substituteInPlace pyproject.toml \
      --replace "setuptools==67.7.2" "setuptools"
  '';

  propagatedBuildInputs = with pkgs.python3Packages; [
    pydantic
    pyyaml
    requests
    requests-unixsocket
    setuptools
    setuptools-scm
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  doCheck = false;

  meta = {
    description = "Python interfaces for instantiating and executing builds for a variety of target environments..";
    homepage = "https://github.com/canonical/craft-providers";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}

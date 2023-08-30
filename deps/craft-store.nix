{ pkgs
, lib
, ...
}:
let
  pname = "craft-store";
  # Version 2.4.0 but version was not tagged
  version = "2.4.0";
in
pkgs.python3Packages.buildPythonPackage rec {
  inherit pname version;
  format = "pyproject";

  src = pkgs.fetchFromGitHub {
    owner = "canonical";
    repo = pname;
    rev = "721955c98fc5d991ab1233826d67faeed6f8c65d";
    sha256 = "sha256-wNI3BVfSGWKV1hrMZ7hGNGksdHjCfv+vMLuoDh2f7M0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "setuptools==67.7.2" "setuptools"
  '';

  propagatedBuildInputs = with pkgs.python3Packages; [
    keyring
    macaroon-bakery
    overrides
    pydantic
    requests
    requests-toolbelt
    setuptools
    setuptools-scm
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  doCheck = false;

  meta = {
    description = "Python interfaces for communicating with Canonical Stores, such as Charmhub and the Snap Store.";
    homepage = "https://github.com/canonical/craft-store";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}

{ pkgs
, lib
, ...
}:
let
  pname = "craft-archives";
  version = "1.1.3";
in
pkgs.python3Packages.buildPythonPackage rec {
  inherit pname version;
  format = "pyproject";

  src = pkgs.fetchFromGitHub {
    owner = "canonical";
    repo = pname;
    rev = version;
    sha256 = "sha256-ZUqMjbOsHwzZyn0NsSTlZTljzagYEirWKEGatXVL43g=";
  };

  postPatch = ''
    substituteInPlace craft_archives/__init__.py \
      --replace-fail "dev" "${version}"
    
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==67.7.2" "setuptools"
  '';

  propagatedBuildInputs = with pkgs.python3Packages;[
    gnupg
    launchpadlib
    lazr-restfulclient
    overrides
    pydantic
    setuptools
    setuptools-scm
    tabulate
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  doCheck = false;

  meta = {
    description = "A library for handling archives/repositories in Craft applications";
    homepage = "https://github.com/canonical/craft-archives";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}

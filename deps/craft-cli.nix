{ pkgs
, lib
, ...
}:
let
  pname = "craft-cli";
  version = "2.5.1";
in
pkgs.python3Packages.buildPythonPackage rec {
  inherit pname version;
  format = "pyproject";

  src = pkgs.fetchFromGitHub {
    owner = "canonical";
    repo = pname;
    rev = version;
    sha256 = "sha256-yEKF04OPu4paRrghAP78r9hu6cqkUy6z/V7cHNys82I=";
  };

  postPatch = ''
    substituteInPlace craft_cli/__init__.py \
      --replace-fail "dev" "${version}"
    
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==67.7.2" "setuptools"
  '';

  propagatedBuildInputs = with pkgs.python3Packages; [
    platformdirs
    pydantic
    pyyaml
    setuptools
    setuptools-scm
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  doCheck = false;

  meta = {
    description = "A Command Line Client builder that follows the Canonical's Guidelines for a Command Line Interface.";
    homepage = "https://github.com/canonical/craft-cli";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}

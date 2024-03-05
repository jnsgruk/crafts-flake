{ pkgs
, lib
, ...
}:
let
  pname = "craft-store";
  version = "2.6.0";
in
pkgs.python3Packages.buildPythonPackage rec {
  inherit pname version;
  format = "pyproject";

  src = pkgs.fetchFromGitHub {
    owner = "canonical";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-VtKOe3IrvGcNWfp1/tg1cO94xtfkP7AbIHh0WTdlfbQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==67.7.2" "setuptools"
  '';

  propagatedBuildInputs = with pkgs.python3Packages; [
    keyring
    macaroon-bakery
    overrides
    pydantic
    pyxdg
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

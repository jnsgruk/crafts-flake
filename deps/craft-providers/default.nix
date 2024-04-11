{ pkgs, lib, ... }:
let
  pname = "craft-providers";
  version = "1.23.1";
in
pkgs.python3Packages.buildPythonPackage rec {
  inherit pname version;
  format = "pyproject";

  src = pkgs.fetchFromGitHub {
    owner = "canonical";
    repo = pname;
    rev = version;
    sha256 = "sha256-opVgOtbwZD+uQJ10Q8QlgQaS9KjRFnQ4h98Ak7Ze5qQ=";
  };

  patches = [
    ./inject-snaps.patch
    ./lxd-socket-path.patch
    ./python-submodules.patch
  ];

  postPatch = ''
    substituteInPlace craft_providers/__init__.py \
      --replace-fail "dev" "${version}"

    # The urllib3 incompat: https://github.com/msabramo/requests-unixsocket/pull/69
    # This is already patched in nixpkgs.
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==69.1.1" "setuptools" \
      --replace-fail "urllib3<2" "urllib3"
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

{ pkgs
, lib
, ...
}:
let
  pname = "craft-providers";
  version = "1.19.2";
in
pkgs.python3Packages.buildPythonPackage rec {
  inherit pname version;
  format = "pyproject";

  src = pkgs.fetchFromGitHub {
    owner = "canonical";
    repo = pname;
    rev = version;
    sha256 = "sha256-TwB6oz6EsVzF8KuVSwjjmbAE0ptmaoWF/s7xNHlEx1Q=";
  };

  patches = [
    ./inject-snaps.patch
    ./lxd-socket-path.patch
    ./python-submodules.patch
  ];

  postPatch = ''
    substituteInPlace craft_providers/__init__.py \
      --replace "dev" "${version}"
    
    # The urllib3 incompat: https://github.com/msabramo/requests-unixsocket/pull/69
    # This is already patched in nixpkgs.
    substituteInPlace pyproject.toml \
      --replace "setuptools==67.7.2" "setuptools" \
      --replace "pydantic<2.0" "pydantic" \
      --replace "urllib3<2" "urllib3"
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

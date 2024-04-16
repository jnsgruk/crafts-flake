{ pkgs, lib, ... }:
let
  version = "2.6.0";
in
pkgs.python3Packages.buildPythonApplication {
  inherit version;
  pname = "charmcraft";

  src = pkgs.fetchFromGitHub {
    owner = "canonical";
    repo = "charmcraft";
    rev = version;
    hash = "sha256-B0ZcOORW6yaSIpisPLnq5/S/CcqqvHNTXcfP1sKW2KQ=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'version=determine_version()' 'version="${version}"'
  '';

  propagatedBuildInputs = with pkgs.python3Packages; [
    craft-cli
    craft-parts
    craft-providers
    craft-store
    distro
    humanize
    jinja2
    jsonschema
    pydantic
    python-dateutil
    pyyaml
    requests
    requests-toolbelt
    requests-unixsocket
    setuptools-rust
    snap-helpers
    tabulate
  ];

  doCheck = false;

  meta = {
    description = "Build and publish Charmed Operators";
    homepage = "https://github.com/canonical/charmcraft";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}

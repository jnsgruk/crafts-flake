{ pkgs
, lib
, ...
}:
let
  pname = "charmcraft";
  version = "2.4.1";
in
pkgs.python3Packages.buildPythonApplication {
  inherit pname version;

  src = pkgs.fetchFromGitHub {
    owner = "canonical";
    repo = pname;
    rev = version;
    hash = "sha256-Ba8wTlWVVuP99z9LmoDp2Hb0fg3i2924TLRT6b6WDPw=";
  };

  patches = [
    ./set-channel-for-nix.patch
  ];

  postPatch = ''
    substituteInPlace \
      setup.py \
      --replace \
      'version=determine_version()' \
      'version="${version}"'
  '';

  propagatedBuildInputs = with pkgs.python3Packages; [
    craft-cli
    craft-parts
    craft-providers
    craft-store
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

  # TODO: Try to make the tests pass and remove this.
  doCheck = false;

  meta = {
    description = "Build and publish Charmed Operators";
    homepage = "https://github.com/canonical/charmcraft";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}

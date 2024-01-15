{ pkgs
, lib
, ...
}:
let
  pname = "charmcraft";
  version = "2.5.4";
in
pkgs.python3Packages.buildPythonApplication {
  inherit pname version;

  src = pkgs.fetchFromGitHub {
    owner = "canonical";
    repo = pname;
    rev = version;
    hash = "sha256-u4Bn2skW2uGz34Yu30qTlDlFUIqB9izhzmZOZr67IcQ=";
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

  # TODO: Try to make the tests pass and remove this.
  doCheck = false;

  meta = {
    description = "Build and publish Charmed Operators";
    homepage = "https://github.com/canonical/charmcraft";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}

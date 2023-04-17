{ pkgs
, lib
, ...
}:
let
  pname = "charmcraft";
  version = "2.2.0";
in
pkgs.python3Packages.buildPythonApplication {
  pname = pname;
  version = version;

  src = pkgs.fetchFromGitHub {
    owner = "canonical";
    repo = "charmcraft";
    rev = version;
    sha256 = "sha256-D5G0CLLmrlVvqfA2sjuRtHX3BcfRj8w5boOlXz95ZGg=";
  };

  patches = [
    ./remove-cryptography-charmcraft.patch
    ./set-channel-for-nix.patch
  ];

  postPatch = ''
    substituteInPlace \
      charmcraft/__init__.py \
      --replace \
      'from .version import version as __version__  # noqa: F401 (imported but unused)' \
      '__version__ = "${version}"'
  '';

  propagatedBuildInputs = (with pkgs; [
    craft-cli
    craft-parts
    craft-providers
    craft-store
  ])
  ++ (with pkgs.python3Packages; [
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
  ]);

  # TODO: Try to make the tests pass and remove this.
  doCheck = false;
  # checkInputs = with pkgs.python3Packages; [
  #   pytest
  #   pytest-runner
  #   responses
  # ];

  meta = with lib; {
    description = "Build and publish Charmed Operators";
    homepage = "https://github.com/canonical/charmcraft";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ jnsgruk ];
  };
}

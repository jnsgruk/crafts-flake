{ pkgs
, lib
, ...
}:
let
  name = "charmcraft";
  version = "2.3.0";
in
pkgs.python3Packages.buildPythonApplication {
  name = name;
  version = version;

  src = pkgs.fetchFromGitHub {
    owner = "canonical";
    repo = "charmcraft";
    rev = version;
    sha256 = "sha256-kkA7+5+SgsaKADw5F2X3HyPpIsp+aYFhG6S5drjOF9M=";
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

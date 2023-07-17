{ pkgs
, lib
, ...
}:
let
  pname = "snapcraft";
  version = "7.5.0";
in
pkgs.python3Packages.buildPythonApplication {
  inherit pname version;

  src = pkgs.fetchFromGitHub {
    owner = "snapcore";
    repo = pname;
    rev = version;
    sha256 = "sha256-Wxjsw4j+fGY4nC2Of5Y5zjwOTRg7Jky9KGXUDyZwrvc=";
  };

  patches = [
    ./set-channel-for-nix.patch
    ./snapcraft-data-dirs.patch
  ];

  postPatch = ''
    substituteInPlace \
      setup.py \
      --replace 'version=determine_version()' 'version="${version}"' \
      --replace 'setuptools<66' 'setuptools' \
      --replace 'jsonschema==2.5.1' 'jsonschema' \
      --replace 'craft-archives==0.0.3' 'craft-archives'
  '';

  propagatedBuildInputs = with pkgs.python3Packages; [
    attrs
    catkin-pkg
    click
    craft-archives
    craft-cli
    craft-grammar
    craft-parts
    craft-providers
    craft-store
    debian
    gnupg
    jsonschema
    launchpadlib
    lazr-restfulclient
    lxml
    macaroon-bakery
    mypy-extensions
    progressbar
    pyelftools
    pylxd
    raven
    requests-toolbelt
    setuptools
    simplejson
    snap-helpers
    tabulate
    tinydb
  ];

  # TODO: Try to make the tests pass and remove this.
  doCheck = false;

  meta = {
    description = "Package, distribute, and update any app for Linux and IoT.";
    homepage = "https://github.com/snapcore/snapcraft";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}

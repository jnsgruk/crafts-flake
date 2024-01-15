{ pkgs
, lib
, ...
}:
let
  pname = "snapcraft";
  version = "8.0.1";
in
pkgs.python3Packages.buildPythonApplication {
  inherit pname version;

  src = pkgs.fetchFromGitHub {
    owner = "snapcore";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-V7Wmp43M2/cmI8/60ydgX/wOFfZIksA0HAWwGLBVPFA=";
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
      --replace 'jsonschema==2.5.1' 'jsonschema'

    substituteInPlace \
      snapcraft/__init__.py \
      --replace '__version__ = _get_version()' '__version__ = "${version}"'

    substituteInPlace \
      snapcraft_legacy/__init__.py \
      --replace '__version__ = _get_version()' '__version__ = "${version}"'
  '';

  buildInputs = with pkgs; [ makeWrapper ];

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
    pygit2
    pylxd
    raven
    requests-toolbelt
    setuptools
    simplejson
    snap-helpers
    tabulate
    tinydb
  ];

  postInstall = ''
    wrapProgram $out/bin/snapcraft --prefix PATH : ${pkgs.squashfsTools}/bin
  '';

  # TODO: Try to make the tests pass and remove this.
  doCheck = false;

  meta = {
    description = "Package, distribute, and update any app for Linux and IoT.";
    homepage = "https://github.com/snapcore/snapcraft";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}

{ pkgs
, lib
, ...
}:
let
  version = "8.0.4";
in
pkgs.python3Packages.buildPythonApplication {
  inherit version;
  pname = "snapcraft";

  src = pkgs.fetchFromGitHub {
    owner = "canonical";
    repo = "snapcraft";
    rev = "refs/tags/${version}";
    sha256 = "sha256-M2uhhUq3bZRfZKARU0qYoXdBj5br5nj+2rfGZ73QSLE=";
  };

  patches = [
    ./lxd-socket-path.patch
    ./os-platform.patch
    ./set-channel-for-nix.patch
    ./snapcraft-data-dirs.patch
  ];

  postPatch = ''
    substituteInPlace \
      setup.py \
      --replace-fail 'version=determine_version()' 'version="${version}"' \
      --replace-fail 'jsonschema==2.5.1' 'jsonschema'

    substituteInPlace \
      snapcraft/__init__.py \
      --replace-fail '__version__ = _get_version()' '__version__ = "${version}"'

    substituteInPlace \
      snapcraft_legacy/__init__.py \
      --replace-fail '__version__ = _get_version()' '__version__ = "${version}"'

    substituteInPlace snapcraft/elf/elf_utils.py \
      --replace-fail 'linker_path = root_path / arch_config.dynamic_linker' \
                'linker_path = Path("${pkgs.glibc}/lib/ld-linux-x86-64.so.2")'
  '';

  buildInputs = with pkgs; [ makeWrapper ];

  propagatedBuildInputs = with pkgs.python3Packages; [
    attrs
    apt
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

  doCheck = false;

  meta = {
    description = "Package, distribute, and update any app for Linux and IoT.";
    homepage = "https://github.com/snapcore/snapcraft";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}

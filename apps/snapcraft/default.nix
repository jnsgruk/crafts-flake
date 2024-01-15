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
    ./os-platform.patch
    ./set-channel-for-nix.patch
    ./snapcraft-data-dirs.patch
    ./tests-patch.patch
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

    substituteInPlace snapcraft/elf/elf_utils.py \
      --replace 'linker_path = root_path / arch_config.dynamic_linker' \
                'linker_path = Path("${pkgs.glibc}/lib/ld-linux-x86-64.so.2")'
      
    substituteInPlace tests/unit/linters/test_classic_linter.py \
      --replace '"/lib/x86_64-linux-gnu/libdl.so.2"' '"${pkgs.glibc}/lib/libdl.so.2"'
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

  preCheck = ''
    mkdir -p check-phase
    export HOME=$(pwd)/check-phase
  '';

  nativeCheckInputs = with pkgs.python3Packages; [
    pytest-check
    pytest-cov
    pytest-mock
    pytest-subprocess
    pytestCheckHook
  ] ++ (with pkgs; [
    git
    squashfsTools
  ]);

  disabledTestPaths = [
    "tests/legacy/unit"
    "tests/unit/elf"
  ];

  disabledTests = [
    "test_bin_echo"
    "test_classic_linter_filter"
    "test_classic_linter"
    "test_get_base_configuration_snap_channel"
    "test_get_base_configuration_snap_instance_name_default"
    "test_get_base_configuration_snap_instance_name_not_running_as_snap"
    "test_get_extensions_data_dir"
    "test_get_os_platform_alternative_formats"
    "test_get_os_platform_linux"
    "test_get_os_platform_windows"
    "test_patch_elf"
    "test_remote_builder_init"
    "test_setup_assets_remote_icon"
    "test_validate_architectures_supported"
    "test_validate_architectures_unsupported"
  ];

  meta = {
    description = "Package, distribute, and update any app for Linux and IoT.";
    homepage = "https://github.com/snapcore/snapcraft";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}

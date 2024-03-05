{ pkgs
, lib
, ...
}:
let
  version = "2.5.5";
in
pkgs.python3Packages.buildPythonApplication {
  inherit version;
  pname = "charmcraft";

  src = pkgs.fetchFromGitHub {
    owner = "canonical";
    repo = "charmcraft";
    rev = version;
    hash = "sha256-MuHj7ZoOy/M4Paa9d+aywKwdpa7MTGETmPILizTlPzQ=";
  };

  postPatch = ''
    substituteInPlace \
      setup.py \
      --replace-fail \
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

  preCheck = ''
    mkdir -p check-phase
    export HOME=$(pwd)/check-phase
  '';

  nativeCheckInputs = with pkgs.python3Packages; [
    flake8
    pydocstyle
    pyfakefs
    pytest-check
    pytest-mock
    pytest-subprocess
    pytestCheckHook
    responses
  ] ++ (with pkgs; [
    git
  ]);

  disabledTests = [
    # Relies upon the `charm` tool being installed
    "test_validate_missing_charm"
    # This tests something which is patched out anyway
    "test_setup_version"
    "test_localdockerinterface_get_streamed_content"
    # Relies upon building a venv using an internet connection, and running
    # commands in tox.
    "test_tests"
    # Pydantic model violations - fail because tests rely upon host system
    # attributes being compatible with Ubuntu.
    "test_build_error_without_metadata_yaml"
    "test_build_checks_provider"
    "test_build_checks_provider_error"
    "test_build_postlifecycle_validation_is_properly_called"
    "test_build_part_from_config"
    "test_build_part_include_venv_pydeps"
  ];

  meta = {
    description = "Build and publish Charmed Operators";
    homepage = "https://github.com/canonical/charmcraft";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}

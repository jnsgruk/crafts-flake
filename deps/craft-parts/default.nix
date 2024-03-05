{ pkgs
, lib
, ...
}:
let
  pname = "craft-parts";
  version = "1.26.2";
in
pkgs.python3Packages.buildPythonPackage rec {
  inherit pname version;

  src = pkgs.fetchFromGitHub {
    owner = "canonical";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-wHv0JWffS916RK4Kgk+FuRthx+ajh0Ka4DBwGrLdUBs=";
  };

  patches = [
    ./bash-path.patch
  ];

  propagatedBuildInputs = with pkgs.python3Packages;[
    overrides
    pydantic
    pydantic-yaml
    pyxdg
    pyyaml
    requests
    requests-unixsocket
    types-pyyaml
  ];

  preCheck = ''
    mkdir -p check-phase
    export HOME=$(pwd)/check-phase
  '';

  nativeCheckInputs = with pkgs.python3Packages; [
    hypothesis
    pytest-check
    pytest-mock
    pytest-subprocess
    pytestCheckHook
    requests-mock
  ] ++ (with pkgs; [
    bashInteractive
    git
    squashfsTools
  ]);

  disabledTestPaths = [
    "tests/integration"
    "tests/unit/packages"
    "tests/unit/test_xattrs.py"
  ];

  disabledTests = [
    "test_get_build_packages_with_source_type"
    "test_get_build_packages"
    "test_mode"
    "test_run_builtin_build"
    "test_run_prime"
  ];

  meta = {
    description = "Software artifact parts builder from Canonical.";
    homepage = "https://github.com/canonical/craft-parts";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}

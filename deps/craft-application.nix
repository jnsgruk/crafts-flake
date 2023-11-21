{ pkgs
, lib
, ...
}:
let
  pname = "craft-application";
  version = "1.0.0";
in
pkgs.python3Packages.buildPythonPackage rec {
  inherit pname version;
  format = "pyproject";

  src = pkgs.fetchFromGitHub {
    owner = "canonical";
    repo = pname;
    rev = version;
    sha256 = "sha256-y6nvfSnUlxoy6Qjbxkub14cHCcp4iz6uJ489VQYVSxI=";
  };

  patches = [
    # ./pyproject_version.patch
  ];

  postPatch = ''
    substituteInPlace craft_application/__init__.py \
      --replace "dev" "${version}"
    
    substituteInPlace pyproject.toml \
      --replace "setuptools==67.7.2" "setuptools" \
      # --replace "CRAFTS_FLAKE_VERSION" "${version}"
  '';

  propagatedBuildInputs = with pkgs.python3Packages; [
    craft-cli
    craft-parts
    craft-providers
    pydantic
    pydantic-yaml
    pyyaml
    pyxdg
    setuptools
    setuptools-scm
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  doCheck = false;

  meta = {
    description = " The basis for *craft applications.";
    homepage = " https://github.com/canonical/craft-application ";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}


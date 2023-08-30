{ pkgs
, lib
, ...
}:
let
  pname = "pydantic_yaml";
  version = "0.11.2";
in
pkgs.python3Packages.buildPythonPackage rec {
  inherit pname version;
  format = "pyproject";

  src = pkgs.python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-GcjzyalwQbCj2PwGylFD/3HAhGxFs5/ecZz7yYvnoAw=";
  };

  postPatch = ''
    substituteInPlace src/pydantic_yaml/__init__.py \
      --replace "0.0.0" "${version}"
    
    substituteInPlace pyproject.toml \
      --replace "setuptools==67.7.2" "setuptools"
  '';

  propagatedBuildInputs = with pkgs.python3Packages; [
    deprecated
    importlib-metadata
    pydantic
    semver
    types-deprecated
    setuptools
    setuptools-scm
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  doCheck = false;

  meta = {
    description = "A small helper library that adds some YAML capabilities to pydantic.";
    homepage = "https://github.com/NowanIlfideme/pydantic-yaml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}

{ pkgs
, lib
, ...
}: pkgs.python3Packages.buildPythonPackage rec {
  pname = "pydantic_yaml";
  version = "0.11.2";

  src = pkgs.python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-GcjzyalwQbCj2PwGylFD/3HAhGxFs5/ecZz7yYvnoAw=";
  };

  propagatedBuildInputs = with pkgs.python3Packages; [
    deprecated
    importlib-metadata
    pydantic
    semver
    types-deprecated
  ];

  doCheck = false;

  meta = {
    description = "A small helper library that adds some YAML capabilities to pydantic.";
    homepage = "https://github.com/NowanIlfideme/pydantic-yaml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}

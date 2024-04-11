{ pkgs, lib, ... }:
let
  pname = "snap-helpers";
  version = "0.4.2";
in
pkgs.python3Packages.buildPythonPackage rec {
  inherit pname version;
  format = "pyproject";

  src = pkgs.python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-7zuGIeMxu3Gv4n5U73QqfdLt2egCavrChb60IQnIuak=";
  };

  propagatedBuildInputs = with pkgs.python3Packages; [
    packaging
    pyyaml
    setuptools
  ];

  doCheck = false;

  meta = {
    description = "Interact with snap configuration and properties from inside a snap.";
    homepage = "https://github.com/albertodonato/snap-helpers";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}

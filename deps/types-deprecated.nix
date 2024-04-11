{ pkgs, lib, ... }:
let
  pname = "types-Deprecated";
  version = "1.2.9.3";
in
pkgs.python3Packages.buildPythonPackage rec {
  inherit pname version;

  src = pkgs.python3Packages.fetchPypi {
    inherit version pname;
    sha256 = "sha256-74cyet8+PEpMfY4G5Y9kdnENNGbs+1PEnvsICASnDvM=";
  };

  doCheck = false;

  meta = {
    description = "Typing stubs for Deprecated.";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}

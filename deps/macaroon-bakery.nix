{ pkgs
, lib
, ...
}:
let
  pname = "macaroonbakery";
  version = "1.3.4";
in
pkgs.python3Packages.buildPythonPackage rec {
  inherit pname version;

  src = pkgs.python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-QcqZOiPk+O8v53I7XNSjDHWXNfHVAh6ZB3DIoODzOXA=";
  };

  propagatedBuildInputs = with pkgs.python3Packages; [
    protobuf3
    pymacaroons
    pynacl
    pyRFC3339
    requests
  ];

  doCheck = false;

  meta = {
    description = "A Python library for working with macaroons.";
    homepage = "https://github.com/go-macaroon-bakery/py-macaroon-bakery";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}

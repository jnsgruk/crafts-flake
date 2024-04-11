{ pkgs, lib, ... }:
let
  pname = "spdx-lookup";
  version = "0.3.3";
in
pkgs.python3Packages.buildPythonPackage rec {
  inherit pname version;

  src = pkgs.python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-1B4I7Ou5pnIOix3/AptDgCydkp4G3LZIrqWLqT2PEl4=";
  };

  propagatedBuildInputs = with pkgs.python3Packages; [ spdx ];

  doCheck = false;

  meta = {
    description = "SPDX license list query tool";
    homepage = "https://pypi.python.org/pypi/spdx-lookup";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}

{ pkgs
, lib
, ...
}: pkgs.python3Packages.buildPythonPackage rec {
  pname = "spdx-lookup";
  version = "0.3.3";

  src = pkgs.python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-1B4I7Ou5pnIOix3/AptDgCydkp4G3LZIrqWLqT2PEl4=";
  };

  propagatedBuildInputs = with pkgs.python3Packages; [
    spdx
  ];

  doCheck = false;

  meta = with lib; {
    description = "SPDX license list query tool";
    homepage = "https://pypi.python.org/pypi/spdx-lookup";
    license = licenses.bsd2;
    maintainers = with maintainers; [ jnsgruk ];
  };
}

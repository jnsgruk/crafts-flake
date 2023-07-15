{ pkgs
, lib
, ...
}: pkgs.python3Packages.buildPythonPackage rec {
  pname = "spdx";
  version = "2.5.1";

  src = pkgs.python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-TXNLC8xsnsNNI4YhYzvS/6W0J3OwVcvgsY6SXh7gObk=";
  };

  doCheck = false;

  meta = {
    description = "SPDX license list database";
    homepage = "https://github.com/bbqsrc/spdx-python";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}

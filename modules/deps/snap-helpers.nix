{ pkgs
, lib
, ...
}: pkgs.python3Packages.buildPythonPackage rec {
  pname = "snap-helpers";
  version = "0.3.2";

  src = pkgs.python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-Qd5qOAh71KPkbb1bvdBMWwiLnE3BuDWxVxWu1QOwhfk=";
  };

  propagatedBuildInputs = with pkgs.python3Packages; [
    packaging
    pyyaml
  ];

  doCheck = false;

  meta = {
    description = "Interact with snap configuration and properties from inside a snap.";
    homepage = "https://github.com/albertodonato/snap-helpers";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}

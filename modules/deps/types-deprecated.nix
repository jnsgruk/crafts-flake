{ pkgs
, lib
, ...
}: pkgs.python3Packages.buildPythonPackage rec {
  pname = "types-Deprecated";
  version = "1.2.9";

  src = pkgs.python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-4EzliSlQmGU1npHcw4cgEjJitM1o+iqKkDEtUDkLtvo=";
  };

  meta = {
    description = "Typing stubs for Deprecated.";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}

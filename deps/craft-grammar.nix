{ pkgs, lib, ... }:
let
  pname = "craft-grammar";
  version = "1.1.2";
in
pkgs.python3Packages.buildPythonPackage rec {
  inherit pname version;

  src = pkgs.fetchFromGitHub {
    owner = "canonical";
    repo = pname;
    rev = version;
    sha256 = "sha256-23KLIO2yHXGe/zb3B8LirJsh+LY9z0c5ZGtF392Kszo=";
  };

  propagatedBuildInputs = with pkgs.python3Packages; [ overrides ];

  doCheck = false;

  meta = {
    description = "Advanced grammar for parts.";
    homepage = "https://github.com/canonical/craft-grammar";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}

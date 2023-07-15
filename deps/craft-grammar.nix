{ pkgs
, lib
, ...
}:
let
  pname = "craft-grammar";
  version = "697e4ddc1f51de0ca02b349977439e37cff5bdfb";
in
pkgs.python3Packages.buildPythonPackage rec {
  inherit pname version;

  src = pkgs.fetchFromGitHub {
    owner = "canonical";
    repo = pname;
    rev = version;
    sha256 = "sha256-rfsrbcCABuEVqG24GK4bzZBAm2u2obTbLjZpEB8Xnhc=";
  };

  propagatedBuildInputs = with pkgs.python3Packages; [
    overrides
  ];

  doCheck = false;

  meta = {
    description = "Advanced grammar for parts.";
    homepage = "https://github.com/canonical/craft-grammar";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}

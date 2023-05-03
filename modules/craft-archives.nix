{ pkgs
, lib
, ...
}: pkgs.python3Packages.buildPythonPackage rec {
  pname = "craft-archives";
  version = "0.0.3";
  format = "pyproject";

  src = pkgs.fetchFromGitHub {
    owner = "canonical";
    repo = "craft-archives";
    rev = "v${version}";
    sha256 = "sha256-KtBiiBb1CgmHVlzaegvTEsVWXDKD3hu/uJPAKto671w=";
  };

  propagatedBuildInputs = with pkgs.python3Packages;[
    gnupg
    launchpadlib
    lazr-restfulclient
    overrides
    pydantic
    setuptools
  ];

  doCheck = false;

  meta = with lib; {
    description = "A library for handling archives/repositories in Craft applications";
    homepage = "https://github.com/canonical/craft-archives";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ jnsgruk ];
  };
}

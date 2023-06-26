{ pkgs
, lib
, ...
}: pkgs.python3Packages.buildPythonPackage rec {
  pname = "craft-archives";
  version = "1.1.0";
  format = "pyproject";

  src = pkgs.fetchFromGitHub {
    owner = "canonical";
    repo = "craft-archives";
    rev = "v${version}";
    sha256 = "sha256-jyCTHuPS8qvPWMtvcY/GQK0NXlTObnyKHQzN2R1VikI=";
  };

  postPatch = ''
    substituteInPlace \
      craft_archives/__init__.py \
      --replace \
      'dev' \
      '${version}'
  '';

  propagatedBuildInputs = with pkgs.python3Packages;[
    gnupg
    launchpadlib
    lazr-restfulclient
    overrides
    pydantic
    setuptools
    setuptools-scm
    tabulate
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  doCheck = false;

  meta = with lib; {
    description = "A library for handling archives/repositories in Craft applications";
    homepage = "https://github.com/canonical/craft-archives";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ jnsgruk ];
  };
}

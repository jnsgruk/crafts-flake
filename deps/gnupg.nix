{ pkgs
, lib
, ...
}: pkgs.python3Packages.buildPythonPackage rec {
  pname = "gnupg";
  version = "2.3.1";

  src = pkgs.fetchFromGitHub {
    owner = "isislovecruft";
    repo = "python-gnupg";
    rev = version;
    sha256 = "sha256-4ec3cFZU3bc6AYlQpf5hl8DyuHsrIJS4AsE+gmZKbss=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "versioneer.get_version()" "'2.3.1'"
  '';

  propagatedBuildInputs = with pkgs.python3Packages; [
    psutil
  ];

  doCheck = false;

  meta = {
    description = "A modified version of python-gnupg.";
    homepage = "https://github.com/isislovecruft/python-gnupg";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}

{ pkgs, lib, ... }:
let
  pname = "apt";
  version = "2.7.6";
in
pkgs.python3Packages.buildPythonPackage rec {
  inherit pname version;

  src = pkgs.fetchgit {
    url = "https://git.launchpad.net/python-apt";
    rev = "refs/tags/${version}";
    sha256 = "sha256-1jTe8ncMKV78+cfSZ6p6qdjxs0plZLB4VwVtPLtDlAc=";
  };

  # Ensure the version is set properly without trying to invoke
  # dpkg-parsechangelog
  env.DEBVER = "${version}";

  buildInputs = with pkgs; [ apt.dev ];

  doCheck = false;

  meta = {
    description = "Python bindings for APT";
    homepage = "https://launchpad.net/python-apt";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}

{ pkgs
, lib
, ...
}:
let
  pname = "catkin-pkg";
  version = "0.5.2";
in
pkgs.python3Packages.buildPythonPackage rec {
  inherit pname version;

  src = pkgs.fetchFromGitHub {
    owner = "ros-infrastructure";
    repo = "catkin_pkg";
    rev = version;
    sha256 = "sha256-DjaPpLDsLpYOZukf5tYe6ZetSNTe/DJ2lS9BUsehZ8k=";
  };

  propagatedBuildInputs = with pkgs.python3Packages;[
    docutils
    pyparsing
    python-dateutil
  ];

  doCheck = false;

  meta = {
    description = "Library for retrieving information about catkin packages.";
    homepage = "http://wiki.ros.org/catkin_pkg";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}

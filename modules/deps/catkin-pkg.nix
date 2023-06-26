{ pkgs
, lib
, ...
}: pkgs.python3Packages.buildPythonPackage rec {
  pname = "catkin-pkg";
  version = "0.5.2";

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

  meta = with lib; {
    description = "Library for retrieving information about catkin packages.";
    homepage = "http://wiki.ros.org/catkin_pkg";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jnsgruk ];
  };
}

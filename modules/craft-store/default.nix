{ pkgs
, lib
, ...
}: pkgs.python3Packages.buildPythonPackage rec {
  pname = "craft-store";
  # Version 2.4.0 - no tag was created for this release
  version = "d16851676d6ff632d063ed5e6199dc0d8aca93c7";

  src = pkgs.fetchFromGitHub {
    owner = "canonical";
    repo = "craft-store";
    rev = version;
    sha256 = "sha256-i/d4EzrpFbv51z+qkCse7te0fIlotdBbGIjFsQwmzcw=";
  };

  propagatedBuildInputs = with pkgs.python3Packages; [
    keyring
    macaroon-bakery
    overrides
    pydantic
    requests
    requests-toolbelt
  ];

  doCheck = false;

  meta = {
    description = "Python interfaces for communicating with Canonical Stores, such as Charmhub and the Snap Store.";
    homepage = "https://github.com/canonical/craft-store";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}

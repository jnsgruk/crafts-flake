{
  pkgs,
  lib,
  pydantic,
  ...
}: let
  macaroon-bakery = pkgs.callPackage ../deps/macaroon-bakery.nix {};
  overrides = pkgs.callPackage ../deps/overrides.nix {};
in
  pkgs.python3Packages.buildPythonPackage rec {
    pname = "craft-store";
    version = "2.3.0";

    src = pkgs.fetchFromGitHub {
      owner = "canonical";
      repo = "craft-store";
      rev = version;
      sha256 = "sha256-XPPZKhWQwedOo7rpY8WL/UfnNbaH4afL+BJub30owTg=";
    };

    propagatedBuildInputs =
      [
        macaroon-bakery
        overrides
        pydantic
      ]
      ++ (with pkgs.python3Packages; [
        keyring
        requests
        requests-toolbelt
      ]);

    doCheck = false;

    meta = with lib; {
      description = "Python interfaces for communicating with Canonical Stores, such as Charmhub and the Snap Store.";
      homepage = "https://github.com/canonical/craft-store";
      license = licenses.lgpl3;
      maintainers = with maintainers; [jnsgruk];
    };
  }

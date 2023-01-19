{
  description = "⭐craft flake for ⭐craft applications and libraries.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }: let
    pythonVersion = "python39";
  in
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        charmcraft = pkgs.callPackage ./modules/charmcraft {};
      in rec {
        packages = {
          charmcraft = charmcraft;
          default = packages.charmcraft;
        };

        apps.default = {
          type = "app";
          program = "${packages.charmcraft}/bin/charmcraft";
        };
      }
    );
}

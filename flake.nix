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
        # TODO: Uncomment once the Pydantic overlay is used properly
        # craft-cli = pkgs.callPackage ./modules/craft-cli.nix {};
        # craft-parts = pkgs.callPackage ./modules/craft-parts.nix {};
        # craft-providers = pkgs.callPackage ./modules/craft-providers {};
        # craft-store = pkgs.callPackage ./modules/craft-store {};
      in rec {
        packages = {
          charmcraft = charmcraft;

          # TODO: Uncomment once the Pydantic overlay is used properly
          # craft-cli = craft-cli;
          # craft-parts = craft-parts;
          # craft-providers = craft-providers;
          # craft-store = craft-store;

          default = packages.charmcraft;
        };

        apps.default = {
          type = "app";
          program = "${packages.charmcraft}/bin/charmcraft";
        };
      }
    );
}

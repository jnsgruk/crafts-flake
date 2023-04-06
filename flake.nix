{
  description = "⭐craft applications and libraries flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , ...
    }:
    let
      inherit (self) outputs;
      pythonVersion = "python39";
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      rec {
        packages = {
          charmcraft = pkgs.callPackage ./modules/charmcraft { inherit outputs; };

          craft-cli = pkgs.callPackage ./modules/craft-cli.nix { inherit outputs; };
          craft-parts = pkgs.callPackage ./modules/craft-parts.nix { inherit outputs; };
          craft-providers = pkgs.callPackage ./modules/craft-providers { inherit outputs; };
          craft-store = pkgs.callPackage ./modules/craft-store { inherit outputs; };

          default = packages.charmcraft;
        };

        apps.default = {
          type = "app";
          program = "${packages.charmcraft}/bin/charmcraft";
        };

        overlays = {
          pydantic = import ./overlays/pydantic.nix { inherit pkgs; };
        };
      }
    );
}

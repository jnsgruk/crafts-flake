{
  description = "⭐craft applications and libraries flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self
    , nixpkgs
    , ...
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        # "aarch64-linux"
        # "x86_64-darwin"
        # "aarch64-darwin"
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);

      pkgsForSystem = system: (import nixpkgs {
        inherit system;
        overlays = [ self.overlay ];
      });
    in
    rec {
      overlay = final: prev: rec {
        pythonPackagesOverlays = (prev.pythonPackagesOverlays or [ ]) ++ [
          (python-final: python-prev: {
            gnupg = python-final.callPackage ./modules/deps/gnupg.nix { };
            macaroon-bakery = python-final.callPackage ./modules/deps/macaroon-bakery.nix { };
            overrides = python-final.callPackage ./modules/deps/overrides.nix { };
            pydantic-yaml = python-final.callPackage ./modules/deps/pydantic-yaml.nix { };
            snap-helpers = python-final.callPackage ./modules/deps/snap-helpers.nix { };
            spdx = python-final.callPackage ./modules/deps/spdx.nix { };
            spdx-lookup = python-final.callPackage ./modules/deps/spdx-lookup.nix { };
            types-deprecated = python-final.callPackage ./modules/deps/types-deprecated.nix { };
          })
        ];

        python3 =
          let
            self = prev.python3.override {
              inherit self;
              packageOverrides = prev.lib.composeManyExtensions final.pythonPackagesOverlays;
            };
          in
          self;

        python3Packages = final.python3.pkgs;

        craft-archives = final.callPackage ./modules/craft-archives.nix { };
        craft-cli = final.callPackage ./modules/craft-cli.nix { };
        craft-parts = final.callPackage ./modules/craft-parts.nix { };
        craft-providers = final.callPackage ./modules/craft-providers { };
        craft-store = final.callPackage ./modules/craft-store { };

        charmcraft = final.callPackage ./modules/charmcraft { };
        rockcraft = final.callPackage ./modules/rockcraft { };
      };

      packages = forAllSystems (system: {
        inherit (pkgsForSystem system) charmcraft rockcraft;
      });
    };
}

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
            catkin-pkg = python-final.callPackage ./modules/deps/catkin-pkg.nix { };
            craft-archives = final.callPackage ./modules/craft-archives.nix { };
            craft-cli = final.callPackage ./modules/craft-cli.nix { };
            craft-grammar = final.callPackage ./modules/craft-grammar.nix { };
            craft-parts = final.callPackage ./modules/craft-parts.nix { };
            craft-providers = final.callPackage ./modules/craft-providers { };
            craft-store = final.callPackage ./modules/craft-store { };
            gnupg = python-final.callPackage ./modules/deps/gnupg.nix { };
            macaroon-bakery = python-final.callPackage ./modules/deps/macaroon-bakery.nix { };
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


        charmcraft = final.callPackage ./modules/charmcraft { };
        rockcraft = final.callPackage ./modules/rockcraft { };
        snapcraft = final.callPackage ./modules/snapcraft { };
      };

      packages = forAllSystems (system: {
        inherit (pkgsForSystem system) charmcraft rockcraft snapcraft;
      });
    };
}

{
  description = "⭐craft applications and libraries flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nix-formatter-pack.url = "github:Gerschtli/nix-formatter-pack";
    nix-formatter-pack.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self
    , nixpkgs
    , nix-formatter-pack
    , ...
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        # "aarch64-linux"
        # "x86_64-darwin"
        # "aarch64-darwin"
      ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      pkgsForSystem = system: (import nixpkgs {
        inherit system;
        overlays = [ self.overlay ];
      });
    in
    rec {
      overlay = final: prev: rec {
        pythonPackagesOverlays = (prev.pythonPackagesOverlays or [ ]) ++ [
          (python-final: _python-prev: {
            catkin-pkg = python-final.callPackage ./deps/catkin-pkg.nix { };
            craft-archives = final.callPackage ./deps/craft-archives.nix { };
            craft-cli = final.callPackage ./deps/craft-cli.nix { };
            craft-grammar = final.callPackage ./deps/craft-grammar.nix { };
            craft-parts = final.callPackage ./deps/craft-parts.nix { };
            craft-providers = final.callPackage ./deps/craft-providers { };
            craft-store = final.callPackage ./deps/craft-store { };
            gnupg = python-final.callPackage ./deps/gnupg.nix { };
            macaroon-bakery = python-final.callPackage ./deps/macaroon-bakery.nix { };
            pydantic-yaml = python-final.callPackage ./deps/pydantic-yaml.nix { };
            snap-helpers = python-final.callPackage ./deps/snap-helpers.nix { };
            spdx = python-final.callPackage ./deps/spdx.nix { };
            spdx-lookup = python-final.callPackage ./deps/spdx-lookup.nix { };
            types-deprecated = python-final.callPackage ./deps/types-deprecated.nix { };
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


        charmcraft = final.callPackage ./apps/charmcraft { };
        rockcraft = final.callPackage ./apps/rockcraft { };
        snapcraft = final.callPackage ./apps/snapcraft { };
      };

      packages = forAllSystems (system: {
        inherit (pkgsForSystem system) charmcraft rockcraft snapcraft;
      });

      formatter = forAllSystems (system:
        nix-formatter-pack.lib.mkFormatter {
          pkgs = nixpkgs.legacyPackages.${system};
          config.tools = {
            deadnix.enable = true;
            nixpkgs-fmt.enable = true;
            statix.enable = true;
          };
        }
      );
    };
}

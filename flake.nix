{
  description = "⭐craft applications and libraries flake";

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
            macaroon-bakery = python-final.callPackage ./modules/deps/macaroon-bakery.nix { };
            overrides = python-final.callPackage ./modules/deps/overrides.nix { };
            pydantic-yaml = python-final.callPackage ./modules/deps/pydantic-yaml.nix { };
            snap-helpers = python-final.callPackage ./modules/deps/snap-helpers.nix { };
            types-deprecated = python-final.callPackage ./modules/deps/types-deprecated.nix { };

            pydantic = python-prev.pydantic.overridePythonAttrs (_: rec {
              pname = "pydantic";
              version = "1.9.0";
              src = final.fetchFromGitHub {
                owner = "samuelcolvin";
                repo = pname;
                rev = "refs/tags/v${version}";
                sha256 = "sha256-C4WP8tiMRFmkDkQRrvP3yOSM2zN8pHJmX9cdANIckpM=";
              };
            });
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

        craft-cli = final.callPackage ./modules/craft-cli.nix { };
        craft-parts = final.callPackage ./modules/craft-parts.nix { };
        craft-providers = final.callPackage ./modules/craft-providers { };
        craft-store = final.callPackage ./modules/craft-store { };

        charmcraft = final.callPackage ./modules/charmcraft { };
      };

      packages = forAllSystems (system: {
        inherit (pkgsForSystem system) charmcraft;
      });
    };
}

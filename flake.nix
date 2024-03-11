{
  description = "⭐craft applications and libraries flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
      ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      pkgsForSystem = system: (import nixpkgs {
        inherit system;
        overlays = [ self.overlay ];
      });
    in
    {
      overlay = final: prev: {
        pythonPackagesOverlays = (prev.pythonPackagesOverlays or [ ]) ++ [
          (_python-final: python_prev: {
            apt = final.callPackage ./deps/apt.nix { };
            catkin-pkg = final.callPackage ./deps/catkin-pkg.nix { };
            craft-application = final.callPackage ./deps/craft-application.nix { };
            craft-archives = final.callPackage ./deps/craft-archives.nix { };
            craft-cli = final.callPackage ./deps/craft-cli.nix { };
            craft-grammar = final.callPackage ./deps/craft-grammar.nix { };
            craft-parts = final.callPackage ./deps/craft-parts { };
            craft-providers = final.callPackage ./deps/craft-providers { };
            craft-store = final.callPackage ./deps/craft-store.nix { };
            gnupg = final.callPackage ./deps/gnupg.nix { };
            macaroon-bakery = final.callPackage ./deps/macaroon-bakery.nix { };
            pydantic-yaml = final.callPackage ./deps/pydantic-yaml.nix { };
            snap-helpers = final.callPackage ./deps/snap-helpers.nix { };
            spdx = final.callPackage ./deps/spdx.nix { };
            spdx-lookup = final.callPackage ./deps/spdx-lookup.nix { };
            types-deprecated = final.callPackage ./deps/types-deprecated.nix { };

            pydantic = python_prev.pydantic_1;

            # versioningit 2.2.1 migrated to pydantic 2, which is incompatible with the
            # craft applications and libraries.
            versioningit = python_prev.versioningit.overridePythonAttrs (_oldAttrs: rec {
              version = "2.2.0";
              src = prev.fetchFromGitHub {
                owner = "jwodder";
                repo = "versioningit";
                rev = "refs/tags/v${version}";
                hash = "sha256-sM5n02ewzysYNctXLamZHxJa+61D+xnYennprXjoiYc=";
              };
              doCheck = false;
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

        charmcraft = final.callPackage ./apps/charmcraft { };
        rockcraft = final.callPackage ./apps/rockcraft { };
        snapcraft = final.callPackage ./apps/snapcraft { };

        # A virtual machine for integration testing the crafts
        testVm = self.nixosConfigurations.testvm.config.system.build.vm;
        # Helper script for running commands inside the test VM when it's running on a host.
        testVmExec = final.writeShellApplication {
          name = "vmExec";
          runtimeInputs = with final.pkgs; [ sshpass ];
          text = builtins.readFile ./test/vm-exec;
        };
      };

      packages = forAllSystems (system: {
        inherit (pkgsForSystem system) charmcraft rockcraft snapcraft testVm testVmExec;
      });

      # A minimal NixOS virtual machine which used for testing craft applications.
      nixosConfigurations = {
        testvm = nixpkgs.lib.nixosSystem {
          specialArgs = { flake = self; };
          modules = [ ./test/vm.nix ];
        };
      };
    };
}

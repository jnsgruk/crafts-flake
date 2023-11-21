# crafts-flake

[![FlakeHub](https://img.shields.io/endpoint?url=https://flakehub.com/f/jnsgruk/crafts-flake/badge)](https://flakehub.com/flake/jnsgruk/crafts-flake)
[![tests](https://github.com/jnsgruk/crafts-flake/actions/workflows/ci.yaml/badge.svg)](https://github.com/jnsgruk/crafts-flake/actions/workflows/ci.yaml)

A [nix](https://nixos.org/) flake for the [Canonical](https://canonical.com) ⭐craft suite of tools.

## Quick start

The default package is charmcraft, which you can build/test with:

```bash
# Run charmcraft
$ nix run github:jnsgruk/crafts-flake#charmcraft

# Run rockcraft
$ nix run github:jnsgruk/crafts-flake#rockcraft

# Run snapcraft
$ nix run github:jnsgruk/crafts-flake#snapcraft
```

## Usage

First, add this flake to your flake's inputs

```nix
inputs = {
    # ...
    crafts.url = "github:jnsgruk/crafts-flake";
}
```

Ensure that you configure your system to use the included pkgs overlay:

```nix
nixpkgs = {
    overlays = [ inputs.crafts.overlay ]
};
```

Next, configure your system using the included packages:

```nix
{ pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    charmcraft
    rockcraft
    snapcraft
  ]
}
```

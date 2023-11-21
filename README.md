# crafts-flake

[![FlakeHub](https://img.shields.io/endpoint?url=https://flakehub.com/f/jnsgruk/crafts-flake/badge)](https://flakehub.com/flake/jnsgruk/crafts-flake)
[![tests](https://github.com/jnsgruk/crafts-flake/actions/workflows/ci.yaml/badge.svg)](https://github.com/jnsgruk/crafts-flake/actions/workflows/ci.yaml)

An experimental nix flake for the Canonical ⭐craft suite of tools.

## Quick start

The default package is charmcraft, which you can build/test with:

```bash
$ git clone https://github.com/jnsgruk/crafts-flake
$ cd crafts-flake

# Run charmcraft
$ nix run .#charmcraft

# Run rockcraft
$ nix run .#rockcraft

# Run snapcraft
$ nix run .#snapcraft
```

## TODO

- [x] Use a flake-wide overlay for Pydantic, unthread argument passing throughout
- [x] Fix race condition in Charmcraft that occurs when starting a LXD container
- [x] Add Rockcraft support
- [x] Add Starcraft support

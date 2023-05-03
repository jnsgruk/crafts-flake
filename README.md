# crafts-flake

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
```

## TODO

- [x] Use a flake-wide overlay for Pydantic, unthread argument passing throughout
- [x] Fix race condition in Charmcraft that occurs when starting a LXD container
- [x] Add Rockcraft support
- [ ] Add Starcraft support

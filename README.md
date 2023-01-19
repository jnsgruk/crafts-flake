# crafts-flake

> This is very much a work-in-progress!

An experimental nix flake for the Canonical ⭐craft suite of tools.

## Quick start

The default package is charmcraft, which you can build/test with:

```bash
$ git clone https://github.com/jnsgruk/crafts-flake
$ cd crafts-flake
$ nix run
```

## TODO

- [ ] Use a flake-wide overlay for Pydantic, unthread argument passing throughout
- [ ] Fix race condition in Charmcraft that occurs when starting a LXD container
- [ ] Add Starcraft support
- [ ] Add Rockcraft support

{ pkgs
, lib
, ...
}:
let
  pname = "rockcraft";
  version = "unstable-2023-10-24";
  rev = "1a8bbf6bd328c97ee47e6189011d269ee3617ce7";
in
pkgs.python3Packages.buildPythonApplication {
  inherit pname version rev;

  src = pkgs.fetchFromGitHub {
    inherit rev;
    owner = "canonical";
    repo = pname;
    sha256 = "sha256-37e6WSmkynUIEOdQ07Eut+RpncWANYpRFJKXtjhgs84=";
  };

  patches = [
    ./set-channel-for-nix.patch
  ];

  postPatch = ''
    substituteInPlace \
      rockcraft/__init__.py \
      --replace '__version__ = "0.0.1.dev1"' '__version__ = "0.0.1+g${builtins.substring 0 7 rev}"'
  '';

  propagatedBuildInputs = with pkgs.python3Packages; [
    craft-archives
    craft-cli
    craft-parts
    craft-providers
    gnupg
    spdx-lookup
  ];

  # TODO: Try to make the tests pass and remove this.
  doCheck = false;

  meta = {
    description = "Tool to create OCI Images using the language from Snapcraft and Charmcraft.";
    homepage = "https://github.com/canonical/rockcraft";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}

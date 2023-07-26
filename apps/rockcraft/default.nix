{ pkgs
, lib
, ...
}:
let
  pname = "rockcraft";
  version = "unstable-2023-07-26";
  rev = "d81be44494fea5fd16f4d4baf2a6cafa66bfb083";
in
pkgs.python3Packages.buildPythonApplication {
  inherit pname version rev;

  src = pkgs.fetchFromGitHub {
    inherit rev;
    owner = "canonical";
    repo = pname;
    sha256 = "sha256-Eo6blR9vDvdC37zIedyf9IPPh09XWBU9ECwPO6Ti4WQ=";
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

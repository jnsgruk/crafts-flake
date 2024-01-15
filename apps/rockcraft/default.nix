{ pkgs
, lib
, ...
}:
let
  pname = "rockcraft";
  version = "1.1.1";
in
pkgs.python3Packages.buildPythonApplication {
  inherit pname version;

  src = pkgs.fetchFromGitHub {
    owner = "canonical";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-mAPkFgaqDEo/Elt9tfY7f9zwkw580ZCrnCpV736zYo8=";
  };

  propagatedBuildInputs = with pkgs.python3Packages; [
    craft-application
    craft-archives
    craft-cli
    craft-parts
    craft-providers
    gnupg
    spdx-lookup
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  # TODO: Try to make the tests pass and remove this.
  doCheck = false;

  meta = {
    description = "Tool to create OCI Images using the language from Snapcraft and Charmcraft.";
    homepage = "https://github.com/canonical/rockcraft";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}

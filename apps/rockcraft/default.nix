{ pkgs
, lib
, ...
}:
let
  version = "1.2.1";
in
pkgs.python3Packages.buildPythonApplication {
  inherit version;
  pname = "rockcraft";

  src = pkgs.fetchFromGitHub {
    owner = "canonical";
    repo = "rockcraft";
    rev = "refs/tags/${version}";
    sha256 = "sha256-RpoyG44MKY5LqzjaTr1agDAHCO+KIzC1nN8pNWk8XEU=";
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

  doCheck = false;

  meta = {
    description = "Tool to create OCI Images using the language from Snapcraft and Charmcraft.";
    homepage = "https://github.com/canonical/rockcraft";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}

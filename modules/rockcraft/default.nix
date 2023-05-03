{ pkgs
, lib
, ...
}:
let
  name = "rockcraft";
  version = "2e0eddfb919558d5562969018bf12b688326fb89";
in
pkgs.python3Packages.buildPythonApplication {
  name = name;
  version = version;

  src = pkgs.fetchFromGitHub {
    owner = "canonical";
    repo = "rockcraft";
    rev = version;
    sha256 = "sha256-NduQKxxtB1WgixWpCdN5EZhHuBptmEqBeSnk7MwohLI=";
  };

  patches = [
    ./set-channel-for-nix.patch
  ];

  postPatch = ''
    substituteInPlace \
      setup.py \
      --replace \
      'version=determine_version()' \
      'version="${version}"'
  '';

  propagatedBuildInputs = (with pkgs; [
    craft-archives
    craft-cli
    craft-parts
    craft-providers
  ])
  ++ (with pkgs.python3Packages; [
    gnupg
    spdx-lookup
  ]);

  # TODO: Try to make the tests pass and remove this.
  doCheck = false;
  # checkInputs = with pkgs.python3Packages; [
  #   pytest
  #   pytest-runner
  #   responses
  # ];

  meta = with lib; {
    description = "Tool to create OCI Images using the language from Snapcraft and Charmcraft.";
    homepage = "https://github.com/canonical/rockcraft";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ jnsgruk ];
  };
}

{ pkgs }:
pkgs.python3.override {
  packageOverrides = self: super: {
    pydantic = super.pydantic.overridePythonAttrs (old: rec {
      pname = "pydantic";
      version = "1.9.0";
      src = pkgs.fetchFromGitHub {
        owner = "samuelcolvin";
        repo = pname;
        rev = "refs/tags/v${version}";
        sha256 = "sha256-C4WP8tiMRFmkDkQRrvP3yOSM2zN8pHJmX9cdANIckpM=";
      };
    });
  };
}

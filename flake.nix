{
  description = "Simple Flake to package pigpio";
  inputs = {
    utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    self,
    nixpkgs,
    utils,
  }:
    utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages.default = pkgs.python3Packages.buildPythonPackage rec {
          pname = "pigpio";
          version = "1.78";
          src = pkgs.fetchPypi {
            inherit pname version;
            hash = "sha256-ke+lDkmQZJ2pdAijhHgtbM9YNC/FnN/iHtekKRFWmXU=";
          };
        };
      }
    );
}

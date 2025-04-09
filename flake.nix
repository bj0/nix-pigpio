{
  description = "Simple Flake to package pigpio";
  inputs = {
    utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    self,
    nixpkgs,
    utils,
  }: let
    build = {
      buildPythonPackage,
      fetchPypi,
    }:
      buildPythonPackage rec {
        pname = "pigpio";
        version = "1.78";
        src = fetchPypi {
          inherit pname version;
          hash = "sha256-ke+lDkmQZJ2pdAijhHgtbM9YNC/FnN/iHtekKRFWmXU=";
        };
      };
  in
    utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        # system specific python3 package
        packages.default = build {
          inherit (pkgs.python3Packages) buildPythonPackage;
          inherit (pkgs) fetchPypi;
        };
      }
    )
    // {
      # system independent overlay
      overlays.default = _: prev: {
        pythonPackagesExtensions =
          prev.pythonPackagesExtensions
          ++ [
            (
              _: pyprev: {
                pigpio = build {
                  inherit (pyprev) buildPythonPackage;
                  inherit (prev) fetchPypi;
                };
              }
            )
          ];
      };
    };
}

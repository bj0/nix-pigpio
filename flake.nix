{
  description = "Simple Flake to package pigpio";
  outputs = _: let
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
  in {
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

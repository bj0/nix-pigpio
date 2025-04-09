This is a simple nixpkgs overlay that adds the [pigpio](https://pypi.org/project/pigpio/) python package.

This is a dependency of the [Raspberry Pi Remote GPIO integration of home-assistant](https://www.home-assistant.io/integrations/remote_rpi_gpio/).

## details

When using home-assistant as a [Native installation](https://wiki.nixos.org/wiki/Home_Assistant#Native_installation) in NixOS, you will get `ModuleNotFound` errors for `pigpio` if you try to use this integration. If you check [component-packages.nix](https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/home-assistant/component-packages.nix) as the wiki says, you will notice a comment saying that the package is missing.

The package is not included in nixpkgs, likely because of [hardware issues](https://github.com/NixOS/nixpkgs/issues/122993) when trying to access gpio pins. Since I am trying to use the remote capability and not access the hardware locally, that particular issue doesn't effect me, so I am just packaging the module directly from pypi.

## usage

To use the overlay, include it when importing nixpkgs:

```nix
inputs.pigpio.url = "github:bj0/nix-pigpio";

...

import nixpkgs {
    overlays = [
       pigpio.overlays.default
    ];
}
```

Then, you can add the module to home-assistant config as shown in the [wiki](https://wiki.nixos.org/wiki/Home_Assistant#Provide_additional_Python_packages_to_Home_Assistant):

```nix
services.home-assistant.extraPackages = p: with p; [
    pigpio
  ];
```

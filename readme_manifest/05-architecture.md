# 05-architecture
#
# Purpose: README manifest fragment for architecture
#
This repo imports nixos-shimboot as a hardware module:

```nix
# flake.nix
inputs.shimboot.url = "github:PopCat19/nixos-shimboot/dev";

# In nixosConfigurations:
modules = [
  shimboot.nixosModules.chromeos    # ChromeOS HAL (boot, fs, hw)
  ./configuration.nix               # personal config (DE, packages, HM)
];
```

nixos-shimboot's `mkForce` declarations handle ChromeOS-specific constraints (initScript boot, single-partition layout). Personal config handles everything else, DE, packages, theming, services.

# nixos.nix
#
# Purpose: NixOS configurations for shimboot ChromeOS profiles
#
# This module:
# - Defines mkConfig factory for ChromeOS NixOS systems
# - Exports nixosConfigurations for all profiles
# - Wires shimboot HAL, home-manager, and profile modules
{ inputs, ... }:
let
  mkUserConfig = args: import (inputs.shimboot + /shimboot_config/user-config.nix) args;

  mkConfig =
    profileName: userConfig:
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        inputs.shimboot.nixosModules.chromeos
        (inputs.self + "/${profileName}/configuration.nix")
        inputs.home-manager.nixosModules.home-manager
        (_: {
          home-manager.useGlobalPkgs = false;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit userConfig inputs;
            inherit (inputs)
              zen-browser
              rose-pine-hyprcursor
              pmd
              nixvim
              ;
          };
          home-manager.sharedModules = [
            (_: { nixpkgs.config.allowUnfree = true; })
          ];
          home-manager.users."${userConfig.user.username}" = import (
            inputs.self + "/${profileName}/home/home.nix"
          );
        })
        (_: { boot.kernelParams = [ "console=ttyS0,115200" ]; })
      ];
      specialArgs = {
        inherit userConfig inputs;
        inherit (inputs)
          zen-browser
          rose-pine-hyprcursor
          noctalia
          stylix
          pmd
          nixvim
          ;
      };
    };
in
{
  flake = {
    # nixConfig from shimboot: sets substituters for nix CLI
    # Produces "unknown flake output" warning — upstream deprecation
    inherit (inputs.shimboot) nixConfig;

    # Default configuration (dedede board)
    nixosConfigurations.nixos-shimboot = mkConfig "." (mkUserConfig {
      username = "nixos-user";
      board = "dedede"; # Intel Jasper Lake
    });
  };
}

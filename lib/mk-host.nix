# mk-host.nix
#
# Purpose: Creates NixOS system configurations with common base
#
# This module:
# - Wraps nixosSystem with standard configuration
# - Handles Home Manager integration
# - Passes userConfig and inputs via specialArgs
{ inputs }:
{
  mkHostConfiguration =
    _hostName: hostPath:
    let
      userConfig = import (hostPath + "/user-config.nix");
      inherit (userConfig) system;
    in
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs userConfig;
      };
      modules = [
        (hostPath + "/configuration.nix")
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = false;
            useUserPackages = true;
            sharedModules = [
              { nixpkgs.config.allowUnfree = true; }
            ];
            users.${userConfig.username} = import (hostPath + "/home.nix");
            extraSpecialArgs = {
              inherit inputs userConfig;
              inherit (inputs)
                zen-browser
                pmd
                nixvim
                noctalia
                stylix
                ;
            };
          };
        }
      ];
    };
}

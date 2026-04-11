# flake.nix
#
# Purpose: Personal ChromeOS desktop config for nixos-shimboot
# Dependencies: nixos-shimboot (HAL), home-manager, stylix, desktop inputs
# Related: popcat19/, main/
#
# This flake provides:
# - NixOS configurations combining shimboot ChromeOS HAL with personal config
# - Home Manager integration for dotfiles
# - Desktop environment and application configuration
{
  description = "Personal ChromeOS desktop config for nixos-shimboot";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Shimboot as ChromeOS hardware abstraction layer
    shimboot = {
      url = "github:PopCat19/nixos-shimboot/dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager for dotfiles
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Stylix theming framework
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Zen Browser
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Rose Pine Hyprcursor
    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Noctalia shell
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Personal Material Design theme system
    pmd = {
      url = "github:popcat19/project-minimalist-design/dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      shimboot,
      home-manager,
      stylix,
      zen-browser,
      rose-pine-hyprcursor,
      noctalia,
      pmd,
      ...
    }:
    let
      system = "x86_64-linux";

      mkUserConfig = args: import (shimboot + /shimboot_config/user-config.nix) args;

      profileUserConfigs = {
        main = mkUserConfig { username = "nixos-user"; };
        popcat19 = mkUserConfig { username = "popcat19"; };
      };

      mkConfig =
        profileName:
        let
          userConfig = profileUserConfigs.${profileName};
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            # Shimboot ChromeOS hardware layer (boot, fs, hw, users, nix settings)
            shimboot.nixosModules.chromeos

            # Profile-specific configuration (DE, packages, home-manager, etc.)
            ./${profileName}/configuration.nix

            # Home Manager integration
            home-manager.nixosModules.home-manager
            (_: {
              home-manager.useGlobalPkgs = false;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit
                  userConfig
                  zen-browser
                  rose-pine-hyprcursor
                  pmd
                  ;
                inherit (self) inputs;
              };
              home-manager.sharedModules = [
                (_: {
                  nixpkgs.config.allowUnfree = true;
                })
              ];
              home-manager.users."${userConfig.user.username}" = import ./${profileName}/home/home.nix;
            })

            # Serial console for ChromeOS debugging
            (_: {
              boot.kernelParams = [ "console=ttyS0,115200" ];
            })
          ];
          specialArgs = {
            inherit
              userConfig
              zen-browser
              rose-pine-hyprcursor
              noctalia
              stylix
              pmd
              ;
            inherit (self) inputs;
          };
        };
    in
    {
      inherit (shimboot) nixConfig;

      # NixOS configurations — one per profile branch
      nixosConfigurations.main = mkConfig "main";
      nixosConfigurations.popcat19 = mkConfig "popcat19";

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;
    };
}

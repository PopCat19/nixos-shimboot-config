# flake.nix
#
# Purpose: Main flake entry point for nixos-shimboot-config
#
# This module:
# - Uses flake-parts for modular flake configuration
# - Imports flake modules from ./flake-modules/
# - Auto-discovers hosts from configuration/hosts/
{
  description = "ChromeOS desktop configuration for nixos-shimboot";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    shimboot = {
      url = "github:PopCat19/nixos-shimboot/dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pmd = {
      url = "github:popcat19/project-minimalist-design/dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      imports = [ ./flake-modules ];
    };
}

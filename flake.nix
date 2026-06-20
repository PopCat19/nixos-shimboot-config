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

  nixConfig = {
    extra-substituters = [
      "https://hyprland.cachix.org"
      "https://shimboot-systemd-nixos.cachix.org"
      "https://numtide.cachix.org"
    ];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "shimboot-systemd-nixos.cachix.org-1:vCWmEtJq7hA2UOLN0s3njnGs9/EuX06kD7qOJMo2kAA="
      "numtide.cachix.org-1:2ps1kLBUWnLAnBIRTV6l6hEQuv59S++4Nux7496Z6tw="
    ];
  };

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

    nixcord = {
      url = "github:FlameFlag/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor?ref=refs/tags/v0.3.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell?ref=refs/tags/v4.7.6";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pmd = {
      url = "git+https://dawn.wine/popcat19/project-minimalist-design.git?ref=dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
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

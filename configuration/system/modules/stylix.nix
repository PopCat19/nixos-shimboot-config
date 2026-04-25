# stylix.nix
#
# Purpose: Import Stylix NixOS module for system-level theming
#
# This module:
# - Imports Stylix NixOS module
# - Provides system-level theming framework
# - Works alongside home-level Stylix configuration
{ inputs, ... }:
{
  imports = [
    inputs.stylix.nixosModules.stylix
  ];
}

# packages.nix
#
# Purpose: Import all package category modules
#
# This module:
# - Imports package category modules
# - Provides centralized package management
{ ... }:
{
  imports = [
    ../packages/media.nix
    ../packages/utilities.nix
  ];
}

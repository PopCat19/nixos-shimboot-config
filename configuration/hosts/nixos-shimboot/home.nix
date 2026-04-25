# home.nix
#
# Purpose: Home Manager configuration entry point for nixos-shimboot host
#
# This module:
# - Sets user-specific home configuration
# - Imports all home modules via single entry point
{ userConfig, ... }:
let
  stateVersion = "24.11";
in
{
  home.username = userConfig.username;
  home.homeDirectory = userConfig.directories.home;
  home.stateVersion = stateVersion;

  imports = [
    ../../home/home.nix
  ];
}

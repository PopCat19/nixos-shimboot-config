# configuration.nix
#
# Purpose: Main system configuration combining base, system and home modules
{ ... }:
{
  imports = [
    ./system/configuration.nix
  ];
}

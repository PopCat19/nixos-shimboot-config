# home.nix
#
# Purpose: Home Manager configuration entry point for nixos-shimboot host
{ ... }:
{
  imports = [ ../../home/modules/home.nix ];
}

# default.nix
#
# Purpose: Re-export home.nix for directory imports
{ ... }:
{
  imports = [ ./home.nix ];
}

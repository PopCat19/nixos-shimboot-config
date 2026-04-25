# default.nix
#
# Purpose: Export all library functions
#
# This module:
# - Aggregates all lib helpers
# - Provides single import point for library functions
{ inputs }:
{
  mkHost = import ./mk-host.nix { inherit inputs; };
}

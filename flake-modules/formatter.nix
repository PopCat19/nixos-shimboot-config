# formatter.nix
#
# Purpose: Expose nixfmt-tree as the flake formatter
#
# This module:
# - Configures per-system formatter output
{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      formatter = pkgs.nixfmt-tree;
    };
}

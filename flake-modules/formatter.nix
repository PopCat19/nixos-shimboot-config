# formatter.nix
#
# Purpose: Expose nixfmt-tree as the flake formatter
#
# This module:
# - Configures per-system formatter output
_: {
  perSystem =
    { pkgs, ... }:
    {
      formatter = pkgs.nixfmt-tree;
    };
}

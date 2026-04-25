# cachix-config.nix
#
# Purpose: Configure Cachix binary cache for all builds
#
# This module:
# - Imports base substituters from shimboot (systemd, numtide)
# - Configures Nix substituters for binary cache access
{ inputs, ... }:
let
  # Import base nixConfig from shimboot
  baseConfig = import "${inputs.shimboot}/flake_modules/cachix-config.nix" { };
in
{
  flake = {
    inherit (baseConfig) nixConfig;
  };
}

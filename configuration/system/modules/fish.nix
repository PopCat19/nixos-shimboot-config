# Fish Shell Extension Module
#
# Purpose: Add custom fish functions on top of shimboot base
#
# This module installs fish functions for:
# - nixos-rebuild-basic: Unified NixOS rebuild with commit/push support
# - nixos-status: Display system status and generations
# - cnup: Quick update of flake inputs
# - lsa: Better ls with aliases
# - etc.
_:
let
  fishFunctionsDir = ../fish_functions;
in
{
  environment.etc = {
    "fish/functions/nixos-rebuild-basic.fish".text =
      builtins.readFile "${fishFunctionsDir}/nixos-rebuild-basic.fish";
    "fish/functions/nixos-status.fish".text = builtins.readFile "${fishFunctionsDir}/nixos-status.fish";
    "fish/functions/nix-flake-update.fish".text =
      builtins.readFile "${fishFunctionsDir}/nix-flake-update.fish";
    "fish/functions/cnup.fish".text = builtins.readFile "${fishFunctionsDir}/cnup.fish";
    "fish/functions/completions/proxify.fish".text =
      builtins.readFile "${fishFunctionsDir}/completions/proxify.fish";
  };
}

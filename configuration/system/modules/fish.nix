# Fish Shell Extension Module
#
# Purpose: Add custom fish functions on top of shimboot base
#
# This module installs proxy-related fish functions for:
# - proxy-on: Enable proxy environment variables
# - proxy-off: Disable proxy environment variables
# - proxify: Run commands with proxy settings (detached)
{
  lib,
  pkgs,
  config,
  ...
}:
let
  fishFunctionsDir = ../fish_functions;
in
{
  environment.etc = {
    "fish/functions/proxy-on.fish".text = builtins.readFile "${fishFunctionsDir}/proxy-on.fish";
    "fish/functions/proxy-off.fish".text = builtins.readFile "${fishFunctionsDir}/proxy-off.fish";
    "fish/functions/proxify.fish".text = builtins.readFile "${fishFunctionsDir}/proxify.fish";
    "fish/functions/nixos-rebuild-basic.fish".text = builtins.readFile "${fishFunctionsDir}/nixos-rebuild-basic.fish";
    "fish/functions/nixos-status.fish".text = builtins.readFile "${fishFunctionsDir}/nixos-status.fish";
    "fish/functions/nix-flake-update.fish".text = builtins.readFile "${fishFunctionsDir}/nix-flake-update.fish";
    "fish/functions/cnup.fish".text = builtins.readFile "${fishFunctionsDir}/cnup.fish";
    "fish/functions/completions/proxify.fish".text = builtins.readFile "${fishFunctionsDir}/completions/proxify.fish";
  };
}
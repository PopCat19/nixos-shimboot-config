# hardware-configuration.nix
#
# Purpose: Hardware configuration placeholder for nixos-shimboot
#
# Note: For ChromeOS devices, hardware is handled by shimboot base config.
# This file exists for NixOS module compatibility.
{ ... }:
{
  nixpkgs.hostPlatform = "x86_64-linux";
}

# configuration.nix
#
# Purpose: Main NixOS configuration for nixos-shimboot host
{ userConfig, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/${userConfig.profile}.nix
  ];

  networking.hostName = userConfig.hostname;
}

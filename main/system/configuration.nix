# configuration.nix
#
# Purpose: Main system configuration for user-specific system modules
{ ... }:
{
  imports = [
    ./environment.nix
    ./fonts.nix
    ./packages.nix
    ./services.nix
    ./syncthing.nix
    ./stylix.nix
    ./greeter.nix
  ];
}

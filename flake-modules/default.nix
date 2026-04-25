# default.nix
#
# Purpose: Import all flake-modules
{
  imports = [
    ./formatter.nix
    ./nixos.nix
  ];
}

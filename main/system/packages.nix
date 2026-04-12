# packages.nix
#
# Purpose: Install system-wide packages
#
# This module:
# - Installs system-wide utility packages
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gh
    usbutils
    tree
    xdg-utils
    nodejs
    python3
    rustup
    eza
  ];
}

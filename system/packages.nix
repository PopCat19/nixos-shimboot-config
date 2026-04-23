# System Packages Module
#
# Purpose: Install system-wide packages
# Dependencies: None
# Related: None
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

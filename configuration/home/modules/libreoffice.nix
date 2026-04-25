# libreoffice.nix
#
# Purpose: Configure LibreOffice office suite
#
# This module:
# - Installs LibreOffice via home-manager packages
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    libreoffice
  ];
}

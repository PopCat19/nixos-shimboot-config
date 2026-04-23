# Utilities Packages Module
#
# Purpose: Install utility applications for productivity
# Dependencies: None
# Related: packages.nix
#
# This module:
# - Installs productivity utility packages
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    eza
    wl-clipboard
    cliphist
    pavucontrol
    playerctl
    localsend
    keepassxc
    zenity
    ripgrep
    android-tools
    nixd
    nil
    nixfmt-tree
    statix
    deadnix
    opencode
    ranger
  ];
}

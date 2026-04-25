# home.nix
#
# Purpose: Main Home Manager configuration combining all user modules
#
# This module:
# - Imports all Home Manager modules
# - Configures desktop environment
# - Sets Home Manager state version
{ config, ... }:
{
  imports = [
    ./hypr_config/hyprland.nix
    ./noctalia_config/noctalia.nix
    ./hypr_config/hypr-packages.nix
    ./kitty.nix

    ./environment.nix
    ./packages.nix
    ./services.nix
    ./zen-browser.nix

    ./fcitx5.nix
    ./dolphin.nix
    ./fuzzel.nix
    ./bookmarks.nix
    ./kde.nix
    ./micro.nix
    ./privacy.nix
    ./stylix.nix
    ./wallpaper.nix
    ./programs.nix
    ./starship.nix
    ./home-files.nix
    ./systemd-services.nix
  ];

  gtk.gtk4.theme = config.gtk.theme; # keep legacy default (stateVersion < 26.05)

  home.stateVersion = "24.11";
}

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
    ./modules/kitty.nix

    ./modules/environment.nix
    ./modules/packages.nix
    ./modules/services.nix
    ./modules/zen-browser.nix

    ./modules/fcitx5.nix
    ./modules/dolphin.nix
    ./modules/fuzzel.nix
    ./modules/bookmarks.nix
    ./modules/kde.nix
    ./modules/micro.nix
    ./modules/privacy.nix
    ./modules/stylix.nix
    ./modules/programs.nix
    ./modules/starship.nix
    ./modules/home-files.nix
    ./modules/systemd-services.nix
    ./modules/wallpaper.nix
  ];

  gtk.gtk4.theme = config.gtk.theme;

  home.stateVersion = "24.11";
}

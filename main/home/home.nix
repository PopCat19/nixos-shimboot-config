# home.nix
#
# Purpose: Main Home Manager configuration combining all user modules
{ ... }:
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
  ];

  home.stateVersion = "24.11";
}

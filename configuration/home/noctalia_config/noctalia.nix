# Noctalia Configuration Module
#
# Purpose: Main module for Noctalia configuration
# - Applies user's personalized settings
# - Configures systemd service for autostart
# - Uses nixpkgs noctalia-shell package
{
  pkgs,
  config,
  userConfig,
  ...
}:
let
  settings = import ./settings.nix { inherit pkgs config userConfig; };
in
{
  # Write settings to noctalia config
  xdg.configFile."noctalia/settings.json".source =
    (pkgs.formats.json { }).generate "noctalia-settings"
      settings.settings;

  systemd.user.services.noctalia-shell = {
    Unit = {
      Description = "Noctalia Shell (with delay)";
      After = [ "hyprland-session.target" ];
      PartOf = [ "hyprland-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 3";
      ExecStart = "${pkgs.noctalia-shell}/bin/noctalia-shell";
      Restart = "on-failure";
      RestartSec = "5s";
    };

    Install = {
      WantedBy = [ "hyprland-session.target" ];
    };
  };
}

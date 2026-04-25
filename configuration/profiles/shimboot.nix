# shimboot.nix
#
# Purpose: Shimboot profile preset for ChromeOS devices
#
# This profile:
# - Imports shimboot chromeos base configuration
# - Configures system modules not included in base
# - Delegates home-manager to mk-host.nix
{ lib, userConfig, inputs, ... }:
{
  imports = [
    # Shimboot chromeos base configuration (includes boot, fs, hw, users, nix, display, services, audio, networking, hyprland, fish, fonts, power, xdg)
    inputs.shimboot.nixosModules.chromeos

    # System modules not in base
    ../system/modules/environment.nix
    ../system/modules/fonts.nix
    ../system/modules/greeter.nix
    ../system/modules/packages.nix
    ../system/modules/services.nix
    ../system/modules/stylix.nix
    ../system/modules/syncthing.nix
  ];

  # Re-export userConfig for shimboot modules
  _module.args.userConfig = userConfig;

  # Override NIXOS_CONFIG_DIR for this repo
  environment.sessionVariables.NIXOS_CONFIG_DIR = lib.mkForce userConfig.env.NIXOS_CONFIG_DIR;
}

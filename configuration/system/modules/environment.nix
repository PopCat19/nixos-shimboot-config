# Environment Variables Module
#
# Purpose: Configure system-wide environment variables for applications.
# Dependencies: userConfig
# Related: home/environment.nix
#
# This module:
# - Adds consumer-specific environment variables
# - Overrides base config paths
# - Defers EDITOR/VISUAL to base configuration
{ userConfig, ... }:
{
  environment.variables = {
    BROWSER = userConfig.defaultApps.browser.package;
    TERMINAL = userConfig.defaultApps.terminal.command;
    FILE_MANAGER = userConfig.defaultApps.fileManager.package;
    WEBKIT_DISABLE_COMPOSITING_MODE = "1";
    NIXOS_CONFIG_DIR = "$HOME/nixos-shimboot-config";
  };
}

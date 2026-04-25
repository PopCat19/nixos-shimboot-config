# environment.nix
#
# Purpose: Configure system-wide environment variables for applications
#
# This module:
# - Sets consumer-specific environment variables
# - Delegates config directory path to profiles
{ userConfig, ... }:
{
  environment.variables = {
    BROWSER = userConfig.defaultApps.browser.package;
    TERMINAL = userConfig.defaultApps.terminal.command;
    FILE_MANAGER = userConfig.defaultApps.fileManager.package;
    WEBKIT_DISABLE_COMPOSITING_MODE = "1";
    # NIXOS_CONFIG_DIR is set by profile (shimboot.nix)
  };
}

# Environment Variables Module
#
# Purpose: Configure system-wide environment variables for applications.
# Dependencies: userConfig
# Related: home/environment.nix
#
# This module:
# - Sets environment variables for default applications
# - Sets config repo directory path
{ userConfig, ... }:
{
  environment.variables = {
    # Override both NixOS default (mkDefault "nano") and shimboot default (mkDefault "micro")
    EDITOR = userConfig.defaultApps.editor.command;
    VISUAL = userConfig.defaultApps.editor.command;
    BROWSER = userConfig.defaultApps.browser.package;
    TERMINAL = userConfig.defaultApps.terminal.command;
    FILE_MANAGER = userConfig.defaultApps.fileManager.package;
    WEBKIT_DISABLE_COMPOSITING_MODE = "1";
    NIXOS_CONFIG_DIR = "$HOME/nixos-shimboot-config";
  };
}

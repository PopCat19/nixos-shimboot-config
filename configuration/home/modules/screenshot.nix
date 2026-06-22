# screenshot.nix
#
# Purpose: Screenshot capture using grimblast with hyprshade bypass
#
# This module:
# - Installs grimblast for Wayland screenshot capture
# - Creates fish wrapper with hyprshade workaround
{ pkgs, ... }:

let
  screenshotScript = pkgs.writeShellScriptBin "screenshot" ''
    set -euo pipefail

    SCREENSHOTS_DIR="''${XDG_SCREENSHOTS_DIR:-$HOME/Pictures/Screenshots}"
    mkdir -p "$SCREENSHOTS_DIR"

    MODE="output"
    KEEP_SHADER=false

    for arg in "$@"; do
      case "$arg" in
        monitor) MODE="output" ;;
        region) MODE="area" ;;
        window) MODE="active" ;;
        --keep-shader) KEEP_SHADER=true ;;
        *) echo "Usage: screenshot [monitor|region|window] [--keep-shader]" >&2; exit 1 ;;
      esac
    done

    shader=""
    restore_shader() {
      if [[ -n "$shader" && "$shader" != "Off" ]]; then
        hyprshade on "$shader"
      fi
    }

    if [[ "$KEEP_SHADER" == false ]] && command -v hyprshade >/dev/null 2>&1; then
      shader=$(hyprshade current 2>/dev/null || true)
      if [[ -n "$shader" && "$shader" != "Off" ]]; then
        hyprshade off
        trap restore_shader EXIT
      fi
    fi

    ${pkgs.grimblast}/bin/grimblast --notify --freeze copysave "$MODE" "$SCREENSHOTS_DIR/screenshot-$(date +%Y%m%d-%H%M%S).png"
  '';
in
{
  home.file."Pictures/Screenshots/.keep".text = "";

  home.packages = with pkgs; [
    grimblast
    screenshotScript
  ];
}

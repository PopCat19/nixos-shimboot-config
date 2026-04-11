#!/usr/bin/env bash

# migrate-from-shimboot.sh
#
# Purpose: Prepare existing nixos-user shimboot install for nixos-shimboot-config rebuild
#
# This script:
# - Renames config dir from nixos-config to nixos-shimboot-config
# - Patches hardcoded nixos-config refs in home dotfiles
#
# Run this BEFORE nixos-rebuild. NixOS creates the new user declaratively.
# After rebuild, rsync old home to new user manually.

set -Eeuo pipefail

OLD_CONFIG_DIR_NAME="nixos-config"
NEW_CONFIG_DIR_NAME="nixos-shimboot-config"
DRY_RUN=true

# ── args ──────────────────────────────────────────────────────────────────────

usage() {
	echo "Usage: $0 --old-user <username> [--apply]"
	echo ""
	echo "  --old-user   Source username (default: nixos-user)"
	echo "  --apply      Execute changes (default: dry-run)"
	exit 1
}

OLD_USER="nixos-user"

while [[ $# -gt 0 ]]; do
	case "$1" in
	--old-user)
		OLD_USER="$2"
		shift 2
		;;
	--apply)
		DRY_RUN=false
		shift
		;;
	*) usage ;;
	esac
done

TARGET_HOME="/home/${OLD_USER}"
OLD_CONFIG="${TARGET_HOME}/${OLD_CONFIG_DIR_NAME}"
NEW_CONFIG="${TARGET_HOME}/${NEW_CONFIG_DIR_NAME}"

# ── helpers ───────────────────────────────────────────────────────────────────

log() { echo "[migrate] $*"; }
warn() { echo "[migrate] WARNING: $*" >&2; }

run() {
	if $DRY_RUN; then
		echo "[dry-run] $*"
	else
		"$@"
	fi
}

# ── preflight ─────────────────────────────────────────────────────────────────

[[ $EUID -ne 0 ]] && {
	echo "Run as root."
	exit 1
}

if ! id "$OLD_USER" &>/dev/null; then
	warn "User '${OLD_USER}' not found."
	exit 1
fi

if $DRY_RUN; then
	log "Dry-run mode -- pass --apply to execute"
	echo ""
fi

log "WARNING: Run this script BEFORE nixos-rebuild."
log "NixOS will create the new user declaratively during rebuild."
log "After reboot, manually rsync ${TARGET_HOME}/ to the new user's home."
echo ""

# ── step 1: rename config dir ─────────────────────────────────────────────────

log "Step 1: rename config dir '${OLD_CONFIG}' -> '${NEW_CONFIG}'"

if [[ -d "$NEW_CONFIG" ]]; then
	log "  ${NEW_CONFIG} already exists, skipping rename."
elif [[ -d "$OLD_CONFIG" ]]; then
	run mv "$OLD_CONFIG" "$NEW_CONFIG"
else
	warn "  Neither ${OLD_CONFIG} nor ${NEW_CONFIG} found -- clone config repo manually."
fi

# ── step 2: patch hardcoded refs in dotfiles ──────────────────────────────────

log "Step 2: patch '${OLD_CONFIG_DIR_NAME}' refs in dotfiles under ${TARGET_HOME}"

DOTFILES_TO_PATCH=$(grep -rl "$OLD_CONFIG_DIR_NAME" "$TARGET_HOME" \
	--include="*.sh" \
	--include="*.fish" \
	--include="*.nix" \
	--include="*.conf" \
	--include="*.toml" \
	--include="*.json" \
	2>/dev/null || true)

if [[ -z "$DOTFILES_TO_PATCH" ]]; then
	log "  No dotfiles with hardcoded refs found."
else
	while IFS= read -r file; do
		log "  Patching: ${file}"
		run sed -i "s|${OLD_CONFIG_DIR_NAME}|${NEW_CONFIG_DIR_NAME}|g" "$file"
	done <<<"$DOTFILES_TO_PATCH"
fi

# ── done ──────────────────────────────────────────────────────────────────────

echo ""
log "Pre-rebuild migration complete."
if $DRY_RUN; then
	echo ""
	log "Re-run with --apply to execute."
else
	log "Next steps:"
	log "  1. From a root shell: nixos-rebuild switch --flake ${NEW_CONFIG}#<profile>"
	log "  2. Reboot"
	log "  3. rsync /home/${OLD_USER}/ to new user home (exclude .cache)"
fi

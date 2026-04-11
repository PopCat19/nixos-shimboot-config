#!/usr/bin/env bash

# migrate-from-shimboot.sh
#
# Purpose: Migrate existing nixos-user shimboot install to nixos-shimboot-config layout
#
# This script:
# - Renames user via shimboot's migrate-username-service
# - Renames config dir from nixos-config to nixos-shimboot-config
# - Patches hardcoded nixos-config refs in home dotfiles
# - Verifies sudo access before exit

set -Eeuo pipefail

MIGRATE_USERNAME_BIN="migrate-username-service"
OLD_CONFIG_DIR_NAME="nixos-config"
NEW_CONFIG_DIR_NAME="nixos-shimboot-config"
DRY_RUN=true

# ── args ──────────────────────────────────────────────────────────────────────

usage() {
  echo "Usage: $0 --new-user <username> [--old-user <username>] [--apply]"
  echo ""
  echo "  --new-user   Target username (required)"
  echo "  --old-user   Source username (default: nixos-user)"
  echo "  --apply      Execute changes (default: dry-run)"
  exit 1
}

OLD_USER="nixos-user"
NEW_USER=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --new-user) NEW_USER="$2"; shift 2 ;;
    --old-user) OLD_USER="$2"; shift 2 ;;
    --apply)    DRY_RUN=false; shift ;;
    *) usage ;;
  esac
done

[[ -z "$NEW_USER" ]] && usage

# ── helpers ───────────────────────────────────────────────────────────────────

log()  { echo "[migrate] $*"; }
warn() { echo "[migrate] WARNING: $*" >&2; }

run() {
  if $DRY_RUN; then
    echo "[dry-run] $*"
  else
    "$@"
  fi
}

# ── preflight ─────────────────────────────────────────────────────────────────

[[ $EUID -ne 0 ]] && { echo "Run as root."; exit 1; }

if ! command -v "$MIGRATE_USERNAME_BIN" &>/dev/null; then
  warn "${MIGRATE_USERNAME_BIN} not found in PATH"
  warn "Is this running on a shimboot system with at least one activation?"
  exit 1
fi

if $DRY_RUN; then
  log "Dry-run mode — pass --apply to execute"
  echo ""
fi

# ── step 1: username migration ────────────────────────────────────────────────

if [[ "$OLD_USER" == "$NEW_USER" ]]; then
  log "Step 1: username unchanged (${NEW_USER}), skipping user rename."
else
  log "Step 1: rename user '${OLD_USER}' -> '${NEW_USER}'"

  if ! id "$OLD_USER" &>/dev/null; then
    warn "Old user '${OLD_USER}' not found — already migrated or wrong --old-user?"
    exit 1
  fi

  if id "$NEW_USER" &>/dev/null; then
    warn "New user '${NEW_USER}' already exists — aborting to prevent data loss."
    exit 1
  fi

  run "$MIGRATE_USERNAME_BIN" "$NEW_USER"
fi

# ── step 2: rename config dir ─────────────────────────────────────────────────

TARGET_HOME=$( [[ "$OLD_USER" == "$NEW_USER" ]] && echo "/home/${OLD_USER}" || echo "/home/${NEW_USER}" )
OLD_CONFIG="${TARGET_HOME}/${OLD_CONFIG_DIR_NAME}"
NEW_CONFIG="${TARGET_HOME}/${NEW_CONFIG_DIR_NAME}"

log "Step 2: rename config dir '${OLD_CONFIG}' -> '${NEW_CONFIG}'"

if [[ -d "$NEW_CONFIG" ]]; then
  log "  ${NEW_CONFIG} already exists, skipping rename."
elif [[ -d "$OLD_CONFIG" ]]; then
  run mv "$OLD_CONFIG" "$NEW_CONFIG"
else
  warn "  Neither ${OLD_CONFIG} nor ${NEW_CONFIG} found — clone config repo manually after migration."
fi

# ── step 3: patch hardcoded refs in dotfiles ──────────────────────────────────

log "Step 3: patch '${OLD_CONFIG_DIR_NAME}' refs in dotfiles under ${TARGET_HOME}"

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
  done <<< "$DOTFILES_TO_PATCH"
fi

# ── step 4: fix ownership ─────────────────────────────────────────────────────

log "Step 4: fix ownership of ${TARGET_HOME}"
run chown -R "${NEW_USER}:${NEW_USER}" "$TARGET_HOME"

# ── step 5: verify sudo ───────────────────────────────────────────────────────

log "Step 5: verify sudo for ${NEW_USER}"

if $DRY_RUN; then
  echo "[dry-run] sudo -u ${NEW_USER} sudo -n true"
else
  if sudo -u "$NEW_USER" sudo -n true 2>/dev/null; then
    log "  sudo OK"
  else
    warn "  sudo check failed for '${NEW_USER}' — verify wheel group membership."
    warn "  Do NOT log out of root session until resolved."
  fi
fi

# ── done ──────────────────────────────────────────────────────────────────────

echo ""
log "Migration complete."
if $DRY_RUN; then
  echo ""
  log "Re-run with --apply to execute."
else
  log "Next steps:"
  log "  1. nixos-rebuild switch --flake ${NEW_CONFIG}#<profile>"
  log "  2. Reboot"
  log "  3. Login as '${NEW_USER}'"
fi

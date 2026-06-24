#!/usr/bin/env bash
# Replicate prod DB (religo_app) -> dev DB (religo_dev) via SSH (full replace).
#
# Steps:
#   1. Backup dev -> backups/dev_<timestamp>.sql (mandatory; abort if empty)
#   2. Dump prod (read-only)
#   3. DROP/CREATE dev + load prod dump
#   4. Remote post-import: workspace name patch + pending migrations (develop code on dev)
#
# Usage: bin/db-replicate-prod-to-dev.sh
#        make db-replicate-prod-to-dev
#
# Safety:
#   - prod is read-only (dump only)
#   - dev is fully overwritten
#   - confirmation phrase required (skip with RELIGO_DB_ASSUME_YES=1)
#
# Rollback: restore dev from the backup written in step 1:
#   scp backups/dev_YYYYMMDD_HHMMSS.sql tugilo.com:/tmp/restore.sql
#   ssh tugilo.com 'cd /var/www/laravel/religo_dev && ... load /tmp/restore.sql'
#   (or: make db-import locally from backup, then make db-push TARGET=dev)
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=bin/lib/remote.sh
source "$REPO_ROOT/bin/lib/remote.sh"
# shellcheck source=bin/lib/religo-db-patch.sh
source "$REPO_ROOT/bin/lib/religo-db-patch.sh"

SOURCE_TARGET="prod"
DEST_TARGET="dev"
CONFIRM_PHRASE="REPLICATE prod to dev"

echo "############################################################"
echo "# Replicate ${SOURCE_TARGET} (religo_app) -> ${DEST_TARGET} (religo_dev)"
echo "# Host: ${RELIGO_REMOTE_SSH}"
echo "#"
echo "# - ${DEST_TARGET} will be FULLY REPLACED"
echo "# - ${SOURCE_TARGET} is dump-only (not modified)"
echo "# - dev backup -> backups/dev_<timestamp>.sql"
echo "############################################################"

if [ "${RELIGO_DB_ASSUME_YES:-}" != "1" ]; then
  read -r -p "Type exactly '${CONFIRM_PHRASE}' to proceed: " phrase
  if [ "$phrase" != "$CONFIRM_PHRASE" ]; then
    echo "Phrase mismatch. Aborted."
    exit 0
  fi
fi

mkdir -p "$REPO_ROOT/backups"
DEV_BACKUP="$REPO_ROOT/backups/dev_$(TZ=Asia/Tokyo date +%Y%m%d_%H%M%S).sql"

echo "1/4 Backing up ${DEST_TARGET} -> ${DEV_BACKUP#"$REPO_ROOT"/} ..."
remote_dump "$DEST_TARGET" > "$DEV_BACKUP"
DEV_BK_BYTES=$(wc -c < "$DEV_BACKUP" | tr -d ' ')
if [ "$DEV_BK_BYTES" -lt 100 ]; then
  echo "Error: dev backup looks empty (${DEV_BK_BYTES} bytes). Aborting (dev untouched)." >&2
  exit 1
fi
echo "    dev backup ok (${DEV_BK_BYTES} bytes)."

TMP_PROD="$(mktemp "${TMPDIR:-/tmp}/religo_replicate_prod.XXXXXX.sql")"
trap 'rm -f "$TMP_PROD"' EXIT

echo "2/4 Dumping ${SOURCE_TARGET} (read-only) ..."
remote_dump "$SOURCE_TARGET" > "$TMP_PROD"
PROD_BYTES=$(wc -c < "$TMP_PROD" | tr -d ' ')
if [ "$PROD_BYTES" -lt 100 ]; then
  echo "Error: prod dump looks empty (${PROD_BYTES} bytes). Aborting (dev untouched)." >&2
  exit 1
fi
echo "    prod dump ok (${PROD_BYTES} bytes)."

echo "3/4 Loading prod dump into ${DEST_TARGET} (religo_dev) ..."
remote_recreate_and_load "$DEST_TARGET" "$TMP_PROD"

echo "4/4 Post-import patches on ${DEST_TARGET} ..."
religo_remote_apply_post_import_patches "$DEST_TARGET"

echo ""
echo "Done: replicated ${SOURCE_TARGET} -> ${DEST_TARGET}."
echo "  dev backup (rollback): ${DEV_BACKUP#"$REPO_ROOT"/}"
echo "  To rollback dev: restore from the backup above (see script header)."

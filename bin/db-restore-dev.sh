#!/usr/bin/env bash
# Restore dev DB (religo_dev) from a local SQL backup file (full replace).
#
# Usage: bin/db-restore-dev.sh backups/dev_YYYYMMDD_HHMMSS.sql
#        make db-restore-dev BACKUP=backups/dev_YYYYMMDD_HHMMSS.sql
#
# Typically used to rollback after make db-replicate-prod-to-dev.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=bin/lib/remote.sh
source "$REPO_ROOT/bin/lib/remote.sh"
# shellcheck source=bin/lib/religo-db-patch.sh
source "$REPO_ROOT/bin/lib/religo-db-patch.sh"

BACKUP_FILE="${1:-${BACKUP:-}}"
TARGET="dev"

if [ -z "$BACKUP_FILE" ]; then
  echo "Usage: bin/db-restore-dev.sh <backup.sql>" >&2
  echo "       make db-restore-dev BACKUP=backups/dev_YYYYMMDD_HHMMSS.sql" >&2
  exit 1
fi

if [[ "$BACKUP_FILE" != /* ]]; then
  BACKUP_FILE="$REPO_ROOT/$BACKUP_FILE"
fi

if [ ! -f "$BACKUP_FILE" ]; then
  echo "Error: backup not found: $BACKUP_FILE" >&2
  exit 1
fi

BK_BYTES=$(wc -c < "$BACKUP_FILE" | tr -d ' ')
if [ "$BK_BYTES" -lt 100 ]; then
  echo "Error: backup looks empty (${BK_BYTES} bytes)." >&2
  exit 1
fi

echo "############################################################"
echo "# Restore ${TARGET} (religo_dev) from:"
echo "#   ${BACKUP_FILE#"$REPO_ROOT"/}"
echo "#   (${BK_BYTES} bytes)"
echo "############################################################"

if [ "${RELIGO_DB_ASSUME_YES:-}" != "1" ]; then
  read -r -p "Continue? [y/N] " ans
  case "$ans" in y | Y | yes | YES) ;; *) echo "Aborted."; exit 0 ;; esac
fi

echo "Loading backup into ${TARGET} ..."
remote_recreate_and_load "$TARGET" "$BACKUP_FILE"

echo "Post-import patches on ${TARGET} ..."
religo_remote_apply_post_import_patches "$TARGET"

echo "Done: restored ${TARGET} from ${BACKUP_FILE#"$REPO_ROOT"/}."

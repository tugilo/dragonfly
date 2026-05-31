#!/usr/bin/env bash
# Push the LOCAL docker MariaDB into a remote (prod|dev) DB (full replace).
# Usage: bin/db-push.sh <prod|dev>   or   make db-push TARGET=dev
#
# SAFETY:
#   - Always backs up the remote DB first (backups/<target>_<timestamp>.sql).
#   - prod requires typing the confirm phrase: OVERWRITE religo_app
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=bin/lib/compose.sh
source "$REPO_ROOT/bin/lib/compose.sh"
# shellcheck source=bin/lib/remote.sh
source "$REPO_ROOT/bin/lib/remote.sh"

compose_require_project_env "$REPO_ROOT"

TARGET="${1:-}"
if [ -z "$TARGET" ]; then
  echo "Usage: bin/db-push.sh <prod|dev>" >&2
  exit 1
fi
remote_path_for "$TARGET" >/dev/null || exit 1

if ! compose_db_ready "$REPO_ROOT"; then
  echo "Error: local db container is not running." >&2
  exit 1
fi

REMOTE_DB="religo_app"; [ "$TARGET" = "dev" ] && REMOTE_DB="religo_dev"

echo "############################################################"
echo "# DANGER: overwrite REMOTE ${TARGET} (${REMOTE_DB} @ ${RELIGO_REMOTE_SSH})"
echo "#         with your LOCAL '${PROJECT}' DB."
echo "############################################################"

if [ "$TARGET" = "prod" ]; then
  read -r -p "Type exactly 'OVERWRITE religo_app' to proceed: " phrase
  if [ "$phrase" != "OVERWRITE religo_app" ]; then
    echo "Phrase mismatch. Aborted."; exit 0
  fi
else
  read -r -p "Continue overwriting ${TARGET}? [y/N] " ans
  case "$ans" in y | Y | yes | YES) ;; *) echo "Aborted."; exit 0 ;; esac
fi

mkdir -p "$REPO_ROOT/backups"
BACKUP="$REPO_ROOT/backups/${TARGET}_$(TZ=Asia/Tokyo date +%Y%m%d_%H%M%S).sql"
echo "1/3 Backing up remote ${TARGET} -> ${BACKUP#"$REPO_ROOT"/} ..."
remote_dump "$TARGET" > "$BACKUP"
BK=$(wc -c < "$BACKUP" | tr -d ' ')
if [ "$BK" -lt 100 ]; then
  echo "Error: remote backup looks empty (${BK} bytes). Aborting (remote untouched)." >&2
  exit 1
fi
echo "    backup ok (${BK} bytes)."

TMP_FILE="$(mktemp "${TMPDIR:-/tmp}/religo_push.XXXXXX.sql")"
trap 'rm -f "$TMP_FILE"' EXIT
echo "2/3 Dumping local '${PROJECT}' ..."
{
  compose_exec_db mariadb-dump -u root -proot \
    --single-transaction --routines --triggers --add-drop-table "$PROJECT"
} > "$TMP_FILE"

echo "3/3 Loading into remote ${TARGET} (${REMOTE_DB}) ..."
remote_recreate_and_load "$TARGET" "$TMP_FILE"

echo "Done: pushed local '${PROJECT}' -> ${TARGET} (${REMOTE_DB})."
echo "Rollback if needed: bin/db-load-file.sh is not provided; restore from ${BACKUP#"$REPO_ROOT"/} via remote_recreate_and_load."

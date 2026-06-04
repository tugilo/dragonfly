#!/usr/bin/env bash
# Pull remote (prod|dev) DB into the LOCAL docker MariaDB (full replace).
# Usage: bin/db-pull.sh [prod|dev]   or   make db-pull TARGET=prod
#   RELIGO_DB_ASSUME_YES=1 to skip the confirmation prompt.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=bin/lib/compose.sh
source "$REPO_ROOT/bin/lib/compose.sh"
# shellcheck source=bin/lib/remote.sh
source "$REPO_ROOT/bin/lib/remote.sh"
# shellcheck source=bin/lib/religo-db-patch.sh
source "$REPO_ROOT/bin/lib/religo-db-patch.sh"

compose_require_project_env "$REPO_ROOT"

TARGET="${1:-prod}"
remote_path_for "$TARGET" >/dev/null || exit 1

if ! compose_db_ready "$REPO_ROOT"; then
  echo "Error: local db container is not running. Start with:" >&2
  echo "  docker compose -f infra/compose/docker-compose.yml --env-file project.env up -d" >&2
  exit 1
fi

echo "This OVERWRITES your LOCAL '${PROJECT}' DB with ${TARGET} (${RELIGO_REMOTE_SSH})."
if [ "${RELIGO_DB_ASSUME_YES:-}" != "1" ]; then
  read -r -p "Continue? [y/N] " ans
  case "$ans" in
    y | Y | yes | YES) ;;
    *) echo "Aborted."; exit 0 ;;
  esac
fi

TMP_FILE="$(mktemp "${TMPDIR:-/tmp}/religo_pull.XXXXXX.sql")"
trap 'rm -f "$TMP_FILE"' EXIT

echo "Dumping ${TARGET} ..."
remote_dump "$TARGET" > "$TMP_FILE"
BYTES=$(wc -c < "$TMP_FILE" | tr -d ' ')
if [ "$BYTES" -lt 100 ]; then
  echo "Error: dump looks empty (${BYTES} bytes). Aborting (local DB untouched)." >&2
  exit 1
fi

echo "Importing into local '${PROJECT}' (${BYTES} bytes) ..."
compose_exec_db mariadb -u root -proot -e \
  "DROP DATABASE IF EXISTS \`${PROJECT}\`; CREATE DATABASE \`${PROJECT}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
compose_exec_db mariadb -u root -proot "$PROJECT" < "$TMP_FILE"

religo_patch_dragonfly_workspace_name "$REPO_ROOT"

# Re-export from patched local DB (do not copy raw remote dump — it still has Default Workspace).
bash "$REPO_ROOT/bin/db-export.sh"

echo "Done: pulled ${TARGET} -> local '${PROJECT}'. www/database/sync/dragonfly.sql re-exported with DragonFly workspace name."

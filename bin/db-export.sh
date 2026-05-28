#!/usr/bin/env bash
# Export local MariaDB to www/database/sync/dragonfly.sql (fixed name, overwrite).
# Usage: bin/db-export.sh   or   make db-export
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=bin/lib/compose.sh
source "$REPO_ROOT/bin/lib/compose.sh"

compose_require_project_env "$REPO_ROOT"

DUMP_FILE="$REPO_ROOT/www/database/sync/dragonfly.sql"
mkdir -p "$(dirname "$DUMP_FILE")"

if ! compose_db_ready "$REPO_ROOT"; then
  echo "Error: db container is not running. Start with:" >&2
  echo "  docker compose -f infra/compose/docker-compose.yml --env-file project.env up -d" >&2
  exit 1
fi

TMP_FILE="${DUMP_FILE}.tmp.$$"
trap 'rm -f "$TMP_FILE"' EXIT

{
  echo "-- dragonfly dev DB sync dump"
  echo "-- generated: $(TZ=Asia/Tokyo date '+%Y-%m-%d %H:%M:%S %Z')"
  echo "-- database: ${PROJECT}"
  echo "-- export: bin/db-export.sh (overwrite www/database/sync/dragonfly.sql)"
  echo ""
  compose_exec_db \
    mariadb-dump -u root -proot \
    --single-transaction \
    --routines \
    --triggers \
    --add-drop-table \
    "$PROJECT"
} > "$TMP_FILE"

mv "$TMP_FILE" "$DUMP_FILE"
trap - EXIT

BYTES=$(wc -c < "$DUMP_FILE" | tr -d ' ')
echo "Exported ${PROJECT} -> www/database/sync/dragonfly.sql (${BYTES} bytes)"
echo "Next: git add www/database/sync/dragonfly.sql && git commit && git push"

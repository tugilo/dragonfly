#!/usr/bin/env bash
# Import www/database/sync/dragonfly.sql into local MariaDB (full replace).
# Usage: bin/db-import.sh   or   make db-import
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=bin/lib/compose.sh
source "$REPO_ROOT/bin/lib/compose.sh"
# shellcheck source=bin/lib/religo-db-patch.sh
source "$REPO_ROOT/bin/lib/religo-db-patch.sh"

compose_require_project_env "$REPO_ROOT"

DUMP_FILE="$REPO_ROOT/www/database/sync/dragonfly.sql"

if [ ! -f "$DUMP_FILE" ]; then
  echo "Error: dump not found: www/database/sync/dragonfly.sql" >&2
  echo "Run git pull on a machine that has exported the DB, or make db-export locally." >&2
  exit 1
fi

if ! compose_db_ready "$REPO_ROOT"; then
  echo "Error: db container is not running. Start with:" >&2
  echo "  docker compose -f infra/compose/docker-compose.yml --env-file project.env up -d" >&2
  exit 1
fi

echo "WARNING: This replaces all data in database '${PROJECT}'."
read -r -p "Continue? [y/N] " ans
case "$ans" in
  y|Y|yes|YES) ;;
  *) echo "Aborted."; exit 0 ;;
esac

compose_exec_db mariadb -u root -proot -e \
  "DROP DATABASE IF EXISTS \`${PROJECT}\`; CREATE DATABASE \`${PROJECT}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

compose_exec_db mariadb -u root -proot "$PROJECT" < "$DUMP_FILE"

religo_patch_dragonfly_workspace_name "$REPO_ROOT"

echo "Imported www/database/sync/dragonfly.sql into ${PROJECT} (workspace name patched to DragonFly if needed)."

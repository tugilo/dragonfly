#!/usr/bin/env bash
# shellcheck shell=bash
# Post-import patches for local DB (prod dumps keep legacy workspace bootstrap name).

religo_patch_dragonfly_workspace_name() {
  local root="$1"
  compose_require_project_env "$root"

  if ! docker compose "${COMPOSE_ARGS[@]}" ps --status running --services 2>/dev/null | grep -qx app; then
    echo "Skip workspace patch: app container is not running." >&2
    return 0
  fi

  echo "Patching workspace id=1: Default Workspace -> DragonFly ..."
  docker compose "${COMPOSE_ARGS[@]}" exec -T app php artisan migrate \
    --path=database/migrations/2026_06_04_100000_rename_default_workspace_to_dragonfly.php \
    --force
}

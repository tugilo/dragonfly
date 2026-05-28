#!/usr/bin/env bash
# shellcheck shell=bash
# Shared docker compose helpers for bin/*.sh

compose_require_project_env() {
  local root="$1"
  if [ ! -f "$root/project.env" ]; then
    echo "Error: project.env not found. Run make setup first." >&2
    exit 1
  fi
  # shellcheck source=/dev/null
  source "$root/project.env"
  if [ -z "${PROJECT:-}" ]; then
    echo "Error: PROJECT is not set in project.env" >&2
    exit 1
  fi
  COMPOSE_ARGS=(-f "$root/infra/compose/docker-compose.yml" --env-file "$root/project.env")
}

compose_exec_db() {
  docker compose "${COMPOSE_ARGS[@]}" exec -T db "$@"
}

compose_db_ready() {
  docker compose "${COMPOSE_ARGS[@]}" ps --status running --services 2>/dev/null | grep -qx db
}

#!/usr/bin/env bash
# shellcheck shell=bash
# Remote (Sakura VPS) helpers for DB sync between prod/dev and local.
#
# Remote host: override with RELIGO_REMOTE_SSH (default: tugilo.com — same alias used by GitHub Actions SSH_HOST).
# Targets:
#   prod -> /var/www/laravel/religo_app  (DB religo_app / religo.tugilo.com)
#   dev  -> /var/www/laravel/religo_dev  (DB religo_dev / religo-dev.tugilo.com)
#
# DB credentials are read from the remote .env on the fly (never hardcoded here).

RELIGO_REMOTE_SSH="${RELIGO_REMOTE_SSH:-tugilo.com}"
RELIGO_REMOTE_PHP="${RELIGO_REMOTE_PHP:-/usr/bin/php8.4}"

remote_path_for() {
  case "$1" in
    prod) echo "/var/www/laravel/religo_app" ;;
    dev) echo "/var/www/laravel/religo_dev" ;;
    *)
      echo "Error: unknown target '$1' (use: prod | dev)" >&2
      return 1
      ;;
  esac
}

# remote_dump <target>  — stream a mysqldump of the remote DB to stdout.
remote_dump() {
  local path
  path="$(remote_path_for "$1")" || return 1
  ssh -o BatchMode=yes "$RELIGO_REMOTE_SSH" bash -s "$path" <<'REMOTE'
set -euo pipefail
cd "$1"
set -a; . ./.env; set +a
MYSQL_PWD="${DB_PASSWORD:-}" mariadb-dump -u"${DB_USERNAME:-root}" \
  --single-transaction --routines --triggers --add-drop-table "${DB_DATABASE}"
REMOTE
}

# remote_recreate_and_load <target> <local_sql_file>  — DROP/CREATE remote DB then load file.
remote_recreate_and_load() {
  local path file remote_tmp
  path="$(remote_path_for "$1")" || return 1
  file="$2"
  remote_tmp="/tmp/religo_push_$$_$(date +%s).sql"

  scp -o BatchMode=yes "$file" "$RELIGO_REMOTE_SSH:$remote_tmp"
  ssh -o BatchMode=yes "$RELIGO_REMOTE_SSH" bash -s "$path" "$remote_tmp" <<'REMOTE'
set -euo pipefail
cd "$1"
TMP="$2"
set -a; . ./.env; set +a
MYSQL_PWD="${DB_PASSWORD:-}" mariadb -u"${DB_USERNAME:-root}" \
  -e "DROP DATABASE IF EXISTS \`${DB_DATABASE}\`; CREATE DATABASE \`${DB_DATABASE}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
MYSQL_PWD="${DB_PASSWORD:-}" mariadb -u"${DB_USERNAME:-root}" "${DB_DATABASE}" < "$TMP"
rm -f "$TMP"
echo "Loaded into ${DB_DATABASE} on $(hostname)."
REMOTE
}

# remote_artisan <target> <artisan-args...>  — run php artisan on the remote deploy path.
remote_artisan() {
  local target="$1"
  shift
  local path args_quoted="" arg

  if [ "$#" -eq 0 ]; then
    echo "Error: remote_artisan requires artisan arguments" >&2
    return 1
  fi

  path="$(remote_path_for "$target")" || return 1
  for arg in "$@"; do
    args_quoted+=" $(printf '%q' "$arg")"
  done

  ssh -o BatchMode=yes "$RELIGO_REMOTE_SSH" \
    "cd $(printf '%q' "$path") && $(printf '%q' "$RELIGO_REMOTE_PHP") artisan${args_quoted}"
}

#!/usr/bin/env bash
# プロジェクト内で実行する。そのプロジェクトの infra/ で docker compose し、Laravel を構築する。
# 用法: bin/setup.sh [PROJECT]
#   PROJECT 省略時はプロジェクト名 = カレントディレクトリ名（例: fluo）
# 1. project.env 生成
# 2. docker compose up -d --build（このプロジェクトの infra/compose を使用）
# 3. コンテナ内で Laravel create-project / .env 書き換え / key:generate / migrate
set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

# プロジェクト名: 引数 or このディレクトリ名。プロジェクトルート = このディレクトリ（infra を内包する）
PROJECT="${1:-$(basename "$REPO_ROOT")}"
PROJECT_DIR="$REPO_ROOT"

if [ ! -d "$REPO_ROOT/infra/compose" ]; then
  echo "Error: infra/compose not found in $REPO_ROOT. Run this from a project that has infra/ (e.g. after make new-project <name>)." >&2
  exit 1
fi

echo "Project: $PROJECT (directory: $PROJECT_DIR)"

# versions.env 読み込み
if [ -f "$REPO_ROOT/versions.env" ]; then
  set -a
  # shellcheck source=/dev/null
  source "$REPO_ROOT/versions.env"
  set +a
else
  echo "Error: versions.env not found in $REPO_ROOT" >&2
  exit 1
fi

# preflight: ポート競合時は空きポートへ自動スライド（PORT_GUARD=true かつ未指定時のみ）
if [ -f "$REPO_ROOT/bin/preflight.sh" ]; then
  # shellcheck source=/dev/null
  source "$REPO_ROOT/bin/preflight.sh"
fi

# 標準ポートレンジ: APP 80-89（http://localhost で開く）/ DB 3307-3399 / PMA 8081-8181
APP_PORT_DEFAULT=80
APP_PORT_MAX=89
DB_PORT_DEFAULT=3307
DB_PORT_MAX=3399
PMA_PORT_DEFAULT=8081
PMA_PORT_MAX=8181

# PORT_GUARD が false の場合はスライドせずデフォルト（または既に指定された値）を使用
PORT_GUARD_ENABLED="${PORT_GUARD:-true}"
if [ "$PORT_GUARD_ENABLED" != "true" ]; then
  APP_PORT="${APP_PORT:-$APP_PORT_DEFAULT}"
  DB_PORT="${DB_PORT:-$DB_PORT_DEFAULT}"
  PMA_PORT="${PMA_PORT:-$PMA_PORT_DEFAULT}"
else
  # 未指定時のみ自動スライド。明示指定（APP_PORT=9000 make setup）の場合はそのまま使用
  if [ -z "${APP_PORT+x}" ] || [ -z "$APP_PORT" ]; then
    p=$(find_free_port "$APP_PORT_DEFAULT" "$APP_PORT_MAX" 2>/dev/null) || { echo "Error: no free port in range $APP_PORT_DEFAULT..$APP_PORT_MAX" >&2; exit 1; }
    # 戻り値がレンジ外ならデフォルトにフォールバック（他プロジェクトの preflight 不整合対策）
    if [ -z "$p" ] || [ "$p" -lt "$APP_PORT_DEFAULT" ] 2>/dev/null || [ "$p" -gt "$APP_PORT_MAX" ] 2>/dev/null; then
      p=$APP_PORT_DEFAULT
    fi
    APP_PORT=$p
    [ "$p" != "$APP_PORT_DEFAULT" ] && echo "⚠️  $APP_PORT_DEFAULT is already in use. Switching to $p"
  fi
  if [ -z "${DB_PORT+x}" ] || [ -z "$DB_PORT" ]; then
    p=$(find_free_port "$DB_PORT_DEFAULT" "$DB_PORT_MAX" 2>/dev/null) || { echo "Error: no free port in range $DB_PORT_DEFAULT..$DB_PORT_MAX" >&2; exit 1; }
    if [ -z "$p" ] || [ "$p" -lt "$DB_PORT_DEFAULT" ] 2>/dev/null || [ "$p" -gt "$DB_PORT_MAX" ] 2>/dev/null; then
      p=$DB_PORT_DEFAULT
    fi
    DB_PORT=$p
    [ "$p" != "$DB_PORT_DEFAULT" ] && echo "⚠️  $DB_PORT_DEFAULT is already in use. Switching to $p"
  fi
  if [ -z "${PMA_PORT+x}" ] || [ -z "$PMA_PORT" ]; then
    p=$(find_free_port "$PMA_PORT_DEFAULT" "$PMA_PORT_MAX" 2>/dev/null) || { echo "Error: no free port in range $PMA_PORT_DEFAULT..$PMA_PORT_MAX" >&2; exit 1; }
    if [ -z "$p" ] || [ "$p" -lt "$PMA_PORT_DEFAULT" ] 2>/dev/null || [ "$p" -gt "$PMA_PORT_MAX" ] 2>/dev/null; then
      p=$PMA_PORT_DEFAULT
    fi
    PMA_PORT=$p
    [ "$p" != "$PMA_PORT_DEFAULT" ] && echo "⚠️  $PMA_PORT_DEFAULT is already in use. Switching to $p"
  fi
  # PMA が DB ポートと被らないようにする（既存 project.env の不整合対策）
  if [ -n "$PMA_PORT" ] && [ "$PMA_PORT" -ge "$DB_PORT_DEFAULT" ] 2>/dev/null && [ "$PMA_PORT" -le "$DB_PORT_MAX" ] 2>/dev/null; then
    echo "⚠️  PMA_PORT was in DB range ($PMA_PORT). Using $PMA_PORT_DEFAULT for phpMyAdmin."
    PMA_PORT=$PMA_PORT_DEFAULT
  fi
  # APP が DB ポートと被らないようにする（戻り値がレンジ外だった場合のフォールバック）
  if [ -n "$APP_PORT" ] && [ "$APP_PORT" -ge "$DB_PORT_DEFAULT" ] 2>/dev/null && [ "$APP_PORT" -le "$DB_PORT_MAX" ] 2>/dev/null; then
    echo "⚠️  APP_PORT was in DB range ($APP_PORT). Finding free port in $APP_PORT_DEFAULT-$APP_PORT_MAX."
    p=$(find_free_port "$APP_PORT_DEFAULT" "$APP_PORT_MAX" 2>/dev/null) || true
    if [ -n "$p" ] && [ "$p" -ge "$APP_PORT_DEFAULT" ] 2>/dev/null && [ "$p" -le "$APP_PORT_MAX" ] 2>/dev/null; then
      APP_PORT=$p
    else
      APP_PORT=$APP_PORT_DEFAULT
    fi
  fi
fi

# project.env 生成（COMPOSE_PROJECT_NAME で Docker のプロジェクト名をプロジェクト名に）
# ポート・PMA は preflight で決定した値または強制指定値を書き込む
cat > "$REPO_ROOT/project.env" << ENVEOF
COMPOSE_PROJECT_NAME=$PROJECT
PROJECT=$PROJECT
PROJECT_DIR=$PROJECT_DIR
PHP_VERSION=${PHP_VERSION:-8.4}
NODE_VERSION=${NODE_VERSION:-20}
MARIADB_VERSION=${MARIADB_VERSION:-11.2}
LARAVEL_VERSION=${LARAVEL_VERSION:-12}
APP_PORT=$APP_PORT
DB_PORT=$DB_PORT
PMA_PORT=$PMA_PORT
PMA_UPLOAD_LIMIT=${PMA_UPLOAD_LIMIT:-64M}
PORT_GUARD=${PORT_GUARD:-true}
ENVEOF

echo "Generated project.env (PROJECT=$PROJECT, APP_PORT=$APP_PORT, DB_PORT=$DB_PORT, PMA_PORT=$PMA_PORT)"

# Docker 起動（このプロジェクトの infra を使用）
echo "Starting Docker Compose..."
mkdir -p "$REPO_ROOT/www"
docker compose -f "$REPO_ROOT/infra/compose/docker-compose.yml" --env-file "$REPO_ROOT/project.env" up -d --build

# コンテナ就緒まで少し待つ
echo "Waiting for containers..."
sleep 5

COMPOSE_ARGS=(-f "$REPO_ROOT/infra/compose/docker-compose.yml" --env-file "$REPO_ROOT/project.env")

run_app() {
  docker compose "${COMPOSE_ARGS[@]}" exec -T -e PROJECT="$PROJECT" app "$@"
}

# Laravel がまだなければ create-project（artisan の有無で判定）
if ! run_app test -f /var/www/artisan 2>/dev/null; then
  echo "Installing Laravel ${LARAVEL_VERSION} in $PROJECT_DIR..."
  run_app sh -c 'cp /var/www/.gitignore /var/www/.gitignore.bak 2>/dev/null || true'
  run_app composer create-project "laravel/laravel:^${LARAVEL_VERSION}" /tmp/laravel-new --no-interaction
  run_app sh -c 'cp -r /tmp/laravel-new/. /var/www/ && mv /var/www/.gitignore.bak /var/www/.gitignore 2>/dev/null; rm -rf /tmp/laravel-new'
fi

# .env を php -r で安全に書き換え（sed は使わない）。Laravel は www/ = コンテナの /var/www に配置。
echo "Updating Laravel .env (DB name/user/password = $PROJECT)..."
run_app php -r "
\$p = getenv('PROJECT');
if (!\$p) { fwrite(STDERR, 'PROJECT env not set'); exit(1); }
\$f = '/var/www/.env';
if (!is_file(\$f)) { fwrite(STDERR, '.env not found'); exit(1); }
\$env = file_get_contents(\$f);
\$env = preg_replace('/^DB_DATABASE=.*/m', 'DB_DATABASE='.\$p, \$env);
\$env = preg_replace('/^DB_USERNAME=.*/m', 'DB_USERNAME='.\$p, \$env);
\$env = preg_replace('/^DB_PASSWORD=.*/m', 'DB_PASSWORD='.\$p, \$env);
\$env = preg_replace('/^DB_HOST=.*/m', 'DB_HOST=db', \$env);
file_put_contents(\$f, \$env);
echo 'Done';
"

run_app php artisan key:generate --no-interaction
echo "Running migrations..."
run_app php artisan migrate --force

echo ""
echo "Setup complete. Open http://localhost (or http://localhost:$APP_PORT if port was changed)"
echo "Laravel project: $PROJECT_DIR/www (infra/ と www/ は同階層)"
echo "phpMyAdmin: http://localhost:$PMA_PORT (login: root/root or ${PROJECT}/${PROJECT})"
echo "Containers: $(docker compose "${COMPOSE_ARGS[@]}" ps -q | wc -l | tr -d ' ') expected (app, node, nginx, db, phpmyadmin)."

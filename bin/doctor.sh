#!/usr/bin/env bash
# 基盤自己診断: Docker 起動・ポート・project.env・healthcheck・Laravel 応答を確認
# 用法: bin/doctor.sh（プロジェクトルートで実行）
set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

COMPOSE_FILE="$REPO_ROOT/infra/compose/docker-compose.yml"
ENV_FILE="$REPO_ROOT/project.env"

ok() { echo "  ✅ $1"; }
ng() { echo "  ❌ $1" >&2; }
warn() { echo "  ⚠️  $1"; }

echo "=== tugilo Standard Docker – doctor ==="

# 1. Docker 起動確認
echo ""
echo "[1] Docker"
if docker info &>/dev/null; then
  ok "Docker is running"
else
  ng "Docker is not running or not accessible"
  exit 1
fi

# 2. 必須ファイル
echo ""
echo "[2] Required files"
if [ ! -f "$COMPOSE_FILE" ]; then
  ng "Compose file not found: $COMPOSE_FILE (run from project root or after make new-project)"
  exit 1
fi
ok "Compose file exists"

if [ ! -f "$ENV_FILE" ]; then
  warn "project.env not found (run make setup first)"
  APP_PORT="${APP_PORT:-80}"
  DB_PORT="${DB_PORT:-3307}"
  PMA_PORT="${PMA_PORT:-8081}"
else
  set -a
  # shellcheck source=/dev/null
  source "$ENV_FILE"
  set +a
  ok "project.env exists"
fi

# 3. project.env 整合性確認
echo ""
echo "[3] project.env"
if [ -f "$ENV_FILE" ]; then
  for key in COMPOSE_PROJECT_NAME PROJECT PROJECT_DIR APP_PORT DB_PORT PMA_PORT; do
    if [ -z "${!key+x}" ] || [ -z "${!key}" ]; then
      warn "Missing or empty: $key"
    else
      ok "$key=${!key}"
    fi
  done
  if [ -n "${PORT_GUARD+x}" ]; then
    ok "PORT_GUARD=$PORT_GUARD"
  fi
else
  warn "Skipped (no project.env)"
fi

# 4. 必須ポート使用確認（Docker またはホスト）
echo ""
echo "[4] Ports (APP=$APP_PORT, DB=$DB_PORT, PMA=$PMA_PORT)"
if command -v lsof &>/dev/null; then
  for port in "$APP_PORT" "$DB_PORT" "$PMA_PORT"; do
    if lsof -i ":$port" &>/dev/null; then
      ok "Port $port is in use (expected if containers are running)"
    else
      warn "Port $port is not in use (containers may be stopped)"
    fi
  done
else
  warn "lsof not available, skipping port check"
fi

# 5. healthcheck 確認（コンテナ起動時のみ）
echo ""
echo "[5] Healthcheck (containers)"
COMPOSE_EXTRA=()
[ -f "$ENV_FILE" ] && COMPOSE_EXTRA=(--env-file "$ENV_FILE")
if [ ${#COMPOSE_EXTRA[@]} -gt 0 ] && docker compose -f "$COMPOSE_FILE" "${COMPOSE_EXTRA[@]}" ps -q &>/dev/null; then
  count=$(docker compose -f "$COMPOSE_FILE" "${COMPOSE_EXTRA[@]}" ps -q 2>/dev/null | wc -l | tr -d ' ')
  if [ "$count" -gt 0 ]; then
    ok "Containers found: $count"
    unhealthy=$(docker compose -f "$COMPOSE_FILE" "${COMPOSE_EXTRA[@]}" ps -a --format '{{.Name}} {{.Status}}' 2>/dev/null | grep -c "unhealthy" || true)
    if [ "${unhealthy:-0}" -gt 0 ]; then
      warn "Some containers are unhealthy (check: docker compose -f infra/compose/docker-compose.yml --env-file project.env ps -a)"
    else
      ok "No unhealthy containers reported"
    fi
  else
    warn "No containers running"
  fi
else
  warn "No project.env or no containers running"
fi

# 6. Laravel 応答確認
echo ""
echo "[6] Laravel response (http://localhost:${APP_PORT:-80})"
if curl -sS -o /dev/null -w "%{http_code}" "http://127.0.0.1:${APP_PORT:-80}" 2>/dev/null | grep -q 200; then
  ok "Laravel responds with HTTP 200"
else
  warn "Laravel did not respond with 200 (container may be stopped or starting)"
fi

echo ""
echo "=== doctor done ==="

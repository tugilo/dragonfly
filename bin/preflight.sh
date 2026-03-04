#!/usr/bin/env bash
# ポート使用確認・空きポート探索（mac / WSL2 両対応）
# setup.sh から source して使用する。sed は使用しない。
#
# 標準ポートレンジ: APP 80-89（http://localhost）/ DB 3307-3399 / PMA 8081-8181
#
# 提供関数:
#   get_docker_host_ports     - Docker がバインドしているホストポートを1行1ポートで出力
#   is_port_in_use PORT      - ポートが使用中なら 0、空きなら 1（ホスト + docker ps を考慮）
#   find_free_port START [MAX] - START から +1 ずつ最大10回、MAX を超えずに空きを探す

# Docker が現在バインドしているホストポートを出力（1行1ポート）
get_docker_host_ports() {
  docker ps --format '{{.Ports}}' 2>/dev/null | while IFS= read -r line; do
    for segment in $line; do
      if [[ "$segment" == *"->"* ]]; then
        left="${segment%%->*}"
        port="${left##*:}"
        [[ "$port" =~ ^[0-9]+$ ]] && echo "$port"
      fi
    done
  done
}

# 指定ポートが使用中かどうか（ホストの lsof/nc + 既存 Docker のバインドを考慮）
# 戻り値: 0 = 使用中, 1 = 空き
# 注意: find_free_port から呼ぶ前に DOCKER_HOST_PORTS を設定すると docker のバインドも考慮する
is_port_in_use() {
  local port="$1"
  if [ -z "$port" ] || ! [[ "$port" =~ ^[0-9]+$ ]]; then
    return 1
  fi
  # Docker が既にそのポートをバインドしているか
  if [ -n "${DOCKER_HOST_PORTS:-}" ]; then
    for bound_port in $DOCKER_HOST_PORTS; do
      [[ "$bound_port" == "$port" ]] && return 0
    done
  fi
  # ホストで使用中か
  if command -v lsof &>/dev/null; then
    lsof -i ":$port" &>/dev/null && return 0
  else
    nc -z 127.0.0.1 "$port" 2>/dev/null && return 0
  fi
  return 1
}

# 指定ポートから +1 ずつ空きを探す（最大10回、max_port を超えない）
# 用法: find_free_port START [MAX_PORT]
# 出力: 見つかった空きポートを標準出力
# 戻り値: 0 = 成功, 1 = 空きなし
find_free_port() {
  local start_port="$1"
  local max_port="${2:-}"
  local i
  if [ -z "$start_port" ] || ! [[ "$start_port" =~ ^[0-9]+$ ]]; then
    echo "find_free_port: invalid start port: $start_port" >&2
    return 1
  fi
  # Docker がバインドしているポート一覧を取得（この関数内で一度だけ）
  DOCKER_HOST_PORTS=$(get_docker_host_ports)
  for ((i = 0; i < 10; i++)); do
    local p=$((start_port + i))
    [ -n "$max_port" ] && [ "$p" -gt "$max_port" ] 2>/dev/null && break
    if ! is_port_in_use "$p"; then
      echo "$p"
      return 0
    fi
  done
  return 1
}

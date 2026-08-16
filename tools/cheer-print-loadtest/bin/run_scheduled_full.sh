#!/usr/bin/env bash
# launchd 用: 合意枠でのみ ./run.sh full を実行する
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LOG_DIR="${ROOT}/results/logs"
LOCK="${LOG_DIR}/full.lock"
STAMP="$(TZ=Asia/Tokyo date '+%Y%m%d_%H%M')"
LOG="${LOG_DIR}/scheduled_full_${STAMP}.log"
TARGET_DATE="${TARGET_DATE:-2026-08-08}"

mkdir -p "${LOG_DIR}"
exec >>"${LOG}" 2>&1

echo "==== scheduled full start $(TZ=Asia/Tokyo date '+%Y-%m-%d %H:%M:%S %Z') ===="
echo "ROOT=${ROOT} LOG=${LOG}"

# PATH（launchd はほぼ空）
export PATH="/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin:${PATH:-}"

TODAY="$(TZ=Asia/Tokyo date '+%Y-%m-%d')"
HOUR="$(TZ=Asia/Tokyo date '+%H')"
# 先頭ゼロ対策（08 → 8）で数値比較を安定させる
HOUR=$((10#${HOUR}))

if [[ "${TODAY}" != "${TARGET_DATE}" ]]; then
  echo "SKIP: today=${TODAY} target=${TARGET_DATE} (date guard)"
  exit 0
fi

# 22:00-23:59 only
if (( HOUR < 22 )); then
  echo "SKIP: hour=${HOUR} (before 22:00)"
  exit 0
fi

if [[ -f "${LOCK}" ]]; then
  echo "SKIP: lock exists (${LOCK})"
  exit 0
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "ERROR: docker not found"
  exit 1
fi

if ! docker info >/dev/null 2>&1; then
  echo "ERROR: Docker is not running. Start Docker Desktop first."
  exit 1
fi

if ! command -v node >/dev/null 2>&1; then
  echo "ERROR: node not found (needed for report)"
  exit 1
fi

cleanup() {
  rm -f "${LOCK}"
}
trap cleanup EXIT
echo $$ >"${LOCK}"

if command -v osascript >/dev/null 2>&1; then
  osascript -e 'display notification "Cheer Print full load test starting" with title "cheer-print-loadtest"' || true
fi

echo "Running: caffeinate -dims ./run.sh full"
cd "${ROOT}"
set +e
caffeinate -dims ./run.sh full
STATUS=$?
set -e

echo "==== scheduled full end status=${STATUS} $(TZ=Asia/Tokyo date '+%Y-%m-%d %H:%M:%S %Z') ===="

# run.sh は報告生成まで含む。完了後に LaunchAgent を外す（SKIP 時は触らない）
echo "Uninstalling LaunchAgent after run..."
if bash "${ROOT}/bin/uninstall_launchd.sh"; then
  echo "LaunchAgent uninstalled."
else
  echo "WARN: uninstall_launchd.sh failed (remove manually if needed)"
fi

if command -v osascript >/dev/null 2>&1; then
  if [[ ${STATUS} -eq 0 ]]; then
    osascript -e 'display notification "Cheer Print full done. Agent removed. Check results/" with title "cheer-print-loadtest"' || true
  else
    osascript -e "display notification \"Cheer Print full failed (exit ${STATUS}). Agent removed.\" with title \"cheer-print-loadtest\"" || true
  fi
fi

exit "${STATUS}"

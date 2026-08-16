#!/usr/bin/env bash
# Cheer Print loadtest runner (local Docker first)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
PROFILE="${1:-dry}"
STAMP="${STAMP:-$(TZ=Asia/Tokyo date '+%Y%m%d_%H%M')}"
SOURCE="${SOURCE:-local-docker}"
IMAGE="${K6_IMAGE:-grafana/k6:latest}"

mkdir -p "$ROOT/results"

if [[ "$PROFILE" != "dry" && "$PROFILE" != "full" ]]; then
  echo "Usage: ./run.sh dry|full" >&2
  exit 1
fi

if [[ "$PROFILE" == "dry" ]]; then
  MAX_VU_STATIC="${MAX_VU_STATIC:-2}"
  MAX_VU_WP="${MAX_VU_WP:-2}"
else
  MAX_VU_STATIC="${MAX_VU_STATIC:-100}"
  MAX_VU_WP="${MAX_VU_WP:-100}"
fi

SLEEP="${SLEEP:-1}"
TIMEOUT_MS="${TIMEOUT_MS:-30000}"

run_one() {
  local script="$1"
  local scenario_id="$2"
  local max_vu="$3"

  echo ""
  echo "=== k6 ${scenario_id} (PROFILE=${PROFILE}, MAX_VU=${max_vu}) ==="

  docker run --rm -i \
    -v "$ROOT:/work" \
    -w /work \
    -e PROFILE="$PROFILE" \
    -e SCENARIO_ID="$scenario_id" \
    -e MAX_VU="$max_vu" \
    -e STAMP="$STAMP" \
    -e SOURCE="$SOURCE" \
    -e SLEEP="$SLEEP" \
    -e TIMEOUT_MS="$TIMEOUT_MS" \
    "$IMAGE" run "scenarios/${script}"
}

echo "Cheer Print loadtest"
echo "PROFILE=${PROFILE} STAMP=${STAMP} SOURCE=${SOURCE}"
echo "Results -> ${ROOT}/results"

OVERALL_STATUS=0
set +e
run_one "static_landing.js" "static_landing" "$MAX_VU_STATIC"
s1=$?
run_one "wp_origin.js" "wp_origin" "$MAX_VU_WP"
s2=$?
set -e
if [[ $s1 -ne 0 ]]; then OVERALL_STATUS=$s1; fi
if [[ $s2 -ne 0 ]]; then OVERALL_STATUS=$s2; fi

echo ""
echo "=== generate report ==="
node "$ROOT/report/generate_report.mjs" --dir "$ROOT/results" --stamp "$STAMP"

echo ""
echo "Done. Open:"
echo "  ${ROOT}/results/report_${STAMP}.md"
echo "  ${ROOT}/results/report_${STAMP}.html"
exit "${OVERALL_STATUS}"

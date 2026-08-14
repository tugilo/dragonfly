#!/usr/bin/env bash
# 2026-08-08 22:00（Mac ローカル時刻＝JST想定）に full を起動する LaunchAgent を登録
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LABEL="com.tugilo.cheer-print-loadtest-full"
PLIST="$HOME/Library/LaunchAgents/${LABEL}.plist"
WRAPPER="$ROOT/bin/run_scheduled_full.sh"
LOG_DIR="$ROOT/results/logs"

chmod +x "$WRAPPER" "$ROOT/run.sh" "$ROOT/bin/install_launchd.sh" "$ROOT/bin/uninstall_launchd.sh" 2>/dev/null || true
mkdir -p "$HOME/Library/LaunchAgents" "$LOG_DIR"

cat >"$PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>${LABEL}</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/bash</string>
    <string>${WRAPPER}</string>
  </array>
  <key>WorkingDirectory</key>
  <string>${ROOT}</string>
  <key>StartCalendarInterval</key>
  <dict>
    <key>Month</key>
    <integer>8</integer>
    <key>Day</key>
    <integer>8</integer>
    <key>Hour</key>
    <integer>22</integer>
    <key>Minute</key>
    <integer>0</integer>
  </dict>
  <key>StandardOutPath</key>
  <string>${LOG_DIR}/launchd_stdout.log</string>
  <key>StandardErrorPath</key>
  <string>${LOG_DIR}/launchd_stderr.log</string>
  <key>RunAtLoad</key>
  <false/>
</dict>
</plist>
EOF

UID_NUM="$(id -u)"
launchctl bootout "gui/${UID_NUM}/${LABEL}" 2>/dev/null || true
launchctl bootstrap "gui/${UID_NUM}" "$PLIST"
launchctl enable "gui/${UID_NUM}/${LABEL}" 2>/dev/null || true

echo "Installed: $PLIST"
echo "Schedule: every Aug 8 22:00 (local time). Wrapper date-guards to ${TARGET_DATE:-2026-08-08} only."
echo "Verify:   launchctl print gui/${UID_NUM}/${LABEL} | head -40"
echo "Uninstall: $ROOT/bin/uninstall_launchd.sh"
echo ""
echo "事前確認:"
echo "  - 21:50 頃までに Mac 起動・スリープ解除・電源接続"
echo "  - Docker Desktop 起動済み"
echo "  - 完了後は Agent 自動解除（手動 uninstall 不要）"

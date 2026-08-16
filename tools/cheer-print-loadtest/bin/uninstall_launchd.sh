#!/usr/bin/env bash
# Cheer Print full の LaunchAgent を解除
set -euo pipefail

LABEL="com.tugilo.cheer-print-loadtest-full"
PLIST="$HOME/Library/LaunchAgents/${LABEL}.plist"
UID_NUM="$(id -u)"

launchctl bootout "gui/${UID_NUM}/${LABEL}" 2>/dev/null || true
rm -f "$PLIST"

echo "Removed LaunchAgent: ${LABEL}"
echo "(wrapper / tools 本体は残しています)"

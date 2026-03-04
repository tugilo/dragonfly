#!/usr/bin/env bash
# 既存プロジェクトに tugilo 開発スタイル（docs + .cursorrules 追記）のみを取り込む。
# Docker / infra は変更しない。
# すでに tugilo スタイルが揃っている場合は何もせず「準備OK」メッセージを表示する。
# 用法: 当該プロジェクトのルートで実行する。
#   PROJECT=<プロジェクト名> bash /path/to/tugilo-template/bin/adopt-tugilo-style.sh
# または tugilo-template から:
#   bash bin/adopt-tugilo-style.sh <対象プロジェクトのパス> [プロジェクト名]
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

if [ -n "$1" ] && [ -d "$1" ]; then
  TARGET_ROOT="$(cd "$1" && pwd)"
  PROJECT="${2:-$(basename "$TARGET_ROOT")}"
else
  TARGET_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
  PROJECT="${PROJECT:-$(basename "$TARGET_ROOT")}"
fi

# すでに tugilo スタイルが揃っているか判定（上書きしない）
INDEX_OK=0
PROGRESS_OK=0
RULES_OK=0
[ -f "$TARGET_ROOT/docs/INDEX.md" ] && INDEX_OK=1
[ -f "$TARGET_ROOT/docs/${PROJECT}_progress.md" ] && PROGRESS_OK=1
[ -f "$TARGET_ROOT/.cursorrules" ] && grep -q "ドキュメント・進捗管理（tugilo スタイル）" "$TARGET_ROOT/.cursorrules" 2>/dev/null && RULES_OK=1

if [ "$INDEX_OK" = 1 ] && [ "$PROGRESS_OK" = 1 ] && [ "$RULES_OK" = 1 ]; then
  echo ""
  echo "  ✅ 準備OK — このプロジェクトはすでに tugilo 開発スタイルに沿っています。"
  echo "     docs/INDEX.md, docs/${PROJECT}_progress.md, .cursorrules の追記が揃っているため、変更は行いません。"
  echo ""
  exit 0
fi

echo "Adopting tugilo dev style into: $TARGET_ROOT (PROJECT=$PROJECT)"

mkdir -p "$TARGET_ROOT/docs/process"

# INDEX（無いときだけ作成）
if [ -f "$TEMPLATE_ROOT/docs/INDEX.project" ] && [ "$INDEX_OK" != 1 ]; then
  while IFS= read -r line; do echo "${line//\{\{PROJECT\}\}/$PROJECT}"; done < "$TEMPLATE_ROOT/docs/INDEX.project" > "$TARGET_ROOT/docs/INDEX.md"
  echo "Created docs/INDEX.md"
fi

# progress（無いときだけ作成）
if [ -f "$TEMPLATE_ROOT/docs/_progress.project.md" ] && [ "$PROGRESS_OK" != 1 ]; then
  while IFS= read -r line; do echo "${line//\{\{PROJECT\}\}/$PROJECT}"; done < "$TEMPLATE_ROOT/docs/_progress.project.md" > "$TARGET_ROOT/docs/${PROJECT}_progress.md"
  echo "Created docs/${PROJECT}_progress.md"
fi

# process/README（無いときだけ）
if [ -f "$TEMPLATE_ROOT/docs/process/README.md" ] && [ ! -f "$TARGET_ROOT/docs/process/README.md" ]; then
  cp "$TEMPLATE_ROOT/docs/process/README.md" "$TARGET_ROOT/docs/process/README.md"
  echo "Created docs/process/README.md"
fi

# .cursorrules に追記（まだ tugilo スタイルが無いときだけ）
APPEND_FILE="$TEMPLATE_ROOT/docs/tugilo-style-append.cursorrules"
if [ -f "$APPEND_FILE" ] && [ "$RULES_OK" != 1 ]; then
  if [ -f "$TARGET_ROOT/.cursorrules" ]; then
    echo "" >> "$TARGET_ROOT/.cursorrules"
    echo "# -------- tugilo 開発スタイル（追記） --------" >> "$TARGET_ROOT/.cursorrules"
    cat "$APPEND_FILE" >> "$TARGET_ROOT/.cursorrules"
    echo "Appended tugilo style to .cursorrules"
  else
    cp "$APPEND_FILE" "$TARGET_ROOT/.cursorrules"
    echo "Created .cursorrules from tugilo-style-append.cursorrules"
  fi
elif [ "$RULES_OK" != 1 ] && [ ! -f "$APPEND_FILE" ]; then
  echo "Warning: $APPEND_FILE not found. Skip .cursorrules." >&2
fi

echo "Done. Progress: docs/${PROJECT}_progress.md, index: docs/INDEX.md, .cursorrules updated."

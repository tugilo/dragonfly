#!/usr/bin/env bash
# One-off: create fluolig project (same logic as make new-project PROJECT=fluolig)
# Usage: from repo root, run: bash bin/create-fluolig.sh
set -e
PROJECT=fluolig
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TARGET="$(cd "$TEMPLATE_ROOT/.." && pwd)/$PROJECT"
if [ -d "$TARGET" ]; then echo "Error: $TARGET already exists"; exit 1; fi
echo "Creating project at $TARGET"
mkdir -p "$TARGET"
for item in infra bin Makefile versions.env .gitignore; do
  [ -e "$TEMPLATE_ROOT/$item" ] && cp -R "$TEMPLATE_ROOT/$item" "$TARGET/"
done
[ -d "$TEMPLATE_ROOT/docs" ] && cp -R "$TEMPLATE_ROOT/docs" "$TARGET/"
PROJECT_NAME="$PROJECT"
if [ -f "$TEMPLATE_ROOT/.cursorrules.project" ]; then
  while IFS= read -r line; do echo "${line//\{\{PROJECT\}\}/$PROJECT_NAME}"; done < "$TEMPLATE_ROOT/.cursorrules.project" > "$TARGET/.cursorrules"
  echo "Created .cursorrules for project $PROJECT_NAME"
fi
if [ -f "$TEMPLATE_ROOT/docs/INDEX.project" ]; then
  while IFS= read -r line; do echo "${line//\{\{PROJECT\}\}/$PROJECT_NAME}"; done < "$TEMPLATE_ROOT/docs/INDEX.project" > "$TARGET/docs/INDEX.md"
  echo "Created docs/INDEX.md for project $PROJECT_NAME"
fi
if [ -f "$TEMPLATE_ROOT/docs/_progress.project.md" ]; then
  while IFS= read -r line; do echo "${line//\{\{PROJECT\}\}/$PROJECT_NAME}"; done < "$TEMPLATE_ROOT/docs/_progress.project.md" > "$TARGET/docs/${PROJECT_NAME}_progress.md"
  echo "Created docs/${PROJECT_NAME}_progress.md"
fi
rm -f "$TARGET/docs/INDEX.project" "$TARGET/docs/_progress.project.md" 2>/dev/null
echo "Running setup in $TARGET..."
(cd "$TARGET" && make setup)
echo "Done. Open http://localhost (or the port shown) for Laravel."

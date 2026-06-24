# tugilo-template Makefile
# テンプレートまたはプロジェクト内で使用。
# - make project <NAME>      … make new-project の短縮（例: make project fluolig）
# - make new-project <NAME> … テンプレートから新規プロジェクトを作成しセットアップ（テンプレート内で実行）
# - make setup [PROJECT]      … このプロジェクトの infra で Docker + Laravel をセットアップ（プロジェクト内で実行）

.PHONY: setup new-project project doctor db-export db-import db-pull db-push db-replicate-prod-to-dev db-restore-dev

# 基盤自己診断: Docker・ポート・project.env・healthcheck・Laravel応答
doctor:
	@bash "$(CURDIR)/bin/doctor.sh"

# ローカル DB → www/database/sync/dragonfly.sql（固定名・上書き）
db-export:
	@bash "$(CURDIR)/bin/db-export.sh"

# www/database/sync/dragonfly.sql → ローカル DB（全置換）
db-import:
	@bash "$(CURDIR)/bin/db-import.sh"

# 本番/テスト DB → ローカル（SSH 経由・全置換）。例: make db-pull TARGET=prod
db-pull:
	@bash "$(CURDIR)/bin/db-pull.sh" "$(or $(TARGET),prod)"

# ローカル DB → 本番/テスト（SSH 経由・全置換・要確認/自動バックアップ）。例: make db-push TARGET=dev
db-push:
	@bash "$(CURDIR)/bin/db-push.sh" "$(TARGET)"

# 本番 DB → テスト DB（SSH 直結・dev バックアップ必須・確認フレーズ）。ローカル Docker 不要。
db-replicate-prod-to-dev:
	@bash "$(CURDIR)/bin/db-replicate-prod-to-dev.sh"

# テスト DB をローカルバックアップから復元。例: make db-restore-dev BACKUP=backups/dev_YYYYMMDD_HHMMSS.sql
db-restore-dev:
	@if [ -z "$(BACKUP)" ]; then \
		echo "Usage: make db-restore-dev BACKUP=backups/dev_YYYYMMDD_HHMMSS.sql"; \
		exit 1; \
	fi
	@bash "$(CURDIR)/bin/db-restore-dev.sh" "$(BACKUP)"

# 新規プロジェクト作成: 隣に <NAME> ディレクトリを作り、infra/bin 等をコピーしてから make setup
# 例: make new-project fluo → ../fluo に fluo プロジェクトができる
# 短縮: make project fluolig でも同様
project: new-project

new-project:
	@if [ -z "$(PROJECT)" ]; then \
		echo "Usage: make new-project PROJECT=<name>"; \
		echo "Example: make new-project PROJECT=fluo"; \
		exit 1; \
	fi
	@TEMPLATE_ROOT="$(CURDIR)"; \
	TARGET="$$(cd "$$TEMPLATE_ROOT/.." && pwd)/$(PROJECT)"; \
	if [ -d "$$TARGET" ]; then echo "Error: $$TARGET already exists"; exit 1; fi; \
	echo "Creating project at $$TARGET"; \
	mkdir -p "$$TARGET"; \
	mkdir -p "$$TARGET/www"; \
	for item in infra bin Makefile versions.env .gitignore; do \
	  if [ -e "$$TEMPLATE_ROOT/$$item" ]; then cp -R "$$TEMPLATE_ROOT/$$item" "$$TARGET/"; fi; \
	done; \
	if [ -d "$$TEMPLATE_ROOT/docs" ]; then cp -R "$$TEMPLATE_ROOT/docs" "$$TARGET/"; fi; \
	PROJECT_NAME="$(PROJECT)"; \
	if [ -f "$$TEMPLATE_ROOT/.cursorrules.project" ]; then \
	  while IFS= read -r line; do echo "$${line//\{\{PROJECT\}\}/$$PROJECT_NAME}"; done < "$$TEMPLATE_ROOT/.cursorrules.project" > "$$TARGET/.cursorrules"; \
	  echo "Created .cursorrules for project $$PROJECT_NAME"; \
	fi; \
	if [ -f "$$TEMPLATE_ROOT/docs/INDEX.project" ]; then \
	  while IFS= read -r line; do echo "$${line//\{\{PROJECT\}\}/$$PROJECT_NAME}"; done < "$$TEMPLATE_ROOT/docs/INDEX.project" > "$$TARGET/docs/INDEX.md"; \
	  echo "Created docs/INDEX.md for project $$PROJECT_NAME"; \
	fi; \
	if [ -f "$$TEMPLATE_ROOT/docs/_progress.project.md" ]; then \
	  while IFS= read -r line; do echo "$${line//\{\{PROJECT\}\}/$$PROJECT_NAME}"; done < "$$TEMPLATE_ROOT/docs/_progress.project.md" > "$$TARGET/docs/$$PROJECT_NAME_progress.md"; \
	  echo "Created docs/$$PROJECT_NAME_progress.md"; \
	fi; \
	rm -f "$$TARGET/docs/INDEX.project" "$$TARGET/docs/_progress.project.md" 2>/dev/null; \
	echo "Running setup in $$TARGET..."; \
	(cd "$$TARGET" && make setup)

# このプロジェクトの infra で Docker + Laravel をセットアップ
# PROJECT 省略時は bin/setup.sh がディレクトリ名をプロジェクト名として使う
setup:
	@bash "$(CURDIR)/bin/setup.sh" "$(PROJECT)"

# make setup fluo の "fluo" を PROJECT に渡す
ifeq (setup,$(firstword $(MAKECMDGOALS)))
  PROJECT := $(word 2,$(MAKECMDGOALS))
  ifneq ($(PROJECT),)
    export PROJECT
  endif
endif

# make new-project fluo の "fluo" を PROJECT に渡す
ifeq (new-project,$(firstword $(MAKECMDGOALS)))
  PROJECT := $(word 2,$(MAKECMDGOALS))
  ifneq ($(PROJECT),)
    export PROJECT
  endif
endif

# make project fluolig の "fluolig" を PROJECT に渡す（project は new-project のエイリアス）
ifeq (project,$(firstword $(MAKECMDGOALS)))
  PROJECT := $(word 2,$(MAKECMDGOALS))
  ifneq ($(PROJECT),)
    export PROJECT
  endif
endif

# 第2引数（fluo など）をターゲットとして解釈させない
%:
	@:

# dragonfly / Religo

BNI DragonFly チャプター向け Religo プロトタイプ（Laravel + React）。  
**詳細ルールは @docs/AI_TOOLING.md を正とする。**

## 命名（必須）

- **Religo** = プロダクト / **DragonFly** = チャプター / **dragonfly** = リポジトリ名
- @docs/PROJECT_NAMING.md

## 構成

- Laravel: `www/`（app, routes, config, resources, database）
- Docker: `infra/compose/docker-compose.yml` + `project.env`
- ドキュメント: `docs/`

## DevOS（必須・実装前に読む）

1. 仕様: @docs/02_specifications/SSOT_REGISTRY.md
2. 次 Phase: @docs/process/PHASE_REGISTRY.md
3. **PLAN → WORKLOG → REPORT**（PLAN 完成前は実装禁止）
4. PR 禁止。merge はローカル → test → push develop
5. 詳細: @docs/AI_TOOLING.md · @.cursor/rules/devos-v4.mdc

## よく使うコマンド

```bash
# 起動
docker compose -f infra/compose/docker-compose.yml --env-file project.env up -d

# テスト（implement Phase 完了前）
docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test

# マイグレーション
docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan migrate

# React ビルド（www/resources/js 変更後は必須）
docker compose -f infra/compose/docker-compose.yml --env-file project.env exec node npm run build
```

## 禁止

- ホスト側 composer / sed / .env 手動編集 / バージョン直書き
- develop 直コミット（docs 軽微追記のみ例外）
- @docs/AI_TOOLING.md §6 参照

## Phase Skills

### ライフサイクル
- `/phase-start` — Phase 開始（PLAN 3ファイル作成）
- `/ssot-lookup` — 実装前 SSOT 参照
- `/implement-checklist` — implement 前後チェック
- `/phase-finish` — Phase 完了（REPORT・Merge Evidence）
- `/commit-phase` — コミット（明示依頼時のみ）
- `/merge-develop` — develop への PRレス merge
- `/docs-sync` — INDEX・進捗更新

### 開発・データ
- `/docker-artisan` — コンテナ内コマンド定型
- `/react-build` — React ビルド（JS 変更後必須）
- `/mock-ui-verify` — 管理画面モック比較
- `/import-religo` — 議事録・1to1・CSV → DB
- `/db-sync` — db-export/import/pull/push

一覧: @.claude/skills/README.md

## 進捗・INDEX

- 進捗: @docs/dragonfly_progress.md
- docs 変更時: @docs/INDEX.md を更新

## UI 実装時

- モック: http://localhost/mock/religo-admin-mock.html
- @docs/SSOT/MOCK_UI_VERIFICATION.md · @docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md

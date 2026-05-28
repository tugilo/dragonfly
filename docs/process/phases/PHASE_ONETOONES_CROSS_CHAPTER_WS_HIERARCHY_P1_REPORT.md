# REPORT — ONETOONES_CROSS_CHAPTER_WS_HIERARCHY_P1

| 項目 | 内容 |
|------|------|
| **Phase ID** | ONETOONES_CROSS_CHAPTER_WS_HIERARCHY_P1 |
| **種別** | implement |
| **Related SSOT** | SPEC-006、[DATA_MODEL.md](../../SSOT/DATA_MODEL.md)、[ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md](../../SSOT/ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md) |
| **ステータス** | completed（実装・ドキュメント・テスト・ビルド済み） |

## 最終結果

- **解釈 A** を SSOT・`OneToOneIndexService` の返却項目で表現。
- **countries / regions / workspaces.region_id** により **国 > リージョン > チャプター** への進化経路を確保（既存行は `region_id` null のまま可）。
- 管理画面で 1 to 1 の相手に **チャプター名**と **他チャプター** Chip を表示。メンバー API は **workspace_name / region / country** をフラット追加。

## DB 変更

| 対象 | 内容 |
|------|------|
| `countries` | 新規。`name` unique |
| `regions` | 新規。`country_id` FK、`(country_id, name)` unique |
| `workspaces` | `region_id` nullable FK → `regions` |

Migration ファイル: `www/database/migrations/2026_04_08_090000_create_countries_regions_add_region_id_to_workspaces.php`

## API 追加・変更（後方互換）

### GET `/api/one-to-ones` / `GET /api/one-to-ones/{id}`

追加キー（例）:

- `recording_workspace_name`
- `target_workspace_id`, `target_workspace_name`, `target_region_id`, `target_region_name`, `target_country_id`, `target_country_name`
- `is_cross_chapter` (boolean)

### GET `/api/dragonfly/members` / `{id}`

- `workspace_name`, `region_id`, `region_name`, `country_id`, `country_name`（既存列 `workspace_id` と併用）

### GET `/api/workspaces`

- `region_id`, `region_name`, `country_id`, `country_name` を追加

## UI

- **1 to 1 一覧:** 相手列で「名前（チャプター名）」+ 他チャプター時 Chip
- **相手 Autocomplete / フィルタ:** `formatMemberWithChapterPrimary`、検索に `workspace_name` を含める
- **相手サマリカード:** 所属チャプター・リージョン・国の行

## SSOT 更新点

- [DATA_MODEL.md](../../SSOT/DATA_MODEL.md): §4.0.1–4.0.2、workspaces、§4.12 `workspace_id` 意味、§5.1 クロスチャプター例外
- [ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md](../../SSOT/ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md): 解釈 A 確定版に刷新

## テスト結果

- `docker compose ... exec app php artisan test` — **345 passed**（実施時点）
- `docker compose ... exec node npm run build` — **成功**（実施時点）

## 未実施 / 今後

- 既存 workspace への region 一括バックフィル
- 1 to 1 一覧の「他チャプターのみ」フィルタ
- 国/リージョンの編集 UI

## Merge Evidence

（develop へ merge 後に追記する）

- merge commit id: _（merge 後に `git log -1 --format=%H develop` で取得）_
- source branch: `feature/phase-onetoones-cross-chapter-ws-hierarchy-p1`
- target branch: develop
- test command: `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test`
- test result: 345 passed
- scope check: OK
- ssot check: OK
- dod check: OK

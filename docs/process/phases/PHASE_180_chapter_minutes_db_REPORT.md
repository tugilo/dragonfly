# Phase 180 REPORT — 定例会議事録の DB 管理（Meetings に集約）

## 完了日時

2026-06-02 15:40 JST

## 実施内容

- **SPEC-014** 新規: `meeting_minutes` テーブル、file→DB 取り込み、Meetings 閲覧要件
- **migration** `create_meeting_minutes_table` + `MeetingMinute` モデル + `Meeting::meetingMinute()`
- **artisan** `dragonfly:import-chapter-minutes`（単一ファイル / ディレクトリ一括、front matter + オプション上書き）
- **API** 一覧・show に `has_minutes`、show に `minutes`、 `GET /api/meetings/{id}/minutes`
- **UI** Meetings 一覧議事録 Chip/フィルタ、Drawer タブ（概要/参加者/BO/議事録/メモ）、共有 `MarkdownView`
- **初期取り込み** 第207–210回 4 件、`make db-export`
- **インフラ** app コンテナに `docs:/var/docs:ro` マウント

## テスト結果

```text
php artisan test tests/Feature/ImportChapterMinutesCommandTest.php tests/Feature/Religo/MeetingControllerTest.php
Tests: 38 passed (196 assertions)

php artisan test
Tests: 429 passed (1623 assertions)
```

`npm run build` — 成功

## DoD チェック

| 項目 | 結果 |
|------|------|
| migration + Model + リレーション | OK |
| import コマンド + Feature テスト | OK |
| API + Meetings UI | OK |
| 4 件取り込み + db-export | OK |
| SSOT / Registry / INDEX / progress | OK（本 REPORT 時点） |

## 変更ファイル（Phase 180 主要）

- `www/database/migrations/2026_06_02_153400_create_meeting_minutes_table.php`
- `www/app/Models/MeetingMinute.php`, `Meeting.php`
- `www/app/Console/Commands/ImportChapterMinutesCommand.php`
- `www/app/Http/Controllers/Religo/MeetingController.php`
- `www/routes/api.php`
- `www/resources/js/admin/components/MarkdownView.jsx`
- `www/resources/js/admin/pages/MeetingsList.jsx`, `OneToOnesList.jsx`
- `www/resources/js/admin/dataProvider.js`
- `infra/compose/docker-compose.yml`
- `www/tests/Feature/ImportChapterMinutesCommandTest.php`
- `www/tests/Feature/Religo/MeetingControllerTest.php`
- `www/database/sync/dragonfly.sql`
- `docs/SSOT/CHAPTER_MINUTES_REQUIREMENTS.md`, `MEETING_DOMAIN_IA.md`, `DATA_MODEL.md`, 他 docs

## 取り込み証跡（develop への merge 後）

| 項目 | 内容 |
|------|------|
| merge commit id | （merge 後に記録） |
| merge 元ブランチ名 | feature/phase180-chapter-minutes-db |
| target branch | develop |
| phase id | 180 |
| phase type | implement |
| related ssot | SPEC-014 |
| test command | `php artisan test` |
| test result | 429 passed |
| scope check | OK |
| ssot check | OK |
| dod check | OK |

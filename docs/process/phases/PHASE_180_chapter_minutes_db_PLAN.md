# Phase 180 PLAN — 定例会議事録の DB 管理（Meetings に集約）

## 基本情報

| 項目 | 内容 |
|------|------|
| Phase ID | 180 |
| Name | chapter_minutes_db |
| Type | implement（SSOT 追記 + migration / API / UI） |
| 作成日時 | 2026-06-02 15:40 JST |
| Branch | feature/phase180-chapter-minutes-db（merge 前） |

## Related SSOT

- **SPEC-014** — [CHAPTER_MINUTES_REQUIREMENTS.md](../../SSOT/CHAPTER_MINUTES_REQUIREMENTS.md)
- [MEETING_DOMAIN_IA.md](../../SSOT/MEETING_DOMAIN_IA.md)
- [DATA_MODEL.md](../../SSOT/DATA_MODEL.md) §4.6a
- [FIT_AND_GAP_MEETINGS.md](../../SSOT/FIT_AND_GAP_MEETINGS.md)

## Scope

### docs
- `docs/SSOT/CHAPTER_MINUTES_REQUIREMENTS.md`（新規）
- `docs/SSOT/MEETING_DOMAIN_IA.md`（新規）
- `docs/SSOT/DATA_MODEL.md`
- `docs/02_specifications/SSOT_REGISTRY.md`
- `docs/meetings/chapter/README.md`
- `docs/SSOT/FIT_AND_GAP_MEETINGS.md`
- `docs/INDEX.md`, `docs/dragonfly_progress.md`, `docs/process/PHASE_REGISTRY.md`

### implement
- `www/database/migrations/*_create_meeting_minutes_table.php`
- `www/app/Models/MeetingMinute.php`, `Meeting.php`
- `www/app/Console/Commands/ImportChapterMinutesCommand.php`
- `www/app/Http/Controllers/Religo/MeetingController.php`
- `www/routes/api.php`
- `www/resources/js/admin/components/MarkdownView.jsx`
- `www/resources/js/admin/pages/MeetingsList.jsx`, `OneToOnesList.jsx`
- `www/resources/js/admin/dataProvider.js`
- `infra/compose/docker-compose.yml`（docs read-only マウント）
- `www/tests/Feature/ImportChapterMinutesCommandTest.php`
- `www/tests/Feature/Religo/MeetingControllerTest.php`
- `www/database/sync/dragonfly.sql`（初期取り込み後 export）

## DoD

- [ ] `meeting_minutes` migration + Model + `Meeting::meetingMinute()`
- [ ] `dragonfly:import-chapter-minutes` + Feature テスト
- [ ] API `has_minutes` / `minutes` + `GET /api/meetings/{id}/minutes`
- [ ] Meetings Drawer 議事録表示・一覧フィルタ + `npm run build`
- [ ] 既存 4 件 `chapter_weekly_*.md` 取り込み + `make db-export`
- [ ] SSOT / Registry / INDEX / progress / Phase 180 証跡

## スコープ外

- 管理画面からの議事録編集・DB→Markdown 書き出し
- `contact_memos`（例会メモ）との統合
- Connections 表示変更（本プランでは対象外）

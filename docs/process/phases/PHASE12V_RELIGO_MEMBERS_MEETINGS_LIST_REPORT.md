# PHASE12V Religo Members / Meetings List — REPORT

**Phase:** Members / Meetings List（placeholder 卒業）  
**完了日:** 2026-03-05

---

## 実施内容

- dataProvider に members.getList（GET /api/dragonfly/members?owner_member_id=&with_summary=1）/ meetings.getList（GET /api/meetings）を追加。既存 API のみ使用。
- MembersList.jsx / MeetingsList.jsx を新規作成。Datagrid で番号・名前・同室回数・直近メモ / 回・開催日・名前を表示。TopToolbar に「Board へ戻る」を追加。
- app.jsx で MembersPlaceholder / MeetingsPlaceholder を MembersList / MeetingsList に差し替え。

## 変更ファイル一覧

- www/resources/js/admin/dataProvider.js
- www/resources/js/admin/pages/MembersList.jsx（新規）
- www/resources/js/admin/pages/MeetingsList.jsx（新規）
- www/resources/js/admin/app.jsx
- docs/process/phases/PHASE12V_RELIGO_MEMBERS_MEETINGS_LIST_PLAN.md, WORKLOG.md, REPORT.md
- docs/INDEX.md, docs/dragonfly_progress.md

## テスト結果

- `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test` — **27 passed (125 assertions)**

## DoD

- [x] Members / Meetings メニューから実データ一覧が表示される
- [x] 既存テスト green
- [x] docs 更新

## 取り込み証跡（develop への merge 後に追記）

| 項目 | 内容 |
|------|------|
| **merge commit id** | （merge 後に記入） |
| **merge 元ブランチ名** | feature/phase12v-members-meetings-list-v1 |
| **変更ファイル一覧** | （merge 後に記入） |
| **テスト結果** | 27 passed (125 assertions) |

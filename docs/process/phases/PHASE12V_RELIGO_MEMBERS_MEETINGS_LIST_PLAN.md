# PHASE12V Religo Members / Meetings List — PLAN

**Phase:** ReactAdmin の List として Members・Meetings を実データ表示にする（placeholder 卒業）  
**作成日:** 2026-03-05  
**SSOT:** [ROADMAP.md](../../SSOT/ROADMAP.md), 既存 API のみ

---

## 1. 目的（ROADMAP 準拠）

- ReactAdmin の List として「Members」「Meetings」を実データ表示にする。新 API 追加は行わない。

## 2. 実装方針

### (A) dataProvider

- members.getList: GET /api/dragonfly/members?owner_member_id=1&with_summary=1 を使用。filter に owner_member_id があれば採用。
- meetings.getList: GET /api/meetings を使用。
- ソート/フィルタは API が未対応なら UI は最小（一覧表示のみでも可）。

### (B) List UI

- MembersList: Datagrid で number（display_no）/ name / 同室回数（summary_lite）/ last_memo 等を表示。
- MeetingsList: number / held_on を表示。
- 各 List の TopToolbar に「Board へ戻る」ボタンを配置。

## 3. DoD

- [ ] Members / Meetings メニューから実データ一覧が表示される
- [ ] 既存テスト green（php artisan test）
- [ ] docs 更新（PLAN/WORKLOG/REPORT, INDEX, progress）

## 4. Git

- ブランチ: `feature/phase12v-members-meetings-list-v1`
- コミット: 1 コミット。メッセージ: `ui: Phase12V Members/Meetings List (placeholder 卒業)`

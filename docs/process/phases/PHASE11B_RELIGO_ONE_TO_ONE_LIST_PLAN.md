# PHASE11B Religo 1 to 1 独立一覧 — PLAN

**Phase:** Meeting と独立した 1 to 1 ログの一覧・登録（API index + ReactAdmin List/Create）  
**作成日:** 2026-03-04  
**SSOT:** docs/SSOT/DATA_MODEL.md §4.9、Phase05/07/08（POST /api/one-to-ones）

---

## 1. 狙い

- 1 to 1 を **Meeting と独立した** 関係づくりログとして一覧・登録できるようにする。
- Board に依存せず「関係づくり」を運用可能にする。
- meeting_id は任意（nullable）のまま維持する。

## 2. API 追加

### GET /api/one-to-ones

- **クエリ（任意）:** workspace_id, owner_member_id, target_member_id, status（planned/completed/canceled）, from, to（scheduled_at/started_at の範囲）
- **返却:** 最新順（COALESCE(started_at, scheduled_at) desc, id desc）
- **各行:** id, workspace_id, owner_member_id, target_member_id, status, scheduled_at, started_at, ended_at, notes, meeting_id, created_at, updated_at。可能なら owner/target の名前（members 参照）を含める。
- **バリデーション:** 整数・存在チェックは既存 POST と整合。

### POST /api/one-to-ones

- 既存のまま（Phase05/07/08）流用。

## 3. 実装構成

- Controller: index 追加。Store は既存。
- Request: IndexOneToOnesRequest（GET クエリ用）。
- Query または Service: index 用の取得・ソート・フィルタ。
- テスト: OneToOneIndexTest（GET 200、並び順、status フィルタ等）。

## 4. ReactAdmin Resource（/one-to-ones）

- **List:** フィルタ（owner_member_id, status, 期間 from/to）。列: 予定/実施日、相手（target）、status、notes 短縮、meeting_id（あれば）。
- **Create:** workspace_id 自動（GET /api/workspaces 先頭）、owner_member_id / target_member_id は Autocomplete、status、日時、meeting_id 任意、notes。成功時 List へ戻る or notify。
- Phase11A で追加した one-to-ones プレースホルダーを実 List/Create に差し替え。

## 5. DoD

- [ ] GET /api/one-to-ones が動作
- [ ] Resource /one-to-ones から一覧・作成ができる
- [ ] meeting_id は任意（空でも登録可能）
- [ ] docs 更新（PLAN/WORKLOG/REPORT + INDEX/progress）
- [ ] Feature test green
- [ ] 1 コミット push → develop へ --no-ff merge → push

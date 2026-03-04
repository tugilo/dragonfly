# PHASE04 Religo Members一覧に summary 統合 — PLAN

**Phase:** Members一覧に relationship summary（summary-lite）を統合  
**作成日:** 2026-03-04  
**SSOT:** [docs/SSOT/DATA_MODEL.md](../../SSOT/DATA_MODEL.md), [docs/SSOT/DERIVED_METRICS_SSOT.md](../../SSOT/DERIVED_METRICS_SSOT.md)（存在する場合）

---

## 1. 対象画面・コンポーネント

- **既存:** React Admin の DragonFlyBoard（`www/resources/js/admin/pages/DragonFlyBoard.jsx`）。メンバーは `/api/dragonfly/members` で取得し、Autocomplete で選択。選択時に `/api/dragonfly/contacts/{id}/summary` でサマリー取得。
- **統合先:** 上記「一覧」部分。メンバー選択のドロップダウンまたは一覧で、**クリック前から** summary-lite が見えるようにする。

## 2. 表示する情報

| 種別 | 項目 |
|------|------|
| **必須** | last_contact_at, same_room_count, last_memo（本文は短縮 50〜80 文字）, one_to_one_count |
| **任意** | flags（interested / want_1on1）— アイコン/バッジで軽く |

## 3. API 呼び出し方式（N+1 禁止）

**採用:** **A案 — 一覧 API に summary-lite を同梱**

- **理由:** 1 回の取得で完結し、実装が単純。N+1 を避けるため、owner 固定で全 target（メンバー ID 一覧）に対する summary-lite をバッチ取得し、レスポンスに埋め込む。
- **エンドポイント:** 既存 `GET /api/dragonfly/members` を拡張。
  - **Query params:** `owner_member_id`（summary 付与時は必須）, `workspace_id`（任意）, `with_summary`（任意、1 または true で summary-lite 付与）。
- **レスポンス:** `with_summary` かつ `owner_member_id` ありの場合、各要素に `summary_lite` を付与。
  - `summary_lite`: `{ same_room_count, one_to_one_count, last_contact_at, last_memo: { id, memo_type, created_at, body_short } | null, flags?: { interested, want_1on1 } }`

## 4. 実装方針

- **バックエンド:** MemberSummaryQuery（または同等）で「owner + 複数 target」の summary-lite を一括取得するメソッドを用意。DragonFlyMemberController の index で `with_summary` かつ `owner_member_id` のときのみそれを呼び、members にマージして返す。
- **フロント:** `/api/dragonfly/members?owner_member_id={owner}&with_summary=1` で取得。各 member の `summary_lite` を Autocomplete の option の secondary 表示や、一覧行に表示。last_contact_at が null の場合は「未接触」表示。last_memo は 1 行省略（50〜80 文字）。

## 5. テスト・確認

- **API:** `owner_member_id` + `with_summary=1` のときレスポンスに `summary_lite` が含まれること、`with_summary` なしのときは従来どおり `summary_lite` なしであることをテスト。
- **UI:** 一覧表示が崩れないこと、summary_lite が表示されることを手動確認。WORKLOG に「OK/NG」を残す。

## 6. DoD

- [ ] 一覧 API が summary-lite を同梱する（A案）
- [ ] N+1 にならない（バッチ取得）
- [ ] UI で summary-lite が表示される
- [ ] PLAN / WORKLOG / REPORT 作成済み
- [ ] 1 コミットで push

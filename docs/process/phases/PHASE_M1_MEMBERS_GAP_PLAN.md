# Phase M-1 Members Gap — PLAN（Docs）

**Phase:** M-1（tugilo式 Members Gap 解消 Runner）  
**作成日:** 2026-03-06  
**SSOT:** [MEMBERS_REQUIREMENTS.md](../../../SSOT/MEMBERS_REQUIREMENTS.md)、[FIT_AND_GAP_MOCK_VS_UI.md](../../../SSOT/FIT_AND_GAP_MOCK_VS_UI.md) §4、[MEMBERS_MOCK_VS_UI_SUMMARY.md](../../../SSOT/MEMBERS_MOCK_VS_UI_SUMMARY.md)

---

## 1. 目的

- Members 画面の要件 SSOT に対して不足している**必須項目**をまず満たすための Phase 設計を行う。
- その後、検索/フィルタ/ソート（M-3）、統計カード（M-4）を段階的に足す前提を docs で固定する。
- 用語は「Connections」に統一（会の地図は使用しない）。
- 新しいフレームワーク・apiClient/axios は作らない（fetch + Accept: application/json を踏襲）。
- 二重 fetch は禁止（既存の取得に統合・再利用）。

---

## 2. スコープ（M-2 / M-3 / M-4）

| Phase | スコープ | 内容 |
|-------|----------|------|
| **M-2** | UI 最小 | サブタイトル追加、**one_to_one_count 一覧表示**（必須）、interested / want_1on1 表示（任意・簡易）。既存 API の summary_lite を参照。 |
| **M-3** | 検索/フィルタ/ソート | 現状 API のクエリ対応を棚卸しし、可能なら UI のみで検索・フィルタ・ソートを追加。必要なら既存 members endpoint の query 拡張（新 API は作らない）。 |
| **M-4** | 任意（余力） | 統計カード 4 種。可能ならクライアント集計。データ量次第で既存 stats パターン流用。M-2/M-3 で要件充足を優先。 |

---

## 3. 既存の正（守るもの）

- **fetch + Accept: application/json** を踏襲。axios 等は導入しない。
- 既存 dataProvider・既存 API パターンを踏襲。
- **二重 fetch 禁止**（既存の取得に統合・再利用）。
- 1 Phase = 1 commit = 1 push。merge は --no-ff。merge 後 test / build 必須。

---

## 4. 要件 SSOT 抜粋（一覧の必須/任意）

[MEMBERS_REQUIREMENTS.md](../../../SSOT/MEMBERS_REQUIREMENTS.md) §3.1 より。

| 列（論理名） | 必須/任意 | データソース |
|--------------|-----------|--------------|
| display_no | 必須 | members.display_no |
| name | 必須 | members.name |
| category（大/実） | 必須 | categories（members.category_id 経由） |
| current_role | 必須 | member_roles + roles（term_end null 最新） |
| same_room_count | 必須 | summary_lite |
| last_memo | 必須 | summary_lite.last_memo（80 文字まで） |
| **one_to_one_count** | **必須** | summary_lite（status = completed） |
| last_contact_at | 必須 | summary_lite |
| interested / want_1on1 | 任意 | dragonfly_contact_flags（summary_lite） |
| name_kana | 任意 | members.name_kana |

---

## 5. DoD（M-2 時点で必須）

- **M-2 完了時点で、一覧に one_to_one_count（1to1回数）が表示されていること。**
- 値が無い場合は "—" 表示。
- 既存 API（GET /api/dragonfly/members?owner_member_id=&with_summary=1）の summary_lite.one_to_one_count を参照する（API は既に返却済み）。

---

## 6. 成果物（M-1）

- **docs/process/phases/PHASE_M1_MEMBERS_GAP_PLAN.md**（本ファイル）
- **docs/process/phases/PHASE_M1_MEMBERS_GAP_WORKLOG.md**
- **docs/process/phases/PHASE_M1_MEMBERS_GAP_REPORT.md**
- **docs/INDEX.md** に M-1 の 3 点セットを追加

---

## 7. Git（M-1）

- ブランチ: `feature/m1-members-gap-docs`
- docs のみ commit / push → develop へ --no-ff merge → test / build → push
- 取り込み後、REPORT に取り込み証跡を追記

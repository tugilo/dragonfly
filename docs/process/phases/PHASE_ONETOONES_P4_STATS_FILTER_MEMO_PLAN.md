# PLAN: ONETOONES-P4（統計フィルタ連動＋1to1 メモ本流・contact_memos）

| 項目 | 内容 |
|------|------|
| Phase ID | **ONETOONES-P4** |
| 種別 | implement |
| Related SSOT | `docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md` §6、`docs/SSOT/DATA_MODEL.md` §4.11–4.12、ONETOONES-P1〜P3 |
| 前提 | P3 まで完了（Owner 既定・クイック作成・notes 要約の位置づけ） |
| ブランチ（想定） | `feature/phase-onetoones-p4-stats-memo` |

## 1. 背景

- 統計 API は Owner 中心で、一覧の `q` / `status` / `target` / `from` / `to` と **ズレ** があった。
- メモは `notes`（要約）に留まり、`contact_memos` による **履歴本流** が未配線（`one_to_one_id` カラムは既存 migration で存在）。

## 2. 対象範囲

1. **統計と一覧フィルタ連動:** `GET /api/one-to-ones/stats` が `GET /api/one-to-ones` と **同一の WHERE**（`OneToOneIndexService::applyIndexFilters`）を利用。
2. **メモ本流（最小）:** `GET/POST /api/one-to-ones/{id}/memos` で `memo_type=one_to_one` の `contact_memos` を紐付け。編集画面に一覧＋追加 UI。
3. **`/api/users/me`:** `id`・`member_id`（`owner_member_id` と同値）を返却し、フロント準備を明文化（認証は未対応のまま）。

## 3. 対象外

- UI 全面刷新、モック完全一致、スレッド・返信、権限本格設計。新規 DB カラムは不要（`one_to_one_id` 済み）。

## 4. 統計の意味（P4）

- 各カードは **一覧と同じ filter 集合** に加え、従来どおりの status / 当月条件を適用。
- **want_1on1_on_count:** 一覧 filter に合致する `one_to_ones` の **distinct target_member_id** のうち、`dragonfly_contact_flags` で `want_1on1=true` の件数。

## 5. テスト

- `OneToOneStatsTest` に q・target 連動、`OneToOneMemosApiTest` 新規、`UserMeApiTest` 更新、全件 `php artisan test`、`npm run build`。

## 6. DoD

- stats が index と同じ filter で一致する。
- Edit で履歴メモの閲覧・追加ができる。
- `notes` は要約のまま。
- PLAN/WORKLOG/REPORT・REGISTRY・INDEX・progress・FIT_AND_GAP・DATA_MODEL 追記済み。

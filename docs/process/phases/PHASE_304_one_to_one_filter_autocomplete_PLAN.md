# Phase 304 — 1to1 一覧フィルター: カテゴリ・チャプターをワード検索（Autocomplete）に

**Phase ID:** 304  
**Type:** implement  
**Status:** completed  
**Branch:** `feature/phase304-one-to-one-filter-autocomplete`  
**作成:** 2026-09-02 10:29 JST

## Purpose

Phase 303 で追加した 1to1 一覧フィルターバーの「相手チャプター」「大カテゴリ」「カテゴリ」が Select（ドロップダウン）だったため、チャプター 30 件・カテゴリ 400 件超からの選択が不便。要望（2026-09-02 10:29）「カテゴリ、チャプターはワード検索で」に従い、文字入力で候補を絞れる Autocomplete に置き換える。

## Related SSOT

- SPEC-006 [ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md](../../SSOT/ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md) §5.3（1to1 一覧フィルターバー）
- Phase 303 [PLAN](PHASE_303_one_to_one_list_filters_PLAN.md)（API パラメータは不変）

## Scope

- `www/resources/js/admin/pages/OneToOnesList.jsx` のみ（`OneToOnesFilterBar`）
- API・dataProvider・テストは変更なし（送信パラメータ `target_workspace_id` / `target_group_name` / `target_category_id` はそのまま）
- Docs: Phase 304 3 ファイル、SPEC-006 §5.3、PHASE_REGISTRY、INDEX、progress

## 設計

- **相手チャプター:** MUI `Autocomplete`（チャプター名で部分一致）
- **カテゴリ:** 「大カテゴリ」「カテゴリ」の 2 つの Select を **1 つの Autocomplete** に統合。大カテゴリ名・カテゴリ名のどちらでも部分一致。候補は大カテゴリごとにグループ表示し、**カテゴリが 2 件以上ある大カテゴリにだけ「◯◯（大カテゴリすべて）」** を先頭に出す（選択 → `target_group_name`）。個別カテゴリ選択 → `target_category_id`（相互排他）。1 件だけの大カテゴリ（多くは名称がカテゴリと同一）は「その他」にまとめる。
- Autocomplete に渡す `getOptionLabel` 等はモジュールレベルの固定関数にする（毎レンダーで identity が変わると MUI 内部の `resetInputValue` が再実行され入力途中の文字が消えることがある）。

## DoD

- [x] 相手チャプター・カテゴリが文字入力で候補を絞れ、選択で一覧・統計・Chip・URL が連動する
- [x] 大カテゴリ単位（`target_group_name`）と個別カテゴリ（`target_category_id`）の両方を 1 欄から選べる
- [x] `npm run build` 成功、`php artisan test` 全通過（615 passed・API 変更なし）
- [x] SPEC-006 §5.3・INDEX・progress・PHASE_REGISTRY 更新

## モック比較

モック比較: [docs/SSOT/MOCK_UI_VERIFICATION.md](../../SSOT/MOCK_UI_VERIFICATION.md) に従う。1to1 一覧はモックに該当画面なし（Phase 303 と同様）。

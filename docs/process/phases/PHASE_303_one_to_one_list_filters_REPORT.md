# Phase 303 REPORT — 1to1 一覧フィルターバー

**Phase ID:** 303  
**Type:** implement  
**Status:** completed  
**完了:** 2026-09-02 10:10 JST

## Summary

1to1 一覧に **常時表示のフィルターバー** を追加した。

- **原因解消:** 従来は `filters={[<OneToOnesListFilters/>]}`（配列内 `<Filter>`）＋ `FilterButton` 無しのカスタム actions のため、定義済みフィルターが**一切描画されていなかった**。react-admin 標準 `Filter` を撤去し、Members 一覧と同系の `OneToOnesFilterBar`（`useListContext().setFilters`）に置換。
- **フィルター項目:** 検索（相手名・かな・メモ）／すべて・自チャプター・他チャプター トグル／相手チャプター（`GET /api/workspaces`）／大カテゴリ／カテゴリ（大カテゴリで絞込）／状態／期間 from・to／キャンセルを除く。適用中フィルターを Chip 表示・個別解除・「フィルターをクリア」（既定 `exclude_canceled: true` に戻す）。
- **API:** `GET /api/one-to-ones` / `GET /api/one-to-ones/stats` に `target_workspace_id` / `target_group_name` / `target_category_id` / `cross_chapter`（`is_cross_chapter` と同定義）を追加。`applyIndexFilters` に集約し index と stats が同一 WHERE（ONETOONES-P4 維持）。`q` は相手 `name_kana` も対象に。
- 一覧・統計カード・件数・URL（`filter=` JSON）が連動。

## Related SSOT

- SPEC-006 [ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md](../../SSOT/ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md) — R2 を実装済みへ、§5.3 にフィルターバー追記
- SPEC-021 [FIT_AND_GAP_REGION_CHAPTER_MASTER_CROSS_CHAPTER_1TO1.md](../../SSOT/FIT_AND_GAP_REGION_CHAPTER_MASTER_CROSS_CHAPTER_1TO1.md) — G12 Fit

## Test

- command: `php artisan test`（app コンテナ）
- result: **615 passed (2253 assertions)**
- 追加テスト: `tests/Feature/Religo/OneToOneIndexTargetFiltersTest.php` 10 件（target_workspace_id／target_group_name・target_category_id／cross_chapter=1・0／`is_cross_chapter` との整合／q かな／複合／stats 同一 filter／422）
- React build: `npm run build` 成功（node コンテナ）
- UI 確認: `#/one-to-ones` でフィルターバー表示 → 他チャプター トグルで 129→32 件・予定中 10→2 → 相手チャプター DIANA で 3 件、Chip「他チャプター」「チャプター: DIANA」表示、URL 同期

## モック比較

1to1 一覧はモックに該当画面なし（Phase 272 / 302 と同様）。差分は SPEC-021 Fit&Gap G12 に記録。

## Changed files

```
docs/INDEX.md
docs/SSOT/FIT_AND_GAP_REGION_CHAPTER_MASTER_CROSS_CHAPTER_1TO1.md
docs/SSOT/ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md
docs/dragonfly_progress.md
docs/process/PHASE_REGISTRY.md
docs/process/phases/PHASE_303_one_to_one_list_filters_PLAN.md
docs/process/phases/PHASE_303_one_to_one_list_filters_REPORT.md
docs/process/phases/PHASE_303_one_to_one_list_filters_WORKLOG.md
www/app/Http/Requests/Religo/IndexOneToOnesRequest.php
www/app/Http/Requests/Religo/OneToOneStatsRequest.php
www/app/Services/Religo/OneToOneIndexService.php
www/resources/js/admin/dataProvider.js
www/resources/js/admin/pages/OneToOnesList.jsx
www/tests/Feature/Religo/OneToOneIndexTargetFiltersTest.php
```

## Merge Evidence

merge commit id: （merge 後に記載）  
source branch: feature/phase303-one-to-one-list-filters  
target branch: develop  
phase id: 303  
phase type: implement  
related ssot: SPEC-006 R2 / SPEC-021 G12  
test command: php artisan test  
test result: 615 passed  
scope check: OK（API / UI / Tests / Docs のみ。package.json / composer.json 変更なし）  
ssot check: UPDATED（SPEC-006 R2・§5.3・§6、Fit&Gap G12）  
dod check: OK

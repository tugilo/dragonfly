# Phase 304 REPORT — 1to1 一覧フィルター: カテゴリ・チャプターをワード検索に

**Phase ID:** 304  
**Type:** implement  
**Status:** completed  
**完了:** 2026-09-02 10:40 JST

## Summary

Phase 303 のフィルターバーで Select だった「相手チャプター」「大カテゴリ」「カテゴリ」を、文字入力で候補を絞れる MUI `Autocomplete` に置き換えた。

- **相手チャプター:** チャプター名で部分一致検索
- **カテゴリ:** 大カテゴリ・カテゴリの 2 欄を 1 欄に統合。大カテゴリ名／カテゴリ名のどちらでも検索でき、候補は大カテゴリごとにグループ表示。カテゴリ 2 件以上の大カテゴリには「◯◯（大カテゴリすべて）」を先頭に出し、選択で `target_group_name`、個別カテゴリ選択で `target_category_id`（相互排他）。1 件だけの大カテゴリは「その他」に集約。
- Autocomplete のコールバックをモジュールレベルの固定関数にし、再レンダーで入力途中の文字が消える MUI の挙動を回避。
- API・dataProvider・テストは変更なし。

## Related SSOT

- SPEC-006 [ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md](../../SSOT/ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md) §5.3 更新

## Test

- command: `php artisan test`（app コンテナ）
- result: **615 passed (2253 assertions)**（PHP 変更なし）
- React build: `npm run build` 成功
- UI 確認: 「税理」→ 6 候補、「士業・コンサル（大カテゴリすべて）」選択 → `target_group_name` で 4 件、個別「税理士」選択 → `target_category_id=48`、Chip・URL 同期

## Changed files

```
docs/INDEX.md
docs/SSOT/ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md
docs/dragonfly_progress.md
docs/process/PHASE_REGISTRY.md
docs/process/phases/PHASE_304_one_to_one_filter_autocomplete_PLAN.md
docs/process/phases/PHASE_304_one_to_one_filter_autocomplete_REPORT.md
docs/process/phases/PHASE_304_one_to_one_filter_autocomplete_WORKLOG.md
www/resources/js/admin/pages/OneToOnesList.jsx
```

## Merge Evidence

merge commit id: 4bfa055dbb79975034580aba109f52a95d9c87df  
source branch: feature/phase304-one-to-one-filter-autocomplete  
target branch: develop  
phase id: 304  
phase type: implement  
related ssot: SPEC-006 §5.3  
test command: php artisan test  
test result: 615 passed  
scope check: OK（`OneToOnesList.jsx` と docs のみ）  
ssot check: UPDATED（SPEC-006 §5.3）  
dod check: OK

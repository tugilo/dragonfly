# Phase M4G Members 大カテゴリ単独フィルタ追加 — REPORT

**Phase:** M4G  
**完了日:** 2026-03-10  
**参照:** [PHASE_M4G_MEMBERS_GROUP_FILTER_PLAN.md](PHASE_M4G_MEMBERS_GROUP_FILTER_PLAN.md)、[PHASE_M4G_MEMBERS_GROUP_FILTER_WORKLOG.md](PHASE_M4G_MEMBERS_GROUP_FILTER_WORKLOG.md)

---

## Summary

Members の FilterBar に「大カテゴリ」単独フィルタを追加した。既存 API・dataProvider は group_name 対応済みのため、MembersList.jsx の FilterBar に大カテゴリ用 Select を追加し、候補は既存の useGetList('categories') から group_name を重複排除・ソートして生成。モックの並び「検索・大カテゴリ・カテゴリ・ロール」に合わせて配置。FIT_AND_GAP M5「大カテゴリ単独は未」を解消。

---

## Changed Files

- www/resources/js/admin/pages/MembersList.jsx（FilterBar に groupNames 算出と「大カテゴリ」Select を追加）
- docs/process/phases/PHASE_M4G_MEMBERS_GROUP_FILTER_PLAN.md（新規）
- docs/process/phases/PHASE_M4G_MEMBERS_GROUP_FILTER_WORKLOG.md（新規）
- docs/process/phases/PHASE_M4G_MEMBERS_GROUP_FILTER_REPORT.md（本ファイル）

---

## DoD Check

| 項目 | 結果 |
|------|------|
| FilterBar に大カテゴリ Select 追加・絞り込み動作 | OK |
| 大カテゴリ候補を既存 categories の group_name から生成 | OK |
| API / dataProvider 変更なし | OK |
| List / Card 両方で同じ絞り込み | OK（同一 List コンテキストの data を参照） |
| 既存フィルタ・並び順・件数が壊れていない | OK（変更は groupNames と大カテゴリ Select のみ） |
| test / build 成功 | OK（php artisan test: 79 passed / npm run build: 成功） |

---

## Scope Check

OK — 変更は www/resources/js/admin/pages/MembersList.jsx の FilterBar のみ。API・dataProvider・他ページは未変更。

---

## SSOT Check

OK — FIT_AND_GAP_MOCK_VS_UI.md §4.1, §4.2 M5 に準拠。SSOT の更新は不要。

---

## Merge Evidence

（develop へ merge 後に記入）

- merge commit id:
- source branch: feature/m4g-members-group-filter
- target branch: develop
- phase id: M4G
- phase type: implement
- related ssot: FIT_AND_GAP_MOCK_VS_UI.md §4.1, §4.2 M5
- test command: `php artisan test` / `npm run build`
- test result: 79 tests passed; npm run build 成功
- changed files: www/resources/js/admin/pages/MembersList.jsx, docs/process/phases/PHASE_M4G_*
- scope check: OK
- ssot check: OK
- dod check: OK

---

## 実装判断（大カテゴリ候補の生成）

既存の `useGetList('categories', …)` で取得した categories から、`group_name` を重複排除しソートして候補を生成した（`groupNames = [...new Set(categories.map(c => c?.group_name).filter(Boolean))].sort()`）。新規 API ・バックエンド変更は行っていない。dataProvider の getList('members') は既に `params.filter.group_name` をクエリに載せているため、FilterBar で setFilters に group_name を渡すだけでサーバー側で絞り込まれる。

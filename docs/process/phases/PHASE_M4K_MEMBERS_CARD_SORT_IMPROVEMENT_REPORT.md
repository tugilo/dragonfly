# Phase M4K Members Card向け並び順の強化 — REPORT

**Phase:** M4K  
**完了日:** 2026-03-10  
**参照:** [PHASE_M4K_MEMBERS_CARD_SORT_IMPROVEMENT_PLAN.md](PHASE_M4K_MEMBERS_CARD_SORT_IMPROVEMENT_PLAN.md)、[PHASE_M4K_MEMBERS_CARD_SORT_IMPROVEMENT_WORKLOG.md](PHASE_M4K_MEMBERS_CARD_SORT_IMPROVEMENT_WORKLOG.md)

---

## Summary

Members の並び順を強化した。FilterBar の並び順 Select に「最終接触が古い順（要フォロー）」「関係温度が高い順」「Interested 優先」「Want 1on1 優先」の 4 種を追加。API の SORT_FIELDS は id / display_no / name のみのため、これら 4 種は Card 表示時のみフロントで data をソート。displaySortKey を ViewModeContext で保持し、Card 専用キー選択時は API には display_no asc を渡し、MembersCardGrid 内で useMemo により summary_lite 等でソートして表示。List 表示では Datagrid は API 返却順のまま。既存フィルタ・件数・番号・名前の昇降順は維持。

---

## Changed Files

- www/resources/js/admin/pages/MembersList.jsx（ViewModeContext に displaySortKey 追加、FilterBar に並び順 4 種追加、MembersCardGrid でフロントソート）
- docs/process/phases/PHASE_M4K_MEMBERS_CARD_SORT_IMPROVEMENT_PLAN.md（新規）
- docs/process/phases/PHASE_M4K_MEMBERS_CARD_SORT_IMPROVEMENT_WORKLOG.md（新規）
- docs/process/phases/PHASE_M4K_MEMBERS_CARD_SORT_IMPROVEMENT_REPORT.md（本ファイル）

---

## DoD Check

| 項目 | 結果 |
|------|------|
| 並び順に Card 向け 4 種追加・選択可能 | OK |
| Card 表示でその順に表示される | OK |
| List 表示で Datagrid 壊さない | OK |
| 番号・名前の昇降順は API で従来どおり | OK |
| 既存フィルタと併用で破綻しない | OK |
| MembersList.jsx 以外・API 変更なし | OK |
| test / build 成功 | OK（79 passed / build 成功） |

---

## Scope Check

OK — 変更は www/resources/js/admin/pages/MembersList.jsx のみ。API・dataProvider は未変更。

---

## SSOT Check

OK — FIT_AND_GAP §4.1, §4.2 に沿った並び順拡張。SSOT の更新は不要。

---

## Merge Evidence

（develop へ merge 後に記入）

- merge commit id:
- source branch: feature/m4k-members-card-sort-improvement
- target branch: develop
- phase id: M4K
- phase type: implement
- related ssot: FIT_AND_GAP §4.1, §4.2
- test command: `php artisan test` / `npm run build`
- test result: 79 tests passed; npm run build 成功
- changed files: www/resources/js/admin/pages/MembersList.jsx, docs/process/phases/PHASE_M4K_*
- scope check: OK
- ssot check: OK
- dod check: OK

---

## 実装判断（追加した並び順 / フロントソート / Card と List の扱い）

- **追加した並び順:** (1) 番号昇順・番号降順・名前昇順・名前降順（既存・API 対応）、(2) 最終接触が古い順（要フォロー）、(3) 関係温度が高い順、(4) Interested 優先、(5) Want 1on1 優先。（(2)〜(5) は Card 向け・フロントソート。）
- **フロントソート採用:** Card 専用 4 種は API を変えず、MembersCardGrid 内で useMemo により data をコピーしてソート。last_contact_at 昇順（null は末尾）、relationshipScoreFromSummaryLite 降順、interested / want_1on1 を true 優先。同順は display_no で安定化。
- **Card と List の違い:** Card 表示時は displaySortKey に応じて上記フロントソートを適用。List 表示時は Datagrid が List コンテキストの data をそのまま使用するため、displaySortKey が Card 専用でも API は display_no asc で取得した順（番号順）で表示。並び順 Select の value は displaySortKey で統一し、Card 専用を選んだときは setSort(display_no, ASC) で API 取得のみ行い、表示順は Card 側で補正する。

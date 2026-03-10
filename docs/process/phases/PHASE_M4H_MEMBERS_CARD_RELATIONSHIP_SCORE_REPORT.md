# Phase M4H Members Card Relationship Score 表示 — REPORT

**Phase:** M4H  
**完了日:** 2026-03-10  
**参照:** [PHASE_M4H_MEMBERS_CARD_RELATIONSHIP_SCORE_PLAN.md](PHASE_M4H_MEMBERS_CARD_RELATIONSHIP_SCORE_PLAN.md)、[PHASE_M4H_MEMBERS_CARD_RELATIONSHIP_SCORE_WORKLOG.md](PHASE_M4H_MEMBERS_CARD_RELATIONSHIP_SCORE_WORKLOG.md)

---

## Summary

Members の Card 表示に Relationship Score（関係温度）を追加した。RELATIONSHIP_SCORE_SSOT に準拠し、summary_lite の same_room_count（≥10 +2, ≥5 +1）、last_memo の有無（+1）、interested（+1）、want_1on1（+1）から 0〜5 を算出し、★★★★★〜☆☆☆☆☆ で表示。MemberCard の mc-body 内で mc-rel 直後に「関係温度」ブロックを追加。List（Datagrid）は変更せず、API 変更なし。

---

## Changed Files

- www/resources/js/admin/pages/MembersList.jsx（relationshipScoreFromSummaryLite / RELATIONSHIP_SCORE_STARS 追加、MemberCard に mc-score ブロック追加）
- docs/process/phases/PHASE_M4H_MEMBERS_CARD_RELATIONSHIP_SCORE_PLAN.md（新規）
- docs/process/phases/PHASE_M4H_MEMBERS_CARD_RELATIONSHIP_SCORE_WORKLOG.md（新規）
- docs/process/phases/PHASE_M4H_MEMBERS_CARD_RELATIONSHIP_SCORE_REPORT.md（本ファイル）

---

## DoD Check

| 項目 | 結果 |
|------|------|
| Card にのみ Relationship Score 表示 | OK |
| 算出は RELATIONSHIP_SCORE_SSOT 準拠 | OK |
| List（Datagrid）には追加しない | OK |
| MembersList.jsx 以外変更なし / API 変更なし | OK |
| データ不足時フォールバック（0 → ☆☆☆☆☆） | OK |
| test / build 成功 | OK（php artisan test: 79 passed / npm run build: 成功） |

---

## Scope Check

OK — 変更は www/resources/js/admin/pages/MembersList.jsx の Card 表示（MemberCard）のみ。API・Datagrid・他ファイルは未変更。

---

## SSOT Check

OK — RELATIONSHIP_SCORE_SSOT の計算・表示ルールに準拠。FIT_AND_GAP §4.1 の .mcard に「関係温度」を追加する拡張であり、SSOT 更新は不要。

---

## Merge Evidence

（develop へ merge 後に記入）

- merge commit id:
- source branch: feature/m4h-members-card-relationship-score
- target branch: develop
- phase id: M4H
- phase type: implement
- related ssot: FIT_AND_GAP §4.1, §4.2 / RELATIONSHIP_SCORE_SSOT
- test command: `php artisan test` / `npm run build`
- test result: 79 tests passed; npm run build 成功
- changed files: www/resources/js/admin/pages/MembersList.jsx, docs/process/phases/PHASE_M4H_*
- scope check: OK
- ssot check: OK
- dod check: OK

---

## 実装判断（Relationship Score 算出ルール）

RELATIONSHIP_SCORE_SSOT に従い、summary_lite のみで 0〜5 を算出した。same_room_count ≥ 10 で +2、≥ 5 で +1。API の summary_lite には latest_memos が含まれないため、「直近メモあり」は last_memo が存在し body_short または body がある場合に +1 とした。interested / want_1on1 が true のときそれぞれ +1。合計を Math.min(5, Math.max(0, s)) でクリップ。表示は RELATIONSHIP_SCORE_STARS[score] で ☆☆☆☆☆〜★★★★★。データ不足（summary_lite 無し）の場合は 0 として ☆☆☆☆☆ を表示。

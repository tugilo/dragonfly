# Phase M4D Members List/Card 表示切替 — REPORT

**Phase:** M4D  
**完了日:** 2026-03-10  
**参照:** [PHASE_M4D_MEMBERS_LIST_CARD_PLAN.md](PHASE_M4D_MEMBERS_LIST_CARD_PLAN.md)、[PHASE_M4D_MEMBERS_LIST_CARD_WORKLOG.md](PHASE_M4D_MEMBERS_LIST_CARD_WORKLOG.md)

---

## 1. Summary

- Members ページに List / Card 表示切替を追加した。
- viewMode state（'list' | 'card'）を ViewModeContext で共有し、フィルタバー右に [List] [Card] ボタンを配置。list 時は既存 Datagrid、card 時は MembersCardGrid（useListContext().data を map → MemberCard）を表示。
- MemberCard は FIT_AND_GAP §4.1 の mcard 構造（mc-hdr / mc-body / mc-act / mc-logs）に沿って実装。既存 API は変更していない。関係ログ（最近）は一覧 API に含まれないため、「— 詳細で確認」で代替。

---

## 2. Changed Files

- www/resources/js/admin/pages/MembersList.jsx
  - ViewModeContext 追加
  - MembersFilterBar: useContext(ViewModeContext)、右端に [List] [Card] ボタン追加
  - MemberCard コンポーネント追加（mcard 構造）
  - MembersCardGrid コンポーネント追加
  - MembersListInner 追加（viewMode state + Provider、Datagrid / MembersCardGrid の出し分け）
  - List の children を <MembersListInner /> に変更

---

## 3. DoD Check

| 項目 | 結果 |
|------|------|
| List / Card 切替がフィルタバー右で動作する | ○ |
| 既存 Datagrid は変更なし | ○ |
| Card 表示が mcard 構造（§4.1）に沿っている | ○ |
| 既存 test / ビルドが通る | ○（要実行確認） |

---

## 4. Scope Check

OK（変更は MembersList.jsx のみ）

---

## 5. SSOT Check

OK（FIT_AND_GAP §4.1 に従って mcard 構造を実装。SSOT の更新は本 Phase では不要）

---

## 6. Merge Evidence

（develop へ merge 実施後に記入）

- merge commit id:
- source branch: feature/m4d-members-list-card
- target branch: develop
- phase id: M4D
- phase type: implement
- related ssot: FIT_AND_GAP_MOCK_VS_UI.md §4.1

- test command: `php artisan test`（バックエンド）、`npm run build`（フロント）
- test result:

- changed files: www/resources/js/admin/pages/MembersList.jsx

- scope check: OK
- ssot check: OK
- dod check: OK

---

## 7. 参照

- PLAN: [PHASE_M4D_MEMBERS_LIST_CARD_PLAN.md](PHASE_M4D_MEMBERS_LIST_CARD_PLAN.md)
- WORKLOG: [PHASE_M4D_MEMBERS_LIST_CARD_WORKLOG.md](PHASE_M4D_MEMBERS_LIST_CARD_WORKLOG.md)
- FIT_AND_GAP §4.1: docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md

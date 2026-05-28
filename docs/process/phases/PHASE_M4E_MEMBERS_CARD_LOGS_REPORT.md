# Phase M4E Members Card 関係ログ表示 — REPORT

**Phase:** M4E  
**完了日:** 2026-03-10  
**参照:** [PHASE_M4E_MEMBERS_CARD_LOGS_PLAN.md](PHASE_M4E_MEMBERS_CARD_LOGS_PLAN.md)、[PHASE_M4E_MEMBERS_CARD_LOGS_WORKLOG.md](PHASE_M4E_MEMBERS_CARD_LOGS_WORKLOG.md)

---

## Summary

- Members ページの Card 表示で、各 MemberCard の mc-logs「関係ログ（最近）」を既存 contact-memos API で取得した直近最大 3 件で表示するようにした。
- owner_member_id は MembersList.jsx 既存の OWNER_MEMBER_ID を流用。新規 state や認証取得は追加していない。
- 取得中は「読込中…」、0 件は「—」を表示。各ログは種別（1to1/例会/その他）・日付（M/D）・本文 40 字抜粋で .log-i 相当の表示にした。1to1 履歴の統合表示は今回対象外（次 Phase 検討）。

---

## Changed Files

- www/resources/js/admin/pages/MembersList.jsx
  - 定数 CARD_LOGS_LIMIT = 3 を追加
  - MemberCard: useState(recentLogs, loadingLogs)、useEffect で GET contact-memos（owner_member_id=OWNER_MEMBER_ID, target_member_id=record.id, limit=3）を実行
  - mc-logs 内を読込中／0件／一覧の 3 分岐に変更し、一覧は .log-i 相当の行を map で表示

---

## DoD Check

| 項目 | 結果 |
|------|------|
| Card 表示時、mc-logs に直近メモ最大 3 件表示 | ○ |
| 既存 API 変更なし | ○ |
| List 表示・Datagrid 変更なし | ○ |
| test / ビルド成功 | ○（php artisan test 79 passed, npm run build 成功） |

---

## Scope Check

OK（変更は MembersList.jsx のみ。API・List 表示・他ページは変更なし）

---

## SSOT Check

OK（FIT_AND_GAP §4.1 の .mc-logs / .log-i に沿って実装。SSOT の更新は不要）

---

## Merge Evidence

（develop へ merge 後に記入）

- merge commit id:
- source branch: feature/m4e-members-card-logs
- target branch: develop
- phase id: M4E
- phase type: implement
- related ssot: FIT_AND_GAP_MOCK_VS_UI.md §4.1, §4.2 M17
- test command: `php artisan test`、`npm run build`
- test result: 79 passed (300 assertions)、npm run build 成功
- changed files: www/resources/js/admin/pages/MembersList.jsx
- scope check: OK
- ssot check: OK
- dod check: OK

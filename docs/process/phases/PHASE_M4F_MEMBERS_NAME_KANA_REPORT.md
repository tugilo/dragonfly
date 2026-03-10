# Phase M4F Members 一覧かな表示 — REPORT

**Phase:** M4F  
**完了日:** 2026-03-10  
**参照:** [PHASE_M4F_MEMBERS_NAME_KANA_PLAN.md](PHASE_M4F_MEMBERS_NAME_KANA_PLAN.md)、[PHASE_M4F_MEMBERS_NAME_KANA_WORKLOG.md](PHASE_M4F_MEMBERS_NAME_KANA_WORKLOG.md)

---

## Summary

- Members の List 表示で「名前」列を FunctionField にし、名前の下に name_kana（かな）を補助表示する**名前列内サブ表示**で M9 Gap を解消した。かな列は追加せず、横幅・既存レイアウトを維持。
- Card 表示では mc-hdr 内の .mc-kana を確認し、空値判定を明示化（null/空文字で「—」）し、mt: 0.25 で名前とかなの間の余白を追加した。
- 既存 API は変更していない。変更は MembersList.jsx のみ。

---

## Changed Files

- www/resources/js/admin/pages/MembersList.jsx
  - List: 「名前」列を TextField から FunctionField に変更。名前＋かな（name_kana があるときのみ 2 行目）を表示。sortable と sortBy="name" でソート維持。
  - Card: mc-kana の表示を (record.name_kana != null && String(record.name_kana).trim() !== '') ? ... : '—' にし、sx={{ display: 'block', mt: 0.25 }} を追加。

---

## DoD Check

| 項目 | 結果 |
|------|------|
| List で名前＋かなが名前列内に表示 | ○ |
| Card で mc-hdr のかなが SSOT に沿っている | ○ |
| 空値時が不自然でない | ○ |
| Datagrid の他列・ソートが壊れていない | ○ |
| API 変更なし・Scope は MembersList.jsx のみ | ○ |
| test / build 成功 | ○（php artisan test 79 passed、npm run build 成功） |

---

## Scope Check

OK（変更は MembersList.jsx のみ。API・他ページは未変更）

---

## SSOT Check

OK（FIT_AND_GAP §4.1 .mc-name / .mc-kana、§4.2 M9 に沿って実装。SSOT の更新は不要）

---

## Merge Evidence

（develop へ merge 後に記入）

- merge commit id:
- source branch: feature/m4f-members-name-kana
- target branch: develop
- phase id: M4F
- phase type: implement
- related ssot: FIT_AND_GAP_MOCK_VS_UI.md §4.1, §4.2 M9
- test command: `php artisan test`、`npm run build`
- test result: 79 passed (300 assertions)、npm run build 成功
- changed files: www/resources/js/admin/pages/MembersList.jsx
- scope check: OK
- ssot check: OK
- dod check: OK

---

## 実装判断

**名前列内サブ表示** を採用した。理由: 横幅・可読性を優先し既存 Datagrid を大きく崩さないため。かな列を追加すると列が増えて横幅が伸びるため、名前列の補助表示で M9 を解消した。

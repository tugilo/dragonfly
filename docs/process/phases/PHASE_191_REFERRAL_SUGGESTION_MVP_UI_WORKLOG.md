# WORKLOG: Phase 191 — REFERRAL-SUGGESTION-MVP-UI

**Phase ID:** 191  
**ステータス:** 実装完了（2026-06-04 13:55 JST）— develop merge 前

---

## 設計判断

| 判断 | 理由 | 日付 |
|------|------|------|
| 121 / 定例会で `ReferralSuggestionDialogCore` を共有 | generate/get/patch の UX（原文 Markdown・run 切替・AI Alert）が同一。PATCH パスと direction ラベルのみ差分 | 2026-06-04 13:55 JST |
| API 呼び出しを `referralSuggestionApi.js` に集約 | `religoFetch` パターン踏襲。disabled 条件も UI と共通化 | 2026-06-04 13:55 JST |
| 「採用して登録」は disabled + Tooltip | register-introduction API は Phase 192。却下・あとでの PATCH のみ有効化 | 2026-06-04 13:55 JST |
| 定例会 Dialog は必要時に `GET /api/meetings/{id}` で議事録取得 | 一覧行には `body_markdown` が無い。Drawer 議事録モーダルからは minutes を渡して再 fetch 回避 | 2026-06-04 13:55 JST |

---

## モック比較メモ

- [FIT_AND_GAP_MOCK_VS_UI.md](../../SSOT/FIT_AND_GAP_MOCK_VS_UI.md) §6 O16（121 行「リファーラル」）
- [FIT_AND_GAP_MEETINGS.md](../../SSOT/FIT_AND_GAP_MEETINGS.md) M12（Meetings 行＋議事録モーダル）

---

## 実装ファイル

- `www/resources/js/admin/referralSuggestionApi.js`
- `www/resources/js/admin/components/ReferralSuggestionList.jsx`
- `www/resources/js/admin/components/ReferralSuggestionDialogCore.jsx`
- `www/resources/js/admin/pages/OneToOneReferralSuggestionDialog.jsx`
- `www/resources/js/admin/pages/MeetingReferralSuggestionDialog.jsx`
- `OneToOnesList.jsx` / `MeetingsList.jsx` 組み込み

---

## ブロッカー

- なし（Phase 190 API がローカルに存在することを前提）

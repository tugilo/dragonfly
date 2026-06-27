# Phase 265 REPORT — Member UI Separation（SPEC-020 Phase D）

**完了:** 2026-06-27 JST  
**Phase Type:** implement  
**Branch:** `feature/phase265-member-ui-separation`  
**Related SSOT:** SPEC-003、SPEC-010、SPEC-020 §11.6 順位 6〜8 / 10 / §11.8 Phase D  
**Status:** completed  

---

## 実装サマリ

React 管理画面で `religo_role` による UI 分離を実装した（順位 6〜8 / 10）。

- `authProvider.getPermissions()` が `/api/users/me` の `religo_role` を返却（キャッシュ + auth クリア）。
- `ReligoOwnerContext` に `religoRole` / `isChapterAdmin` を追加。
- `app.jsx` を function-as-child 化し、admin のみ Categories/Roles Resource・MemberEdit・member-merge/SONAE ルートを描画。
- `ReligoMenu` で member には Member merge / SONAE / Categories / Roles を非表示。
- `CustomAppBar` で member は Owner を表示専用（変更不可）。

---

## DoD 達成状況

- [x] member で Member merge / SONAE / Categories / Roles メニュー非表示
- [x] member は Owner Select 表示専用
- [x] member は Members 編集 Resource 無効（edit 未登録）
- [x] admin は従来どおり全機能
- [x] `npm run build` 成功
- [x] `php artisan test` 全 pass（567・回帰）

---

## Merge Evidence

merge commit id: 1d0b7ababa8b6ea50f1cd0f9cf987e471ede1cee  
source branch: feature/phase265-member-ui-separation  
target branch: develop  
phase id: 265  
phase type: implement  
related ssot: SPEC-020 / SPEC-010 / SPEC-003  

test command: `php artisan test` / `npm run build`  
test result: 567 passed (2086 assertions) / build OK  

changed files:
- www/resources/js/admin/authProvider.js
- www/resources/js/admin/ReligoOwnerContext.jsx
- www/resources/js/admin/app.jsx
- www/resources/js/admin/ReligoMenu.jsx
- www/resources/js/admin/CustomAppBar.jsx
- docs/process/phases/PHASE_265_*、PHASE_REGISTRY.md、INDEX.md、dragonfly_progress.md

scope check: OK  
ssot check: OK  
dod check: OK

# Phase 271 PLAN — Members ドロワー email 編集の admin 判定安定化

**作成:** 2026-06-27 16:38 JST  
**Phase Type:** implement  
**Branch:** `feature/phase271-member-email-drawer-permission-fix`  
**Related SSOT:** SPEC-010、SPEC-011、FIT_AND_GAP_MEMBER_EMAIL_REGISTRATION、Phase 270  
**Status:** completed  

---

## Purpose

Phase 270 のブラウザ確認で、ログインユーザーは `chapter_admin` であるにもかかわらず Members 詳細ドロワーの email 編集カードが表示されないケースを確認した。ドロワー内の admin 判定を安定化し、実機で email 編集カードが確実に表示されるようにする。

---

## Scope

- `www/resources/js/admin/pages/MembersList.jsx`
- `PHASE_271_*`、`PHASE_REGISTRY.md`、`INDEX.md`、`dragonfly_progress.md`

---

## DoD

- [x] admin で Members 詳細ドロワーに「ログイン用メールアドレス」カードが表示される
- [x] ブラウザで「メールを保存」ボタンを確認できる
- [x] `npm run build` 成功
- [x] `php artisan test` 全 pass（567 passed / 2086 assertions）

---

## 設計

`useReligoOwner().isChapterAdmin` のみに依存せず、ドロワー open 時に `/api/users/me` を `religoFetch` で直接確認し、`religo_role === 'chapter_admin'` の場合に email 編集カードを表示する。これにより Context の初期値・再描画タイミングに依存しない。

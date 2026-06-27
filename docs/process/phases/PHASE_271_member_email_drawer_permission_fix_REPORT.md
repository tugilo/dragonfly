# Phase 271 REPORT — Members ドロワー email 編集の admin 判定安定化

**完了:** 2026-06-27 16:38 JST  
**Phase Type:** implement  
**Branch:** `feature/phase271-member-email-drawer-permission-fix`  
**Related SSOT:** SPEC-010、SPEC-011、FIT_AND_GAP_MEMBER_EMAIL_REGISTRATION、Phase 270  
**Status:** completed  

---

## 成果

Phase 270 で追加した Members 詳細ドロワーの email 編集カードについて、admin 判定を安定化した。`useReligoOwner().isChapterAdmin` に加えて、ドロワー open 時に `/api/users/me` を直接確認し、`religo_role=chapter_admin` の場合に表示する。

---

## DoD 達成

- [x] admin で Members 詳細ドロワーに「ログイン用メールアドレス」カードが表示される
- [x] ブラウザで「メールを保存」ボタンを確認（スクリーンショット取得済み: `phase271-member-email-drawer.png`）
- [x] `npm run build` 成功
- [x] `php artisan test` 全 pass（567 passed / 2086 assertions）

---

## Merge Evidence

merge commit id: 79423d198f94ed46db9d1754f146d27136deec82  
source branch: feature/phase271-member-email-drawer-permission-fix  
target branch: develop  
phase id: 271  
phase type: implement  
related ssot: SPEC-010 / SPEC-011 / FIT_AND_GAP_MEMBER_EMAIL_REGISTRATION  

test command: php artisan test  
test result: 567 passed (2086 assertions)  

changed files:
- www/resources/js/admin/pages/MembersList.jsx
- docs/process/phases/PHASE_271_*
- docs/process/PHASE_REGISTRY.md / docs/INDEX.md / docs/dragonfly_progress.md

scope check: OK  
ssot check: OK  
dod check: OK  

### main 反映

main merge commit id: <fill-main>  
target branch: main  
備考: ユーザー指示により develop → main を merge・push。

# PHASE15B Religo 役職履歴照会 API + ReactAdmin — REPORT

**Phase:** PHASE15B 役職履歴照会  
**完了日:** 2026-03-05

---

## 実施内容（完了時点）

- GET /api/member-roles を追加（MemberRoleController, MemberRoleIndexService）。role_id / member_id / from / to でフィルタ、term_start DESC, id DESC でソート。
- MemberRoleIndexTest を 5 本追加（一覧形、role 絞り、member 絞り、期間・term_end NULL、sort）。
- dataProvider に member-roles の getList を追加。MemberRolesList.jsx で一覧・フィルタ（役職 / メンバー / 期間）・列（状態＝現役/過去）を実装。Resource とメニューに「役職履歴」を追加。

## 変更ファイル一覧

- www/app/Http/Controllers/Religo/MemberRoleController.php（新規）
- www/app/Services/Religo/MemberRoleIndexService.php（新規）
- www/routes/api.php
- www/tests/Feature/Religo/MemberRoleIndexTest.php（新規）
- www/resources/js/admin/dataProvider.js
- www/resources/js/admin/pages/MemberRolesList.jsx（新規）
- www/resources/js/admin/app.jsx
- www/resources/js/admin/ReligoMenu.jsx
- docs/process/phases/PHASE15B_ROLE_HISTORY_LIST_*.md（PLAN/WORKLOG/REPORT）
- docs/INDEX.md
- docs/dragonfly_progress.md

## テスト結果

Tests: 32 passed (151 assertions)（既存 27 + 新規 5）

## DoD チェック

- [x] 新規 API テスト green
- [x] ReactAdmin で一覧・絞り込み可能
- [x] 既存 27 を含め全テスト green
- [x] docs 更新

---

## 取り込み証跡（develop への merge 後）

| 項目 | 内容 |
|------|------|
| **merge commit id** | （merge 後に記入） |
| **merge 元ブランチ名** | `feature/phase15b-role-history-list` |
| **テスト結果** | 32 passed (151 assertions) |

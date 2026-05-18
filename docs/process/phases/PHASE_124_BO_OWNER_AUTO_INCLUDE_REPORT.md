# Phase 124 REPORT — Connections BO 保存時 Owner の BO1 自動追加

## 概要

`PUT /api/meetings/{id}/breakouts` に任意の `owner_member_id` を追加し、当該メンバーが BO1/BO2 のどちらにも含まれないとき **BO1 に自動追加**する。Connections の「BO割当を保存」からグローバル Owner id を送る。

## 変更ファイル（予定・merge 前）

- `www/app/Services/Religo/MeetingBreakoutService.php`
- `www/app/Http/Controllers/Religo/MeetingBreakoutController.php`
- `www/app/Http/Requests/Religo/UpdateMeetingBreakoutsRequest.php`
- `www/resources/js/admin/pages/DragonFlyBoard.jsx`
- `www/tests/Feature/Religo/MeetingBreakoutsTest.php`
- `docs/SSOT/CONTACT_LOGIC_ALIGNMENT.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`
- 本 PLAN / WORKLOG / REPORT

## テスト

- `php artisan test` — **371 passed**
- `npm run build` — 成功

## 取り込み証跡（Merge Evidence）

- **merge commit id:** `ce278b26fa5ef6d285e88f9e72bf589777267e88`
- **source branch:** `feature/merge-wip-20260518`（同一バッチに Phase 118–123・その他 docs を含む）
- **target branch:** `develop`
- **test command:** `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test`
- **test result:** 371 passed（merge 直後）
- **scope check:** OK
- **ssot check:** OK（CONTACT_LOGIC_ALIGNMENT 更新済み）

変更ファイル一覧は merge commit の親に対する diff で参照（87 files）。

## チェック

- scope: OK（www/docs のみ）
- ssot: CONTACT_LOGIC_ALIGNMENT 更新済み
- dod: テスト・ビルド成功後に OK

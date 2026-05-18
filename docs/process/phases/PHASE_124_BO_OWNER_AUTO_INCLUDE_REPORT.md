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

 develop へ merge 後に追記すること:

- merge commit id:
- source branch:
- test command / result:
- changed files: `git diff --name-only merge-base...`

## チェック

- scope: OK（www/docs のみ）
- ssot: CONTACT_LOGIC_ALIGNMENT 更新済み
- dod: テスト・ビルド成功後に OK

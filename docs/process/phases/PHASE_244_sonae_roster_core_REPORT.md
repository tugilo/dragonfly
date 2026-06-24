# PHASE_244_sonae_roster_core REPORT

**作成日時:** 2026-06-24 21:09 JST  
**最終更新日時:** 2026-06-24 21:15 JST  
**Phase Type:** implement  
**Related SSOT:** SPEC-017  
**Status:** completed

---

## 概要

SONAE PoC **Phase 244 Roster Core** を実装。Religo 非依存の名簿層（閾値マスタ、sync フィルタ、通知対象 Resolver、メンバー API、CSV 取込）を `/api/sonae/*` として提供。519 tests passed。

---

## 実施内容

- `sonae_alert_threshold_options` migration + seeder（9種閾値）
- `SonaeMemberSyncService` — guest/visitor 除外（`MemberEnrollmentType::isBniMember`）
- `SonaeNotificationTargetResolver` — LINE 紐付け済み active メンバーのみ
- `SonaeMemberService` / `SonaeCsvImportService`
- API: chapter KPI、members、unlinked、sync、import-csv、alert-threshold-options
- `SonaeRosterCoreTest`（6 cases）
- [SONAE_IMPLEMENTATION_PLAN.md](../../SSOT/SONAE_IMPLEMENTATION_PLAN.md) 新規

---

## 変更ファイル一覧

- `www/database/migrations/2026_06_24_210900_create_sonae_alert_threshold_options_table.php`
- `www/database/seeders/SonaeAlertThresholdOptionSeeder.php`
- `www/app/Models/Sonae/SonaeAlertThresholdOption.php`
- `www/app/Models/Sonae/SonaeAlertType.php`
- `www/app/Models/Sonae/SonaeMember.php`
- `www/app/Models/Sonae/SonaeConstants.php`
- `www/app/Services/Sonae/SonaeMemberSyncService.php`
- `www/app/Services/Sonae/SonaeNotificationTargetResolver.php`
- `www/app/Services/Sonae/SonaeMemberService.php`
- `www/app/Services/Sonae/SonaeCsvImportService.php`
- `www/app/Http/Controllers/Sonae/SonaeChapterController.php`
- `www/app/Http/Controllers/Sonae/SonaeMemberController.php`
- `www/app/Http/Controllers/Sonae/SonaeAlertThresholdOptionController.php`
- `www/routes/api.php`
- `www/tests/Feature/Sonae/SonaeRosterCoreTest.php`
- `docs/SSOT/SONAE_IMPLEMENTATION_PLAN.md`
- `docs/SSOT/SONAE_REQUIREMENTS.md`
- `docs/SSOT/SONAE_WALL_BOUNCE_DECISIONS.md`
- `docs/process/phases/PHASE_244_*`
- `docs/process/PHASE_REGISTRY.md`
- `docs/dragonfly_progress.md`
- `docs/INDEX.md`
- `docs/02_specifications/SSOT_REGISTRY.md`

---

## テスト結果

```
php artisan test
Tests: 519 passed (1954 assertions)
```

---

## DoD チェック

| 項目 | 結果 |
|------|------|
| alert_threshold_options migration + seeder | OK |
| type=member sync フィルタ | OK |
| NotificationTargetResolver | OK |
| CSV 単体パス | OK |
| Member API + unlinked + KPI | OK |
| Feature tests + artisan test | OK |

---

## Merge Evidence

merge commit id: （merge 後に記録）  
source branch: feature/phase244-sonae-roster-core  
target branch: develop  
phase id: 244  
phase type: implement  
related ssot: SPEC-017  

test command: php artisan test  
test result: 519 passed  

scope check: OK  
ssot check: OK  
dod check: OK  

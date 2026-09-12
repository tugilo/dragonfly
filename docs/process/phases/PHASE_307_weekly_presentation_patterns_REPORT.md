# REPORT: Phase 307 — ウィークリー稿のパターン切替と利用履歴

| 項目 | 内容 |
|------|------|
| **完了** | 2026-09-12 11:00 JST |
| **種別** | implement |
| **Related SSOT** | SPEC-004 |

## Summary

Dashboard のウィークリータブで A〜E を切替できるようにした。チップは表示切替だけ。利用日は例会後の「この週に使った」で `member_weekly_presentation_usages` に残る。同一日・同一パターンは1行。次廣（members.id=37）に §2.5.8 をシードした。

## Deliverables

- migration: members 2カラム + `member_weekly_presentation_usages`
- GET `/api/dashboard/weekly-presentation` に patterns / active_id / usages
- POST `/api/dashboard/weekly-presentation/select`
- Dashboard チップと最近の利用
- `TsugihiroWeeklyPresentationPatternsSeeder`
- SPEC-004 / DATA_MODEL / FIT_AND_GAP / Living Document / INDEX / progress / REGISTRY

## DoD Check

| Item | Result |
|------|--------|
| パターン切替 | OK（ブラウザで B→A。稿が切り替わった） |
| 履歴 | OK（切替では残らない。例会後ボタンで残る。同一日同一パターンは増やさない） |
| 既存 GET キー | OK（`weekly_presentation_body` / `start_dash_presentation_body`） |
| テスト | OK（620 passed / 2282 assertions） |
| ビルド | OK（`npm run build`） |
| スタートダッシュ | OK（タブ切替で稿表示。チップは出ない） |
| パターン無し | OK（Feature テストで空配列・従来1本文） |

## ブラウザ確認

- URL: `http://localhost/admin#/`
- Owner 次廣。チップ A〜E 表示。切替だけでは新しい利用行は増えない。
- 「この週に使った」を押すと、表示中のパターンの利用日が残る。
- スタートダッシュタブは既存稿のまま。チップと利用ボタンは隠れる。
- コピー Snackbar は自動化環境では確認できず。ボタンは残っている。

## Merge Evidence

| Item | Value |
|------|-------|
| merge commit id | 未実施（この Phase では commit / merge / push しない） |
| source branch | feature/phase307-weekly-presentation-patterns |
| target branch | develop |
| phase id | 307 |
| phase type | implement |
| related ssot | SPEC-004 |
| test command | php artisan test |
| test result | 620 passed / 2282 assertions |
| changed files | 下記（Phase 307 分。develop dirty の 1to1 / webmaster / dragonfly.sql は含めない） |
| scope check | OK |
| ssot check | OK |
| dod check | OK |

### changed files（Phase 307）

```
docs/02_specifications/SSOT_REGISTRY.md
docs/INDEX.md
docs/SSOT/DASHBOARD_WEEKLY_PRESENTATION_REQUIREMENTS.md
docs/SSOT/DATA_MODEL.md
docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md
docs/dragonfly_progress.md
docs/process/PHASE_REGISTRY.md
docs/process/phases/PHASE_307_weekly_presentation_patterns_PLAN.md
docs/process/phases/PHASE_307_weekly_presentation_patterns_WORKLOG.md
docs/process/phases/PHASE_307_weekly_presentation_patterns_REPORT.md
docs/strategy/networking/BNI_Tsugihiro_Atsushi_Intro_Living_Document.md
www/app/Http/Controllers/Religo/DashboardController.php
www/app/Models/Member.php
www/app/Models/MemberWeeklyPresentationUsage.php
www/app/Services/Religo/WeeklyPresentationPatternService.php
www/database/migrations/2026_09_12_105400_add_weekly_presentation_patterns_and_usages.php
www/database/seeders/TsugihiroWeeklyPresentationPatternsSeeder.php
www/resources/js/admin/pages/Dashboard.jsx
www/resources/js/admin/pages/dashboard/DashboardWeeklyPresentationPanel.jsx
www/routes/api.php
www/tests/Feature/Religo/DashboardApiTest.php
```

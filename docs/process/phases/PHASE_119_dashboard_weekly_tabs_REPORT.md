# REPORT: Phase 119 — Dashboard プレゼン原稿タブ化

## Summary

- Dashboard のプレゼン原稿カードを **ウィークリープレゼン / スタートダッシュ** のタブ切り替えに変更した。
- `members.start_dash_presentation_body` を追加し、既存 API `GET /api/dashboard/weekly-presentation` で標準稿とスタートダッシュ稿を同時に返すようにした。
- 2026-05-19 DragonFly定例会用のスタートダッシュ60秒稿をドキュメント・SQL dump・ローカルDBに反映した。
- 原稿本文は高さ可変にし、読み上げ時にカード内スクロールが不要になるようにした。

## DoD

- [x] Dashboard 原稿カードで、標準稿とスタートダッシュ稿をタブで切り替えられる。
- [x] どちらのタブでも本文の改行保持・全文コピーができる。
- [x] 原稿本文は高さ可変で、カード内スクロールなしに全文表示できる。
- [x] Owner 未設定・原稿未登録・API エラー時の既存挙動を壊さない。
- [x] `GET /api/dashboard/weekly-presentation` の既存互換キー `weekly_presentation_body` を維持し、新キー `start_dash_presentation_body` を返す。
- [x] `php artisan test` と `npm run build` が成功する。
- [x] WORKLOG / REPORT / PHASE_REGISTRY / docs/INDEX.md / docs/dragonfly_progress.md を更新する。

## Test

- `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test --filter=DashboardApiTest`
  - 25 passed / 83 assertions
- `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test`
  - 357 passed / 1415 assertions
- `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec node npm run build`
  - 成功（2026-05-17 22:14 JST の高さ可変追補後も成功）
- `ReadLints`
  - 対象編集ファイルに linter error なし
- ローカル API 確認
  - `weekly_presentation_body`: true
  - `start_dash_presentation_body`: true

## Merge Evidence

merge commit id: 未実施
source branch: feature/phase119-dashboard-weekly-tabs
target branch: develop
phase id: 119
phase type: implement
related ssot: SPEC-004

test command: php artisan test / npm run build
test result: 357 passed / 1415 assertions、npm run build 成功

changed files:
- docs/INDEX.md
- docs/02_specifications/SSOT_REGISTRY.md
- docs/SSOT/DASHBOARD_WEEKLY_PRESENTATION_REQUIREMENTS.md
- docs/SSOT/DATA_MODEL.md
- docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md
- docs/dragonfly_progress.md
- docs/process/PHASE_REGISTRY.md
- docs/process/phases/PHASE_119_dashboard_weekly_tabs_PLAN.md
- docs/process/phases/PHASE_119_dashboard_weekly_tabs_WORKLOG.md
- docs/process/phases/PHASE_119_dashboard_weekly_tabs_REPORT.md
- docs/strategy/networking/BNI_Tsugihiro_Atsushi_Intro_Living_Document.md
- www/app/Http/Controllers/Religo/DashboardController.php
- www/app/Models/Member.php
- www/database/migrations/2026_05_17_220800_add_start_dash_presentation_body_to_members_table.php
- www/database/sql/dragonfly260409.sql
- www/resources/js/admin/pages/Dashboard.jsx
- www/resources/js/admin/pages/dashboard/DashboardWeeklyPresentationPanel.jsx
- www/tests/Feature/Religo/DashboardApiTest.php

scope check: OK
ssot check: OK
dod check: OK

備考: ユーザーから commit / merge / push の依頼は受けていないため、Merge Evidence の merge commit id は未実施のままとする。

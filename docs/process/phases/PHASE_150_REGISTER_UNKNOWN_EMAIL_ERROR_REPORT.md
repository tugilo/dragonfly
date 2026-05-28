# Phase 150 REPORT

## Phase

- **Phase ID:** 150
- **Type:** implement
- **Completed at:** 2026-05-28 22:07 JST
- **Related SSOT:** SPEC-011

## 実施内容

- member 未一致時に **422** + `errors.email`（汎用 200 を廃止）
- `AuthRegisterTest` を 422 / Cache なし / Mail 未送信に更新
- UI は既存 catch で email ステップに留まる（コード変更なし）

## Merge Evidence

merge commit id: 2a157d0ffaed237958091c51469882cf93e68bbb
source branch: feature/phase150-register-unknown-email-error
target branch: develop
phase id: 150
phase type: implement
related ssot: SPEC-011

test command: docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test
test result: 394 passed (1516 assertions)

changed files:
```
docs/INDEX.md
docs/SSOT/AUTH_REGISTRATION_EMAIL_REQUIREMENTS.md
docs/dragonfly_progress.md
docs/process/PHASE_REGISTRY.md
docs/process/phases/PHASE_149_REGISTER_UNKNOWN_EMAIL_ERROR_PLAN.md
docs/process/phases/PHASE_149_REGISTER_UNKNOWN_EMAIL_ERROR_REPORT.md
docs/process/phases/PHASE_149_REGISTER_UNKNOWN_EMAIL_ERROR_WORKLOG.md
docs/process/phases/PHASE_150_REGISTER_UNKNOWN_EMAIL_ERROR_PLAN.md
docs/process/phases/PHASE_150_REGISTER_UNKNOWN_EMAIL_ERROR_REPORT.md
docs/process/phases/PHASE_150_REGISTER_UNKNOWN_EMAIL_ERROR_WORKLOG.md
www/app/Services/Religo/MemberAccountRegistrationService.php
www/tests/Feature/Api/AuthRegisterTest.php
```

scope check: OK
ssot check: OK
dod check: OK

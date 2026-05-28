# Phase 150 PLAN: SPEC-011 member 未一致 — 初回登録 422 エラー（implement）

## Phase

- **Phase ID:** 150
- **Name:** 初回登録 — members.email 未一致時 422 + 画面エラー
- **Type:** implement
- **Started at:** 2026-05-28 22:07 JST

## Related SSOT

- **SPEC-011:** `docs/SSOT/AUTH_REGISTRATION_EMAIL_REQUIREMENTS.md` §12

## Scope

- `www/app/Services/Religo/MemberAccountRegistrationService.php`
- `www/tests/Feature/Api/AuthRegisterTest.php`
- Phase 150 PLAN / WORKLOG / REPORT
- PHASE_REGISTRY、INDEX、dragonfly_progress、SPEC-011 §12

## Out of scope

- `ReligoLogin.jsx` — 422 時は既に catch で email ステップに留まる（変更不要）

## DoD

- [ ] member 未存在時 **422** + `errors.email`
- [ ] Mail 送信 0、Cache なし
- [ ] `php artisan test` green
- [ ] `npm run build` green（UI 変更なしだが確認）

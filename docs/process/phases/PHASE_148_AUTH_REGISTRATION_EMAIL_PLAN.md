# Phase 148 PLAN: SPEC-011 初回登録 — 確認コードメール送信（implement）

## Phase

- **Phase ID:** 148
- **Name:** SPEC-011 確認コードメール送信 implement
- **Type:** implement
- **Started at:** 2026-05-28 21:54 JST

## Related SSOT

- **SPEC-011:** `docs/SSOT/AUTH_REGISTRATION_EMAIL_REQUIREMENTS.md`
- **SPEC-010:** `docs/SSOT/AUTH_LOGIN_AND_OWNER_BINDING_REQUIREMENTS.md`

## Scope

- `www/app/Mail/ReligoRegistrationVerificationMail.php`
- `www/resources/views/mail/religo-registration-verification.blade.php`
- `www/app/Services/Religo/MemberAccountRegistrationService.php`
- `www/tests/Feature/Api/AuthRegisterTest.php`
- `www/resources/js/admin/pages/ReligoLogin.jsx`（文言）
- `www/.env.religo_app.example` / `www/.env.religo_dev.example`
- Phase 147 docs（同梱 commit）
- `docs/process/phases/PHASE_148_*`、PHASE_REGISTRY、INDEX、dragonfly_progress、SPEC-011 変更履歴

## DoD

- [ ] member 一致時 Mailable 送信（sync）
- [ ] 送信失敗時 Cache ロールバック + 503
- [ ] `AuthRegisterTest`（Mail::fake）green
- [ ] `npm run build` green
- [ ] SPEC-011 §11 DoD 項目を満たす

## モック比較

- 対象外（ログイン画面文言のみ）

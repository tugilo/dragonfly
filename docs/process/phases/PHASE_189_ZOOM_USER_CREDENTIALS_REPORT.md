# PHASE 189 REPORT — Zoom ユーザー資格情報

- **Status:** completed
- **Phase ID:** 189
- **Type:** implement
- **Related SSOT:** SPEC-012

## 成果

- `user_zoom_credentials` テーブル・Model（`client_secret` / `webhook_secret_token` encrypted）
- `ZoomCredentialResolver` / `ZoomWebhookSecretResolver`
- API: `GET/PUT /api/zoom/credentials`, `POST /api/zoom/credentials/test`
- 設定画面に Zoom 資格情報カード（Redirect URI 表示・接続テスト）
- OAuth / Webhook が per-user credentials に対応（`.env` フォールバック維持）
- Zoom 取り込み画面に未連携時の案内 Alert

## テスト

- command: `php artisan test --filter=Zoom` → 26 passed
- command: `php artisan test` → 444 passed / 1 failed（`ImportOneToOneNotesCommandTest` — 本 Phase 外・既存）
- `npm run build` OK

## Merge Evidence

merge commit id: `1ec916dd3cf427833deff9ce703459a77b8bda25`
source branch: feature/phase189-zoom-user-credentials
target branch: develop
phase id: 189
phase type: implement
related ssot: SPEC-012

test command: php artisan test
test result: 444 passed / 1 failed (pre-existing ImportOneToOneNotesCommandTest)

changed files:
docs/INDEX.md
docs/SSOT/DATA_MODEL.md
docs/SSOT/ZOOM_INTEGRATION_SETUP.md
docs/SSOT/ZOOM_ONETOONE_SYNC_REQUIREMENTS.md
docs/dragonfly_progress.md
docs/process/PHASE_REGISTRY.md
docs/process/phases/PHASE_189_ZOOM_USER_CREDENTIALS_PLAN.md
docs/process/phases/PHASE_189_ZOOM_USER_CREDENTIALS_REPORT.md
docs/process/phases/PHASE_189_ZOOM_USER_CREDENTIALS_WORKLOG.md
www/.env.example
www/app/Http/Controllers/Zoom/UserZoomCredentialController.php
www/app/Http/Controllers/Zoom/ZoomOAuthController.php
www/app/Http/Controllers/Zoom/ZoomWebhookController.php
www/app/Http/Middleware/VerifyZoomWebhookSignature.php
www/app/Models/UserZoomCredential.php
www/app/Services/Zoom/ZoomCredentialResolver.php
www/app/Services/Zoom/ZoomTokenService.php
www/app/Services/Zoom/ZoomWebhookSecretResolver.php
www/config/services.php
www/database/migrations/2026_06_04_120000_create_user_zoom_credentials_table.php
www/resources/js/admin/pages/ReligoSettings.jsx
www/resources/js/admin/pages/ZoomImport.jsx
www/routes/api.php
www/tests/Feature/Zoom/UserZoomCredentialTest.php
www/tests/Feature/Zoom/ZoomWebhookTest.php

scope check: OK
ssot check: OK
dod check: OK

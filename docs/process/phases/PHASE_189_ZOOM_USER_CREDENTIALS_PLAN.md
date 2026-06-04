# PHASE 189 — Zoom ユーザー資格情報（BYO app credentials）

- **Phase ID:** 189
- **Type:** implement
- **Branch:** feature/phase189-zoom-user-credentials
- **Related SSOT:** SPEC-012（Zoom 連携）
- **Date:** 2026-06-04 08:57 JST

## 背景

Zoom OAuth の Client ID / Secret が `.env` 共有前提のため、各ユーザーが自分の Zoom Marketplace アプリを登録できない。AI 設定（SPEC-013 BYO key）と同様に per-user + 暗号化保存へ拡張する。

## Scope

- `www/database/migrations/` — `user_zoom_credentials`
- `www/app/Models/UserZoomCredential.php`
- `www/app/Services/Zoom/ZoomCredentialResolver.php`
- `www/app/Services/Zoom/ZoomWebhookSecretResolver.php`
- `www/app/Http/Controllers/Zoom/UserZoomCredentialController.php`
- `ZoomTokenService` / `ZoomOAuthController` / Webhook ミドルウェア・コントローラ
- `www/routes/api.php`
- `www/resources/js/admin/pages/ReligoSettings.jsx` / `ZoomImport.jsx`
- `www/tests/Feature/Zoom/UserZoomCredentialTest.php` + Webhook テスト更新
- `docs/SSOT/ZOOM_ONETOONE_SYNC_REQUIREMENTS.md` §6 追記
- `docs/dragonfly_progress.md`

## 設計

| 項目 | 方針 |
|------|------|
| `client_id` | 平文（公開情報） |
| `client_secret` | `encrypted` キャスト |
| `webhook_secret_token` | `encrypted` キャスト（任意） |
| `ZOOM_REDIRECT_URI` | システム共通（`.env`）— 全ユーザー同一 callback |
| 解決順 | ユーザー DB → `.env` フォールバック（移行期間） |
| Webhook 署名 | env secret → 全ユーザー secret を順に試行、一致した secret を request attribute に保存 |

## DoD

- [ ] 認証ユーザーが設定画面で Client ID/Secret/Webhook Secret を登録・更新できる
- [ ] Secret は API レスポンスに平文を返さない（`has_*` フラグのみ）
- [ ] OAuth 連携がユーザー credentials で動作（env 未設定でも可）
- [ ] Webhook が per-user secret でも署名検証・ url_validation できる
- [ ] Feature テスト追加・`php artisan test` パス
- [ ] `npm run build` 成功

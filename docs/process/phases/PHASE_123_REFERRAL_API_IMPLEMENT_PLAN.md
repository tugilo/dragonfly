# Phase 123 PLAN: リファーラル DB/API（SPEC-009 実装 P1）

## Phase

- **Phase ID:** 123
- **Name:** referrals マイグレーション・API（introductions.referral_kind / internal_referrals）
- **Type:** implement
- **Started at:** 2026-05-18 07:29 JST

## Related SSOT

- **SPEC-009:** `docs/SSOT/REFERRAL_RECORDING_REQUIREMENTS.md`
- **DATA_MODEL:** `docs/SSOT/DATA_MODEL.md` §4.13 / §4.14

## Scope

- `www/database/migrations/`（2 本）
- `www/app/Models/{Introduction,InternalReferral}.php`
- `www/app/Http/Controllers/Religo/{Introduction,InternalReferral}Controller.php`
- `www/app/Http/Controllers/Religo/Concerns/ResolvesReligoOwner.php`
- `www/app/Http/Requests/Religo/IndexIntroductionsRequest.php` 等
- `www/routes/api.php`
- `www/app/Services/Religo/MemberMergeService.php`（internal_referrals 付け替え・preview 件数）
- `www/tests/Feature/Religo/ReferralApiTest.php`
- `docs/SSOT/DATA_MODEL.md`（主要カラム・API 追記）
- `docs/SSOT/REFERRAL_RECORDING_REQUIREMENTS.md`（§10 実装状況）
- `docs/process/PHASE_REGISTRY.md` / `docs/INDEX.md` / `docs/dragonfly_progress.md` / 本 Phase PLAN・WORKLOG・REPORT

## Out of scope

- React / Vite UI
- Dashboard KPI の `monthly_intro_memo_count` 変更
- `docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md` のチャック（新規画面なし）

## DoD

- マイグレーションが `php artisan migrate` で通る。
- `GET|POST|PATCH /api/introductions` と `GET|POST|PATCH /api/internal-referrals` が owner スコープで動作する（422/404 仕様どおり）。
- `MemberMergeService` が `internal_referrals` を付け替える。
- `php artisan test` 全件成功。

## モック比較

- **対象外**（API のみ）。

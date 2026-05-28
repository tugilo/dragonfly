# Phase 147 PLAN: SPEC-011 初回登録 — 確認コードメール送信（要件 SSOT）

## Phase

- **Phase ID:** 147
- **Name:** SPEC-011 初回アカウント登録 — 確認コードメール送信要件
- **Type:** docs
- **Started at:** 2026-05-28 21:53 JST

## Related SSOT

- **SPEC-011:** `docs/SSOT/AUTH_REGISTRATION_EMAIL_REQUIREMENTS.md`（本 Phase で新規作成）
- **SPEC-010:** `docs/SSOT/AUTH_LOGIN_AND_OWNER_BINDING_REQUIREMENTS.md`（§7.2 オンボーディング・§8 provisioning）
- **Registry:** `docs/02_specifications/SSOT_REGISTRY.md`
- **Deploy:** `docs/DEPLOYMENT.md`（本番 `religo_app`・`.env`）

## Scope（変更可）

- `docs/SSOT/AUTH_REGISTRATION_EMAIL_REQUIREMENTS.md`（新規・**active**）
- `docs/SSOT/AUTH_LOGIN_AND_OWNER_BINDING_REQUIREMENTS.md`（§8 追記・変更履歴）
- `docs/02_specifications/SSOT_REGISTRY.md`（SPEC-011 登録）
- `docs/process/phases/PHASE_147_AUTH_REGISTRATION_EMAIL_*.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`

## Out of scope（implement Phase で実施）

- `MemberAccountRegistrationService` への Mailable 組み込み
- `www/app/Mail/*`・Blade テンプレート
- 本番メール疎通の実地確認
- `composer.json` / 新規パッケージ

## Purpose

本番サーバーで **メール設定（`.env` の `MAIL_*`）が完了**した状態を前提に、現行の **members.email 照合 + 6 桁確認コード（Cache）** フローへ **実メール送信**を追加する前に、要件を SPEC-011 として固定する。ローカル向け `debug_code` との環境差・セキュリティ・送信失敗時の扱いを implement Phase の迷いなく実装できる粒度まで落とす。

## 背景（As-Is）

| 項目 | 状態 |
|------|------|
| API | `POST /api/auth/register/request` / `complete` 実装済み（develop / main） |
| コード配布 | ローカルのみ `debug_code` を API / UI に表示 |
| 本番 | メール未送信のため **初回登録が実質使えない** |
| `.env` | ユーザー報告: **本番でメールサーバー設定済み** |

## Tasks

- [x] SPEC-011 要件 SSOT を作成（機能・非機能・セキュリティ・DoD・実装指針）
- [x] SPEC-010 §8 に SPEC-011 への参照を追加
- [x] SSOT_REGISTRY に SPEC-011 を **active** 登録
- [x] PHASE_REGISTRY / INDEX / dragonfly_progress を更新
- [x] WORKLOG / REPORT を完了

## DoD

- SPEC-011 が **active** として Registry に載り、SPEC-010 §8 から到達できる
- implement Phase で変更すべきファイル一覧・テスト方針が SPEC-011 §9 に書かれている
- Phase 147 の PLAN / WORKLOG / REPORT が揃い、`PHASE_REGISTRY` に **completed** で記録される

## 次 Phase（implement・未着手）

- **想定 ID:** 148（PHASE_REGISTRY 更新時に採番）
- **内容:** Mailable 実装、`Mail::fake()` テスト、本番疎通確認、` .env.religo_app.example` 追記
- **Related SSOT:** SPEC-011

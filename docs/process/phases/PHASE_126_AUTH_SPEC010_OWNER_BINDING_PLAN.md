# Phase 126 PLAN: SPEC-010 ユーザーログインと Owner 紐づけ（要件 SSOT 確定）

## Phase

- **Phase ID:** 126
- **Name:** SPEC-010 ログインと Owner 紐づけ要件の登録・関連 SSOT 同期
- **Type:** docs
- **Started at:** 2026-05-18 10:09 JST

## Related SSOT

- **SPEC-010:** `docs/SSOT/AUTH_LOGIN_AND_OWNER_BINDING_REQUIREMENTS.md`
- **SPEC-003:** `docs/SSOT/ADMIN_GLOBAL_OWNER_SELECTION.md`（§6 と SPEC-010 の相互参照）
- **DATA_MODEL:** `docs/SSOT/DATA_MODEL.md`（owner 定義への SPEC-010 クロスリンク）
- **SPEC-009:** `docs/SSOT/REFERRAL_RECORDING_REQUIREMENTS.md`（§7 権限と SPEC-010 の接続）
- **Registry:** `docs/02_specifications/SSOT_REGISTRY.md`

## Scope（変更可）

- `docs/SSOT/AUTH_LOGIN_AND_OWNER_BINDING_REQUIREMENTS.md`（メタ表の状態を **active** に更新・変更履歴）
- `docs/02_specifications/SSOT_REGISTRY.md`（SPEC-010 を **active**）
- `docs/SSOT/DATA_MODEL.md`（§1 の owner 定義に SPEC-010 参照 1 行）
- `docs/SSOT/REFERRAL_RECORDING_REQUIREMENTS.md`（§7 に SPEC-010 補足）
- `docs/process/phases/PHASE_126_AUTH_SPEC010_OWNER_BINDING_*.md`（本 Phase 記録）
- `docs/process/PHASE_REGISTRY.md`
- `docs/INDEX.md`（Phase 126 一覧行の追加）
- `docs/dragonfly_progress.md`

## Out of scope

- Laravel Sanctum / Breeze / セッション等の認証実装
- Middleware・Policy・ルートガードのコード変更
- `users` マイグレーション（ロール・メール確認列など）

## Purpose

ユーザー認証を導入するとき、「**ログイン アカウント が解決する Owner（`members.id`）**」と API 権限・UI の線引きがブレないよう、製品要件を SPEC-010 として **Single Source** にする。既存のグローバル Owner（SPEC-003）・actor 解決（USER_ME）・リファール（SPEC-009）と矛盾しない参照関係を INDEX / Registry / DATA_MODEL に固定する。

## Tasks

- [x] SPEC-010 文書メタを `active` にし、変更履歴に Phase 126 を記録する。
- [x] `SSOT_REGISTRY` の SPEC-010 行を `active` に更新する。
- [x] `DATA_MODEL` §1（owner 定義）に SPEC-010 への 1 行リンクを追加する。
- [x] `PHASE_REGISTRY`・`INDEX`・`dragonfly_progress` を更新する。
- [x] WORKLOG / REPORT を完了させる。

## DoD

- SPEC-010 が **active** として Registry に載り、DATA_MODEL から到達できる。
- Phase 126 の PLAN / WORKLOG / REPORT が揃い、`PHASE_REGISTRY` に 126 が **completed** で記録される。
- 進捗ファイルに本 Phase の 1 行が追記されている。

# Phase 262 PLAN — Auth Boundary Hardening（SPEC-020 Phase A）

**作成:** 2026-06-27 11:11 JST  
**Phase Type:** implement  
**Branch:** `feature/phase262-auth-boundary-hardening`  
**Related SSOT:** SPEC-010（[AUTH_LOGIN_AND_OWNER_BINDING_REQUIREMENTS.md](../../SSOT/AUTH_LOGIN_AND_OWNER_BINDING_REQUIREMENTS.md)）、SPEC-020 §11.6 順位 1〜2（[ONETOONE_MULTIUSER_MINUTES_REQUIREMENTS.md](../../SSOT/ONETOONE_MULTIUSER_MINUTES_REQUIREMENTS.md)）  
**Status:** completed  

---

## Purpose

SPEC-020 の **P0-A 順位 1〜2** を実装する。

1. **未認証 fallback 停止** — `RELIGO_ACTING_USER_FALLBACK` のデフォルトを `false` にし、本番・テストで未認証 acting user を解決しない。
2. **Default ユーザー処理** — bootstrap 用 `Default` ユーザー（`owner_member_id` 付き）から個人 owner 紐付けを解除する migration。
3. **API 認証境界** — owner スコープ系・管理系 Religo API を `auth:sanctum` 配下へ移す。

**本 Phase 外（Phase 263 以降）:** owner サーバ固定（順位 3〜4）、`religo.chapter_admin` 強制（順位 5）、UI 分離（順位 6〜8）。

---

## Scope

### 変更可

| 領域 | ファイル（例） |
|------|----------------|
| Routes | `www/routes/api.php` |
| Config | `www/config/religo.php` |
| Migration | `www/database/migrations/*_detach_default_user_owner_member.php` |
| Tests | `www/tests/Support/ReligoSanctumTestHelpers.php`（新規）、`AuthBoundaryHardeningTest.php`（新規）、既存 Feature test の `Sanctum::actingAs` 追記 |
| Docs | `docs/process/phases/PHASE_262_*`、`PHASE_REGISTRY.md`、`dragonfly_progress.md` |

### 変更しない

- owner クエリ改ざんのサーバ固定（Phase B）
- route model owner 403 検証（Phase B）
- `religo.chapter_admin` の管理 API 拡張（Phase C）
- React UI / Owner selector（Phase D）
- `www/resources/js/**`（本 Phase では API 境界のみ。フロントは既存ログイン前提）

### 認証不要のまま残す route

| Route | 理由 |
|-------|------|
| `POST /api/auth/login` 等 | 認証入口 |
| `GET /api/zoom/callback` | Zoom OAuth リダイレクト |
| `POST /api/zoom/webhook` | Zoom Webhook |
| `GET /api/dragonfly/meetings/{number}/attendees` 等 breakout 系 | レガシー接続画面（別途 Phase で sanctum 化検討） |
| `GET /api/debug/dashboard-summary` | local のみ |

---

## DoD

- [ ] `config('religo.acting_user_fallback')` のデフォルトが `false`
- [ ] migration 実行後、`Default` ユーザー（id=1, `default@religo.local`）の `owner_member_id` が `null`
- [ ] owner スコープ系 API（`one-to-ones`、`contact-memos`、`dashboard/*`、`users/me`、`introductions` 等）が未認証で **401**
- [ ] 認証済みユーザーは従来どおり各 API を利用可能（既存 Feature test 更新後 pass）
- [ ] `AuthBoundaryHardeningTest` で主要 route の 401 を検証
- [ ] `php artisan test` 全 pass
- [ ] React 変更なしのため npm build はスキップ可

---

## Tasks

| # | Task | 完了条件 |
|---|------|----------|
| 1 | `religo.php` fallback デフォルト `false` | config / `.env.example` 整合 |
| 2 | Default user migration | `owner_member_id` 解除 |
| 3 | `routes/api.php` sanctum グループ化 | owner / 管理系 route を移動 |
| 4 | `ReligoSanctumTestHelpers` 追加 | テスト用 `Sanctum::actingAs` 共通化 |
| 5 | `AuthBoundaryHardeningTest` 追加 | 未認証 401 |
| 6 | 既存 Feature test 修正 | sanctum 化に伴う `actingAs` 追記 |
| 7 | `php artisan test` | 全 pass |

---

## リスク

- 既存 Feature test の大半が未認証呼び出し前提 → helper 導入で一括修正
- フロントが未ログインで API を叩く箇所があれば 401 になる → 管理画面はログイン前提のため許容

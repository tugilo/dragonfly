# Phase 262 WORKLOG — Auth Boundary Hardening

**tool:** cursor

---

## 2026-06-27 11:11 JST — Phase 開始

- SPEC-020 §11.8 Phase A（順位 1〜2）として着手。
- 次 Phase 番号 262、`feature/phase262-auth-boundary-hardening` を作成。
- owner 固定・role 強制は Phase 263 以降に分離（スコープ逸脱防止）。

## 2026-06-27 11:17 JST — 実装判断

- `config/religo.php` の `acting_user_fallback` デフォルトを `false` に変更。ローカル開発は `.env` で `true` を明示可能。
- `routes/api.php` で owner スコープ系・管理系 API を `auth:sanctum` グループへ移動。breakout 系（`/dragonfly/meetings/{number}/*`）はレガシー接続のため Phase A では公開維持。
- `Default` ユーザー（`default@religo.local`）の `owner_member_id` を解除する migration を追加。
- テストは `ReligoSanctumTestHelpers` を導入し、影響 30 クラスに `Sanctum::actingAs` を付与。`AuthBoundaryHardeningTest` で未認証 401 を検証。
- `php artisan test` — **549 passed**。

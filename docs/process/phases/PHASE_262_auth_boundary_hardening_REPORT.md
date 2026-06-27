# Phase 262 REPORT — Auth Boundary Hardening

**Status:** completed（merge 未実施）  
**Phase Type:** implement  
**Branch:** `feature/phase262-auth-boundary-hardening`  
**Related SSOT:** SPEC-010, SPEC-020 §11.6 順位 1〜2

---

## 実施内容

- `RELIGO_ACTING_USER_FALLBACK` の config デフォルトを `false` に変更
- migration `detach_default_user_owner_member` で `default@religo.local` の個人 owner 紐付けを解除
- `routes/api.php` — owner スコープ系・管理系 Religo API を `auth:sanctum` 配下へ移動（breakout レガシー route は除外）
- `ReligoSanctumTestHelpers` + `AuthBoundaryHardeningTest` 追加
- 既存 Feature test 30 クラスを sanctum 認証対応に更新

---

## DoD チェック

- [x] fallback デフォルト false
- [x] Default user owner 解除 migration
- [x] owner スコープ系 API sanctum 化
- [x] AuthBoundaryHardeningTest
- [x] php artisan test 全 pass（549 passed）

---

## テスト結果

```
php artisan test — 549 passed (2064 assertions)
```

---

## 取り込み証跡（develop への merge 後）

| 項目 | 内容 |
|------|------|
| merge commit id | `902acd5d2012410173bb00a9001414cc4101b87c` |
| source branch | `feature/phase262-auth-boundary-hardening` |
| target branch | develop |
| phase id | 262 |
| phase type | implement |
| related ssot | SPEC-010 / SPEC-020 §11.6 順位 1〜2 |
| test command | `php artisan test` |
| test result | 549 passed (2064 assertions) |
| scope check | OK |
| ssot check | OK |
| dod check | OK |
| 手動確認 | migrate 実行で Default user owner 解除を確認 |

**記録:** 2026-06-27 11:20 JST

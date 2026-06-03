# PLAN: Phase 185 — 1 to 1 予定キャンセル API（POST cancel）

**Phase ID:** 185 / `ONETOONES-CANCEL-API-P1`  
**種別:** implement  
**Related SSOT:** [DATA_MODEL.md](../../SSOT/DATA_MODEL.md) §4.12、[ONETOONES_CANCEL_FIT_AND_GAP.md](../../SSOT/ONETOONES_CANCEL_FIT_AND_GAP.md) §10.1

**前提:** Phase 184（SSOT 確定）merge 済み。

---

## 1. 目的

`POST /api/one-to-ones/{id}/cancel` を実装し、`planned` 行を理由付きで `canceled` にする。`PATCH` 経由の `status=canceled` は拒否する。

---

## 2. スコープ

- migration: `cancel_reason`, `cancel_remark`, `canceled_at`
- `CancelOneToOneRequest`, `OneToOneService::cancel`, `OneToOneController::cancel`
- `UpdateOneToOneRequest`: `status=canceled` 禁止
- `OneToOneIndexService::formatRecord`: 理由フィールド返却
- `routes/api.php`
- Feature tests
- PLAN / WORKLOG / REPORT / PHASE_REGISTRY

**対象外:** UI（Phase 186）、モック（Phase 187）

---

## 3. DoD

- [ ] migration 適用可
- [ ] POST cancel: planned のみ、validation 通過/拒否テスト
- [ ] PATCH `status=canceled` → 422
- [ ] `php artisan test` 通過
- [ ] develop merge + push

---

## 4. モック比較

UI 未実装のため本 Phase では API のみ。Phase 186 でモック比較。

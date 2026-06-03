# PLAN: Phase 184 — 1 to 1 予定キャンセル SSOT 確定（docs）

**Phase ID:** 184 / `ONETOONES-CANCEL-SSOT-P1`  
**種別:** docs  
**Related SSOT:** [ONETOONES_CANCEL_FIT_AND_GAP.md](../../SSOT/ONETOONES_CANCEL_FIT_AND_GAP.md) §10、[DATA_MODEL.md](../../SSOT/DATA_MODEL.md) §4.12、[ONETOONES_DELETE_REQUIREMENTS.md](../../SSOT/ONETOONES_DELETE_REQUIREMENTS.md)

---

## 1. 目的

[ONETOONES_CANCEL_FIT_AND_GAP.md](../../SSOT/ONETOONES_CANCEL_FIT_AND_GAP.md) §10 で合意した **9 件**を、implement Phase 着手前の **DATA_MODEL / 削除ポリシー SSOT** に写す。

---

## 2. スコープ

### 2.1 対象

- `docs/SSOT/ONETOONES_CANCEL_FIT_AND_GAP.md`（調査・合意 SSOT・新規）
- `docs/SSOT/DATA_MODEL.md` §4.12 — キャンセル列・`POST cancel` API
- `docs/SSOT/ONETOONES_DELETE_REQUIREMENTS.md` — §2 拡張（理由付きキャンセル）
- `docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md` §6.9
- `docs/INDEX.md`、`docs/dragonfly_progress.md`
- `docs/process/PHASE_REGISTRY.md`
- PLAN / WORKLOG / REPORT（本 Phase）

### 2.2 対象外

- マイグレーション・API・UI・モック（Phase 185 以降）
- `www/**`

---

## 3. DoD

- [ ] §10.1 の 9 件が `DATA_MODEL` §4.12 に反映されている
- [ ] `ONETOONES_DELETE_REQUIREMENTS` にキャンセル理由・POST cancel・UI 方針が追記されている
- [ ] Fit/Gap SSOT・INDEX・progress・PHASE_REGISTRY が更新されている
- [ ] feature → develop `--no-ff` merge 済み

---

## 4. モック比較

本 Phase は docs のみ。UI 実装 Phase（186）で [MOCK_UI_VERIFICATION.md](../../SSOT/MOCK_UI_VERIFICATION.md) に従う。

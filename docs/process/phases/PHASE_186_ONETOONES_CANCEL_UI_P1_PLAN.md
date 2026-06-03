# PLAN: Phase 186 — 1 to 1 予定キャンセル UI

**Phase ID:** 186 / `ONETOONES-CANCEL-UI-P1`  
**種別:** implement  
**Related SSOT:** ONETOONES_CANCEL_FIT_AND_GAP §10.1

**前提:** Phase 185（POST cancel API）merge 済み。

---

## 1. 目的

一覧から `planned` 行を理由付きでキャンセルする Dialog、Edit から canceled 除外、canceled 行の理由 Chip。

---

## 2. スコープ

- `OneToOnesList.jsx` — Cancel Dialog + 操作列
- `OneToOneFormFields.jsx` — Edit で canceled 選択不可・表示
- `utils/oneToOneCancel.js`
- `npm run build`

**対象外:** モック v2（Phase 187）

---

## 3. DoD

- [ ] planned 行に「キャンセル」→ Dialog → POST cancel
- [ ] canceled 一覧に理由 Chip
- [ ] Edit status から canceled 除外
- [ ] npm run build OK
- [ ] develop merge

---

## 4. モック比較

Phase 187 で mock 更新。本 Phase は実装 UI のみ。

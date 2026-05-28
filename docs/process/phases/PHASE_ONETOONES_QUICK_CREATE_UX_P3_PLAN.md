# PLAN: ONETOONES_QUICK_CREATE_UX_P3 — 一覧 Quick Create を Create / Edit に揃える

**Phase ID:** ONETOONES_QUICK_CREATE_UX_P3  
**種別:** implement（フロント・一覧 Dialog）  
**Related SSOT:** [ONETOONES_CREATE_UX_REQUIREMENTS.md](../../SSOT/ONETOONES_CREATE_UX_REQUIREMENTS.md)、[ONETOONES_QUICK_CREATE_UI_FIT_AND_GAP.md](../../SSOT/ONETOONES_QUICK_CREATE_UI_FIT_AND_GAP.md)、[ONETOONES_EDIT_UI_FIT_AND_GAP.md](../../SSOT/ONETOONES_EDIT_UI_FIT_AND_GAP.md)

---

## 1. 背景

- Create（P1）と Edit（P2）は `OneToOneFormFields` + `buildOneToOnePayload` で共通化済み。
- 一覧の Quick Create Dialog は独自実装のまま残っており、**同じ 1to1 作成でも入口ごとに体験・payload 組み立てが分岐**していた。

---

## 2. 目的

1. Quick Create Dialog を **Create と同じフォーム部品** に揃える。  
2. 送信は **`buildOneToOnePayload` のみ** を正とする。  
3. **Dialog 固有の差分**（Owner 固定・スクロール・閉じる／リセット）を最小限に文書化する。

---

## 3. スコープ

### 3.1 対象

| 領域 | 内容 |
|------|------|
| 実装 | `OneToOnesList.jsx` の `OneToOnesQuickCreateDialog` |
| 共有 | `OneToOneFormFields.jsx`（Quick Create 用オプション props） |
| 共有 | `oneToOnesTransform.js`（`notes` trim 等の共通正規化） |
| SSOT | `ONETOONES_QUICK_CREATE_UI_FIT_AND_GAP.md` 新規 |

### 3.2 対象外

- Dashboard / Leads からの target 自動セット  
- カスタム所要時間  
- 削除方針・一覧の全面リデザイン  
- 無関係な 1to1 API 変更  

---

## 4. 実装方針

- **Create を正**として `mode="create"` の `OneToOneFormFields` を Dialog 内 `Form` に埋め込む。
- **Owner** は一覧フィルタの `owner_member_id` に固定し、`ownerInputDisabled` で変更不可（変更はフィルタで）。
- **submit:** `Form` の `onSubmit` で `buildOneToOnePayload` → `POST /api/one-to-ones`（既存の fetch パターン）。
- 開閉のたび **`formSession` で key を変え Form をリマウント**し、初期値と所要時間をリセット。

---

## 5. DoD

- [x] Quick Create が `OneToOneFormFields` + `buildOneToOnePayload` を使用する  
- [x] `ONETOONES_QUICK_CREATE_UI_FIT_AND_GAP.md` がある  
- [x] PLAN / WORKLOG / REPORT・PHASE_REGISTRY・INDEX・`dragonfly_progress.md` 更新  
- [x] `npm run build`・`php artisan test` 通過  
- [x] `feature/phase-onetoones-quick-create-ux-p3` → `develop` を `--no-ff` mergeし、REPORT に Merge Evidence  

---

## 6. モック比較

- 本 Phase は **一覧のモーダル体験の内部統一**が主目的。モック差分の追記は必要に応じて [FIT_AND_GAP_MOCK_VS_UI.md](../../SSOT/FIT_AND_GAP_MOCK_VS_UI.md) §6 の運用に従う。

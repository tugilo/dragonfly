# PLAN: ONETOONES-DELETE-POLICY-P1 — 1 to 1 削除しない方針の固定（`canceled` 正規運用化）

**Phase ID:** ONETOONES-DELETE-POLICY-P1  
**種別:** implement（SSOT + 最小 UI）  
**Related SSOT:** `docs/SSOT/ONETOONES_DELETE_REQUIREMENTS.md`、`docs/SSOT/DATA_MODEL.md` §4.12、`docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md` §6、`docs/process/ONETOONES_P1_P4_SUMMARY.md`

---

## 1. 目的

1 to 1 に対して **「削除は実装しない」** を **製品方針**として SSOT・UI に明文化し、**`status = canceled`** を **正規の業務状態**として固定する。

---

## 2. 背景・確定事項

- `DELETE /api/one-to-ones/{id}` は未実装。モックにも削除なし。
- `canceled` は既存。物理削除は `contact_memos`・集計・Activity の意味を変える。
- **方針:** 履歴を残す意味を優先し、削除は採用しない。

---

## 3. スコープ

### 3.1 対象

- SSOT: `ONETOONES_DELETE_REQUIREMENTS.md` の全面更新（方針確定版）
- `DATA_MODEL.md` §4.12: 削除ポリシー・`status` 説明の追記
- `FIT_AND_GAP_MOCK_VS_UI.md` §6.8 更新
- `ONETOONES_P1_P4_SUMMARY.md` 追記
- API: `GET /api/one-to-ones`（および stats）に **`exclude_canceled`** クエリ（`status` 未指定時に `canceled` を除く）
- UI: 一覧の **既定フィルタ**・**BooleanInput**・**説明文言**、編集の **状態** `helperText`
- テスト: `OneToOneIndexTest` に `exclude_canceled` ケース
- PLAN / WORKLOG / REPORT、PHASE_REGISTRY、INDEX、dragonfly_progress

### 3.2 対象外

- DELETE API・`deleted_at`・contact_memos 削除設計・無関係な 1to1 UI 大改修

---

## 4. UI 方針（採用）

- **案 B 相当:** 既定で **キャンセル行を一覧から除く**（フィルタで戻せる）。
- **案 C 相当:** 一覧サブタイトル・編集の `helperText` で **削除しない・`canceled` の意味**を明示。

---

## 5. DoD

- [ ] SSOT に「削除しない」「`canceled` の意味」が明記されている
- [ ] `exclude_canceled` が API・dataProvider・一覧 stats クエリで一貫
- [ ] 一覧・編集の文言が方針に沿う
- [ ] `php artisan test`・`npm run build` 通過
- [ ] PLAN / WORKLOG / REPORT・REGISTRY・INDEX・progress 更新
- [ ] `feature/phase-onetoones-delete-policy-p1` → `develop` merge（--no-ff）・REPORT Merge Evidence・push

---

## 6. モック比較

- 参照: `docs/SSOT/MOCK_UI_VERIFICATION.md`（ルート `#/one-to-ones`）
- 差分は本 Phase では **方針文言・フィルタ既定**に限定。`FIT_AND_GAP` §6 を更新済みとする。

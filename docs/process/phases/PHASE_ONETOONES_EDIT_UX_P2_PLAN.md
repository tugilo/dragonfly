# PLAN: ONETOONES_EDIT_UX_P2 — 1 to 1 Edit 画面を Create UX に揃える

**Phase ID:** ONETOONES_EDIT_UX_P2  
**種別:** implement（フロント共有フォーム・送信正規化）  
**Related SSOT:** [ONETOONES_CREATE_UX_REQUIREMENTS.md](../../SSOT/ONETOONES_CREATE_UX_REQUIREMENTS.md)、[ONETOONES_EDIT_UI_FIT_AND_GAP.md](../../SSOT/ONETOONES_EDIT_UI_FIT_AND_GAP.md)

---

## 1. 背景

- **Create**（`/one-to-ones/create`）は ONETOONES_CREATE_UX_P1 以降、相手サマリ・所要時間チップ・例会 Autocomplete・`transform` による日時 ISO 化が揃っている。
- **Edit** は [ONETOONES_EDIT_UI_FIT_AND_GAP.md](../../SSOT/ONETOONES_EDIT_UI_FIT_AND_GAP.md) の調査時点で、同じ体験になっておらず、判断・入力・保存の一貫性が欠けていた。
- **Create を正（SSOT）**とし、Edit を同一コンポーネント・同一ペイロード規則に寄せる。

---

## 2. 目的

1. Edit で **相手サマリ**（`TargetMemberSummaryCard` 相当）を表示する。
2. Edit で **日時 UX** を Create と同型（開始予定＋30/60/90 分・終了予定プレビュー）にし、**実施済み**のときのみ **実績** `started_at` / `ended_at` を追加表示する。
3. Edit の例会を **NumberInput** から **`OneToOneMeetingReferenceInput`** に置き換える。
4. **Create / Edit 共通**の `buildOneToOnePayload`（`oneToOnesTransform.js`）で送信内容を正規化する。
5. **EditContextHeader** は `TargetMemberSummaryCard` と役割が重なるため削除し、情報の単一化とする。

---

## 3. スコープ

### 3.1 対象

| 領域 | 内容 |
|------|------|
| 新規 | `www/resources/js/admin/utils/oneToOnesTransform.js` |
| 新規 | `www/resources/js/admin/pages/OneToOneFormFields.jsx`（`mode: 'create' \| 'edit'`） |
| 変更 | `OneToOnesCreate.jsx` — `OneToOneFormFields` + `buildOneToOnePayload` |
| 変更 | `OneToOnesEdit.jsx` — `EditDurationInitializer`、`OneToOneFormFields`、`SimpleForm` の `transform`、履歴メモ維持 |
| SSOT | `ONETOONES_EDIT_UI_FIT_AND_GAP.md` §8（P2 実装済み） |

### 3.2 対象外

- 一覧の **Quick Create Dialog** の全面統一（別 Phase）
- **Dashboard / Leads** からの `target_member_id` 自動セット（別 Phase）
- **所要時間の任意分数**（カスタム duration）（別 Phase）
- **Delete** 方針・API の変更
- **dataProvider.js** の必須変更（`transform` で正規化済みなら現行の PATCH body で可）

---

## 4. 実装方針

- **共通コンポーネント:** `OneToOneFormFields` に Owner / 相手 / サマリ / 状態 / スケジュール /（Edit かつ completed のみ実績）/ 例会 / メモを集約。
- **モード差分:** `mode === 'edit'` かつ `status === 'completed'` のときだけ「実績」ブロックを表示。
- **ペイロード:** `buildOneToOnePayload(data, durationMinutes, { mode, workspaceId })`  
  - **create:** `workspace_id`・`started_at: null`・所要から `ended_at`。  
  - **edit:** `planned`/`canceled` は `started_at: null` と所要から `ended_at`。**completed** はフォームの実績 `started_at`/`ended_at` を ISO で送り、所要時間で `ended_at` を上書きしない。
- **所要時間の初期値（Edit）:** `inferDurationMinutes`（completed はデフォルト 60 分寄りに簡略化可）。

---

## 5. DoD

- [x] Edit に相手サマリ・所要チップ・例会 Autocomplete・`SimpleForm` の `transform` がある
- [x] Create と Edit が `buildOneToOnePayload` を共有する
- [x] `npm run build` 成功
- [x] `php artisan test` 全件通過（328 tests 相当を維持）
- [x] PLAN / WORKLOG / REPORT・PHASE_REGISTRY・INDEX・`dragonfly_progress.md` 更新
- [x] `feature/phase-onetoones-edit-ux-p2` → `develop` を `--no-ff` で mergeし、REPORT に Merge Evidence を記録

---

## 6. モック比較

- 本 Phase は **Edit 画面の内部 UX 統一**が主目的。モック差分の追記は [FIT_AND_GAP_MOCK_VS_UI.md](../../SSOT/FIT_AND_GAP_MOCK_VS_UI.md) §6 の運用に従い、必要なら follow-up で更新する。

# WORKLOG: ONETOONES_QUICK_CREATE_UX_P3

**Phase ID:** ONETOONES_QUICK_CREATE_UX_P3  
**ブランチ:** `feature/phase-onetoones-quick-create-ux-p3`

---

## Step 1 — 現状調査（Quick Create）

- **実装箇所:** `www/resources/js/admin/pages/OneToOnesList.jsx` 内 `OneToOnesQuickCreateDialog`（`List` の子として `Toolbar` の「＋ 1to1を追加」から開く）。
- **旧実装:** ローカル `useState`（相手・状態・`scheduledAt`・所要・メモ・`meetingRecord`）+ MUI `Autocomplete` 2 本 + `fetch` POST。
- **POST body:** 手組みで `scheduled_at` / `ended_at` を組み立て、`meeting_id` は `meetingRecord?.id`。
- **Create / Edit との差分:** Create/Edit は `OneToOneFormFields` + `buildOneToOnePayload`。Quick Create は **同一 SSOT 外**で二重実装だった。

---

## Step 2 — Fit & Gap SSOT

- `docs/SSOT/ONETOONES_QUICK_CREATE_UI_FIT_AND_GAP.md` を新規作成。比較基準は [ONETOONES_CREATE_UX_REQUIREMENTS.md](../../SSOT/ONETOONES_CREATE_UX_REQUIREMENTS.md) と P2 済み Create/Edit 実装。

---

## Step 3 — 共通化の判断

- **フォーム:** react-admin の `Form` + `OneToOneFormFields`（`mode="create"`）。`ReferenceInput`（例会）は `List` 配下で `dataProvider` が効くためそのまま利用。
- **Owner 固定:** 一覧の `owner_member_id` に合わせる要件は維持。`OneToOneFormFields` に `suppressCreateOwnerHint`・`ownerInputDisabled` を追加し、Create ページの Dashboard 向け説明を Dialog では出さない／Owner を無効化。
- **payload:** `buildOneToOnePayload(data, durationMinutes, { mode: 'create', workspaceId })` のみ。所要時間は `OneToOneCreateScheduleFields` と同じ親 state。
- **notes:** `buildOneToOnePayload` 内で trim し空文字を null に統一（Create/Edit/Quick 共通）。

---

## Step 4 — Dialog 固有差分

- `maxWidth="md"`・`DialogContent` の `maxHeight` + `overflowY` でスクロール。
- `DialogTitle` に Owner の説明（一覧フィルタと一致）を残す。
- 開くたび `formSession` をインクリメントして `Form` の `key` を変え、初期値と `durationMinutes` をリセット。
- 成功時: `notify`・`refresh()`・`onClose()`。失敗時: `notify` + インライン `error`。
- ワークスペース取得失敗時: エラー文言 + 「閉じる」のみ。

---

## Step 5 — 変更ファイル

| ファイル | 内容 |
|----------|------|
| `OneToOnesList.jsx` | Quick Create を `Form` + `OneToOneFormFields` + `buildOneToOnePayload` に差し替え。未使用 import 削除。 |
| `OneToOneFormFields.jsx` | `suppressCreateOwnerHint`・`ownerInputDisabled` |
| `oneToOnesTransform.js` | `notes` の trim 正規化 |
| `docs/SSOT/ONETOONES_QUICK_CREATE_UI_FIT_AND_GAP.md` | 新規 |
| process / INDEX / REGISTRY / `dragonfly_progress.md` | 更新 |

---

## Step 6 — 検証

| コマンド | 結果 |
|----------|------|
| `docker compose ... exec node npm run build` | 成功 |
| `docker compose ... exec app php artisan test` | 328 passed |

---

## Step 7 — merge

- **競合:** なし。
- **merge commit id:** `701378161a55d3bddeff5ce8e888100eb3da0ee4`（`Merge feature/phase-onetoones-quick-create-ux-p3 into develop`）。
- **feature tip:** `bd0b7bdd4b07b5f378daf04b49c48cd85e54d8d2`。

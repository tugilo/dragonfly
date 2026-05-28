# WORKLOG: ONETOONES_EDIT_UX_P2

**Phase ID:** ONETOONES_EDIT_UX_P2  
**ブランチ:** `feature/phase-onetoones-edit-ux-p2`

---

## Step 1 — 方針の固定（Create を正とする理由）

- Religo 管理画面では **新規登録（Create）の導線**が製品メッセージ・SSOT（[ONETOONES_CREATE_UX_REQUIREMENTS.md](../../SSOT/ONETOONES_CREATE_UX_REQUIREMENTS.md)）で最も先に整備された。
- Edit は同じ `one_to_ones` レコードを触るため、**同じ判断材料（相手サマリ）・同じ入力負荷（日時・例会）・同じ保存規則（日時 ISO・ended の一貫性）**がないと、運用・サポート・バグの再発点が増える。
- よって **Create の実装と文言を正**とし、Edit を **共有コンポーネント＋共有 transform** で追従させる判断とした。

---

## Step 2 — Fit & Gap の差分をどう解消したか

| Gap（調査 SSOT） | 対応 |
|------------------|------|
| 相手サマリ未表示 | `OneToOneFormFields` 内で `TargetMemberSummaryCard` を Create/Edit 共通利用。 |
| 日時が 3 つの DateTimeInput のみ | `OneToOneCreateScheduleFields` を Edit にも配置。`status === 'completed'` のときだけ「実績」として `started_at`/`ended_at` を追加。 |
| Meeting が NumberInput | `OneToOneMeetingReferenceInput` に統一。 |
| PATCH に正規化なし | `SimpleForm` の `transform` で `buildOneToOnePayload(..., { mode: 'edit' })` を通す。 |
| メモ文言の差 | `OneToOneFormFields` で `mode` に応じた `helperText`（Edit は履歴メモへの言及を維持）。 |

---

## Step 3 — `status === 'completed'` の扱い

- **planned / canceled:** 予定どおり `scheduled_at` を ISO 化し、所要時間から `ended_at` を算出。`started_at` は送信時に **null**（実績をクリアする意図に合わせる）。
- **completed:** 「実績」ブロックの `started_at` / `ended_at` を **ユーザ入力の正**とし、`buildOneToOnePayload` 内で所要時間による `ended_at` 上書きをしない。

---

## Step 4 — `EditContextHeader` を削除した理由

- 調査時点では相手名＋日時の一行表示のみだったが、**相手サマリカード**が氏名・カテゴリ・役職まで出すため、ヘッダと内容が重複する。
- Create 側に相当するヘッダがないため、**Edit もカード＋フォームに一本化**し、情報の出所を単純化した。

---

## Step 5 — 変更ファイル（実装）

| ファイル | 内容 |
|----------|------|
| `www/resources/js/admin/utils/oneToOnesTransform.js` | 新規。`normalizeMeetingId`、`inferDurationMinutes`、`buildOneToOnePayload`。 |
| `www/resources/js/admin/pages/OneToOneFormFields.jsx` | 新規。`OneToOneFormFields`（`mode`・所要・実績条件分岐）。 |
| `www/resources/js/admin/pages/OneToOnesCreate.jsx` | `OneToOneFormFields` + `buildOneToOnePayload` に集約。 |
| `www/resources/js/admin/pages/OneToOnesEdit.jsx` | `EditDurationInitializer`、`OneToOneFormFields`、`SimpleForm transform`、履歴メモ。ヘッダ削除。 |
| `docs/SSOT/ONETOONES_EDIT_UI_FIT_AND_GAP.md` | §8 追記（P2 実装済みの要約）。 |

---

## Step 6 — 検証

| コマンド | 結果 |
|----------|------|
| `docker compose ... exec node npm run build` | 成功 |
| `docker compose ... exec app php artisan test` | 328 passed（1310 assertions） |

---

## Step 7 — merge 作業

- **競合:** なし（`develop` から `feature/phase-onetoones-edit-ux-p2` を切り、文書・実装をコミット後 `merge --no-ff`）。
- **merge commit id:** `c1e52601c1e2bb97f6c29b138e21d567b64ed001`（`Merge feature/phase-onetoones-edit-ux-p2 into develop`）。
- **feature tip:** `a1f7d0687094c8971be31127060998b0f3fde4c5`。
- **取り込み後:** REPORT §8 に証跡を確定し、追記コミットで `origin/develop` に push。

---

## Step 8 — ドキュメント整備（本フェーズの主作業）

- 本 WORKLOG と PLAN / REPORT を追加。
- `PHASE_REGISTRY.md`・`docs/INDEX.md`・`docs/dragonfly_progress.md` を更新。
- [ONETOONES_CREATE_UX_REQUIREMENTS.md](../../SSOT/ONETOONES_CREATE_UX_REQUIREMENTS.md) は必要に応じて **Edit 追随済みの一文**のみ整合（要件の拡大はしない）。

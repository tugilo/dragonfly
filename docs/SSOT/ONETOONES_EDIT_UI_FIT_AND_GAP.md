# 1 to 1 Edit 画面 — Create との Fit & Gap（調査 SSOT）

**Phase:** `ONETOONES_EDIT_UI_FIT_AND_GAP`  
**作成日:** 2026-03-24  
**種別:** 当初は調査のみ。**ONETOONES_EDIT_UX_P2（2026-03-24）** で主 Gap を解消済み（§8）。  
**基準（正）:** [ONETOONES_CREATE_UX_REQUIREMENTS.md](ONETOONES_CREATE_UX_REQUIREMENTS.md) および **Create**（`OneToOnesCreate.jsx`）

**関連:** [DATA_MODEL.md](DATA_MODEL.md) §4.9（`one_to_ones`）、Create SSOT §4（Edit / Dialog 追随の推奨）

> **P2 後の状態:** 相手サマリ・所要時間チップ・例会 Autocomplete・`buildOneToOnePayload` 共通化は Edit に反映済み。以下 §1〜§5 は **調査時点の記録**として残す。

---

## 1. サマリ

| 項目 | 内容 |
|------|------|
| **Create との整合度** | **Medium** — Owner/相手の検索 UI は共通化済み。日時・例会・相手サマリ・submit 正規化は Create と未整合。 |
| **主な Gap（優先度順）** | 1. **相手サマリカード未表示**（`TargetMemberSummaryCard` なし）— High  <br> 2. **日時 UX** — Create は「開始予定＋所要時間チップ」、Edit は **3 つの DateTimeInput** — High  <br> 3. **例会** — Create は `ReferenceInput` + `AutocompleteInput`、Edit は **`NumberInput`（Meeting ID）** — High  <br> 4. **PATCH 時の日時正規化なし** — Create の `transform`（ISO 化・`ended_at` 自動）に相当する処理が Edit 経路にない — Medium  <br> 5. **メモラベル・ヘルパー文言** — Create と表記が異なる — Low |

---

## 2. Fit 一覧

| 項目 | 内容 |
|------|------|
| **Owner 選択** | `MemberSearchAutocompleteInput` + `GET /api/dragonfly/members` 由来の `ownerMemberOptions`。Create と同コンポーネント。 |
| **相手（target）選択** | `OwnerScopedTargetSelect`（`OwnerScopedTargetSelect` → `ScopedTargetSelect` 内 `MemberSearchAutocompleteInput`）。Create と同じ。 |
| **相手の再取得** | 相手変更時に `GET /api/dragonfly/members?owner_member_id=` で候補を再読込（Create と同一）。 |
| **状態（status）** | `SelectInput` + `STATUS_CHOICES`（予定 / 実施済み / キャンセル）。Create と同系。 |
| **一覧戻る** | `ListButton` + Toolbar（文言のみ「一覧に戻る」vs「一覧へ戻る」の差）。 |
| **Edit 固有の付加価値** | `EditContextHeader`（相手名・日時一行）、`OneToOneMemosPanel`（履歴メモ）。Create にはない。 |

---

## 3. Gap 一覧

| 項目 | Gap 内容 | 影響 | 優先度 |
|------|----------|------|--------|
| **相手サマリ** | Edit は `TargetMemberSummaryCard` を**未使用**。カテゴリ・役職などの **GET `/api/dragonfly/members/{id}` サマリ**がフォーム内に出ない。 | 登録前の文脈確認は Create より劣る。 | **High** |
| **日時 UX** | Create は `OneToOneCreateScheduleFields`（**開始予定 1 本 + 30/60/90 分チップ + 終了予定プレビュー**）。Edit は **`scheduled_at` / `started_at` / `ended_at` を各 `DateTimeInput` で手入力**。 | 運用・学習コストの不一致。Create SSOT の「予定登録フローでは実績を主にさせない」方針と編集画面の役割が未整理。 | **High** |
| **Meeting** | Create は `OneToOneMeetingReferenceInput`（**`ReferenceInput` + `AutocompleteInput`**、ラベルは第 N 回 / 日付 / 名称）。Edit は **`NumberInput`（Meeting ID）** のまま。 | 誤 ID・検索不可。Create と同要件の「直打ちしない」に未達。 | **High** |
| **transform / PATCH** | Create は `transform` で `scheduled_at`/`ended_at` を **ISO 正規化**、`started_at` を **null**、所要時間から `ended_at` を算出。Edit は **`react-admin` の `dataProvider.update` が素の JSON**（`dataProvider.js` の `body`）。 | ブラウザ・PHP の日時解釈ズレの再発防止が Edit では無い。更新時に `ended_at` 自動再計算も無い。 | **Medium** |
| **メモ** | `label` / `helperText` が Create（「この1to1の記録・目的・アジェンダ」等）と**異なる**。 | 一貫性・ヘルプ理解。 | **Low** |
| **編集時ヘッダ** | `EditContextHeader` は相手名のみ（`target_name`）。**`TargetMemberSummaryCard` 相当の詳細はなし**。 | サマリ Gap と重複。 | **Low** |

---

## 4. 実装差分の詳細

### 4.1 相手選択 UX

| | Create | Edit |
|---|--------|------|
| **コンポーネント** | `OwnerScopedTargetSelect` の直後に **`TargetMemberSummaryCard`** | `OwnerScopedTargetSelect` のみ（サマリなし） |
| **サマリ表示** | `FormDataConsumer` + `TargetMemberSummaryById`（`GET /api/dragonfly/members/{id}`） | なし（`EditContextHeader` は一覧 API の `target_name` のみ） |

**Create 側（参照）:**

```157:159:www/resources/js/admin/pages/OneToOnesCreate.jsx
                <OwnerScopedTargetSelect />
                <TargetMemberSummaryCard />
                <SelectInput source="status" choices={STATUS_CHOICES} label="状態" />
```

**Edit 側（現状）:**

```205:206:www/resources/js/admin/pages/OneToOnesEdit.jsx
                <OwnerScopedTargetSelect />
                <SelectInput
```

**修正方針（案・P2）:** Edit の `OwnerScopedTargetSelect` 直下に **`TargetMemberSummaryCard`** を追加（同一 import で可）。Create SSOT §3.1 と一致。

---

### 4.2 日時 UX

| | Create | Edit |
|---|--------|------|
| **UI** | `OneToOneCreateScheduleFields`（`scheduled_at` + `duration` チップ + 終了プレビュー） | `DateTimeInput` ×3：`scheduled_at` / `started_at` / `ended_at` |
| **ended_at** | `transform` 内で `scheduled_at` + 分で算出 | ユーザー入力 |
| **started_at** | 新規は `null` に固定（`transform`） | 既存値の編集・表示あり |

**Edit 側（現状）:**

```212:214:www/resources/js/admin/pages/OneToOnesEdit.jsx
                <DateTimeInput source="scheduled_at" label="予定日時" />
                <DateTimeInput source="started_at" label="開始日時" />
                <DateTimeInput source="ended_at" label="終了日時" />
```

**修正方針（案・P2）:**

- **案 A:** 予定系（`planned`）は Create と同じ **スケジュール＋所要** を表示し、実績（`started_at`/`ended_at`）は折りたたみ「実績を入力」または `status === 'completed'` 時のみ表示（Create SSOT §3.2 の「編集は別扱い」に合わせる）。
- **案 B:** Edit は「実績修正」が主目的として **3 フィールド維持**とし、Create との差は**ドキュメント化のみ**（Fit を上げない）。

---

### 4.3 Meeting 選択 UX

| | Create | Edit |
|---|--------|------|
| **コンポーネント** | `OneToOneMeetingReferenceInput` | `NumberInput` + `meeting_id` |

**Create 側（参照）:**

```160:161:www/resources/js/admin/pages/OneToOnesCreate.jsx
                <OneToOneCreateScheduleFields duration={durationMinutes} onDurationChange={setDurationMinutes} />
                <OneToOneMeetingReferenceInput />
```

**Edit 側（現状）:**

```215:215:www/resources/js/admin/pages/OneToOnesEdit.jsx
                <NumberInput source="meeting_id" label="Meeting ID（任意）" emptyText="—" />
```

**修正方針（案・P2）:** Edit でも **`OneToOneMeetingReferenceInput`** を共有。初期値は `GET /api/one-to-ones/:id` の `meeting_id` を `ReferenceInput` の `reference` レコード解決で表示（`dataProvider.getOne('meetings', id)` が既にある場合はそれに合わせる）。

---

### 4.4 フォーム構造

| | Create | Edit |
|---|--------|------|
| **共有** | `OneToOnesFormParts.jsx` の `MemberSearchAutocompleteInput`、`OwnerScopedTargetSelect`、`OneToOneCreateScheduleFields`、`OneToOneMeetingReferenceInput`、`TargetMemberSummaryCard` | Edit は **`MemberSearchAutocompleteInput` + `OwnerScopedTargetSelect` のみ**共有。日時・例会・サマリは未共有。 |
| **Edit 固有** | — | `EditContextHeader`、`OneToOneMemosPanel` |

**修正方針（案）:** 日時・例会・サマリを **FormParts または 1 つの「OneToOneFormFields」** に切り出し、Create/Edit で `mode=create|edit` または props で差分（実績フィールドの有無）。

---

### 4.5 transform / submit

**Create（`transform`）** — `scheduled_at` / `ended_at` の ISO 化、`started_at: null`、`meeting_id` の数値化・オブジェクト unwrap。

**Edit** — `react-admin` `<Edit>` に **`transform` なし**。`dataProvider.update` がそのまま PATCH:

```215:225:www/resources/js/admin/dataProvider.js
        if (resource === 'one-to-ones') {
            const body = {
                owner_member_id: params.data?.owner_member_id,
                target_member_id: params.data?.target_member_id,
                meeting_id: params.data?.meeting_id ?? null,
                status: params.data?.status,
                scheduled_at: params.data?.scheduled_at,
                started_at: params.data?.started_at,
                ended_at: params.data?.ended_at,
                notes: params.data?.notes ?? null,
            };
```

**修正方針（案・P2）:**

- **案 A:** `Edit` に `transform` を追加し、Create と同様の **ISO 正規化**、`meeting_id` の object 対応を共通化。
- **案 B:** 共通化関数を `oneToOnesSubmitPayload.js` 等に切り出し、Create `transform` と `dataProvider.update` の両方から呼ぶ。

---

## 5. 次 Phase への入力（P2 想定）

| 項目 | 内容 |
|------|------|
| **必須寄り** | `TargetMemberSummaryCard` を Edit に追加。`OneToOneMeetingReferenceInput` で `NumberInput` を置換。 |
| **要検討** | 日時の「Create との同型」— `planned` 中心の編集と `completed` の実績編集の **2 段 UI** か、現状 3 フィールド維持か（業務確認）。 |
| **共通化** | `transform` / PATCH body 生成の **共有**・`OneToOneCreateScheduleFields` の Edit 再利用可否。 |
| **リスク** | 既存データの `scheduled_at` のみ・`started_at`/`ended_at` 片方のみ等。UI 変更時は **バリデーション**（`UpdateOneToOneRequest`）と一覧の **EffectiveDate** 表示との整合を確認。 |

---

## 6. 注意事項

- 本ドキュメント §1〜§5 は **調査時点のソースに基づく**。[ONETOONES_CREATE_UX_REQUIREMENTS.md](ONETOONES_CREATE_UX_REQUIREMENTS.md) と矛盾しないよう **Create を UX 正**とする。
- **実装**は §8 の **ONETOONES_EDIT_UX_P2** を参照。

---

## 7. 変更履歴

| 日付 | 内容 |
|------|------|
| 2026-03-24 | 初版（Edit vs Create 実装調査、Fit/Gap 整理） |
| 2026-03-24 | §8 追加（ONETOONES_EDIT_UX_P2 実装反映） |

---

## 8. ONETOONES_EDIT_UX_P2（実装済み）

**目的:** Edit を Create と同一のフォーム部品・送信正規化に揃える。

| ファイル | 内容 |
|----------|------|
| `www/resources/js/admin/utils/oneToOnesTransform.js` | `normalizeMeetingId` / `inferDurationMinutes` / `buildOneToOnePayload`（`mode: 'create' \| 'edit'`）。 |
| `www/resources/js/admin/pages/OneToOneFormFields.jsx` | Owner / 相手 / `TargetMemberSummaryCard` / 状態 / `OneToOneCreateScheduleFields` / `status===completed` 時のみ実績 `started_at`・`ended_at` / `OneToOneMeetingReferenceInput` / メモ。 |
| `www/resources/js/admin/pages/OneToOnesCreate.jsx` | `OneToOneFormFields` + `buildOneToOnePayload`（create）。 |
| `www/resources/js/admin/pages/OneToOnesEdit.jsx` | `EditDurationInitializer`（所要チップ初期化）+ `OneToOneFormFields` + `SimpleForm` の `transform` + 履歴メモ。`EditContextHeader` は削除（サマリカードに集約）。 |

**挙動メモ:**

- **planned / canceled:** 予定どおり `scheduled_at` + 所要時間から `ended_at` を算出。`started_at` は PATCH で null（実績クリア）。
- **completed:** `started_at` / `ended_at` はフォーム「実績」から ISO 送信。`ended_at` は所要時間の自動計算で上書きしない。
- **所要時間**の初期値: レコードの `scheduled_at`/`ended_at` から推定（`completed` は 60 分デフォルト）。

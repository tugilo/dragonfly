# 1 to 1 予定キャンセル — Fit & Gap / 要件整理（調査 SSOT）

**調査日:** 2026-06-03 21:32 JST  
**合意確定:** 2026-06-03 21:34 JST（UX 4 件）・**2026-06-03 22:17 JST（技術 5 件・§10 全確定）**  
**ステータス:** **要件・設計合意済み** — implement Phase 着手可（**実装未着手**）  
**起点:** ユーザー要望 — 「121（1 to 1）の予定を削除できるようにしたい。こちら都合 / 相手都合 / その他（備考付き）で削除したい」

**関連:** [ONETOONES_DELETE_REQUIREMENTS.md](ONETOONES_DELETE_REQUIREMENTS.md)、[DATA_MODEL.md](DATA_MODEL.md) §4.12、[FIT_AND_GAP_MOCK_VS_UI.md](FIT_AND_GAP_MOCK_VS_UI.md) §6.8、[MEETINGS_DELETE_FIT_AND_GAP.md](MEETINGS_DELETE_FIT_AND_GAP.md)（Meetings 削除調査の体裁参考）

---

## 1. 用語の整理（本ドキュメントの前提）

| ユーザー表現 | 本 SSOT での解釈 | 備考 |
|--------------|------------------|------|
| **削除** | **`status = canceled` による予定の無効化** | 物理 DELETE ではない。[ONETOONES_DELETE_REQUIREMENTS.md](ONETOONES_DELETE_REQUIREMENTS.md) の製品方針と **矛盾させない**。 |
| **121 / 1 to 1 予定** | `one_to_ones.status = planned` の行 | 実施済み（`completed`）の「取り消し」は **別論点**（§5.3）。 |
| **こちら都合 / 相手都合 / その他** | **キャンセル理由**（構造化フィールドとして新設を推奨） | 現状 DB に該当列なし。 |

**UI 文言の推奨:** ボタン・ダイアログは **「削除」ではなく「キャンセル」** と表記し、helper で「レコードは履歴として残ります」と明示する（DELETE-POLICY-P1 と整合）。

---

## 2. 調査目的

1. **予定中の 1 to 1 を、理由付きで手早く無効化**したいという要望を、既存の **`canceled` 正規運用**と両立させる。
2. モック・SSOT・API・UI の **現状（Fit）** と **不足（Gap）** を整理し、実装 Phase の判断材料を残す。
3. キャンセル理由の **保存先・列挙値・UX・集計影響** を実装前に決める。

---

## 3. 確認した資料・実装

### 3.1 SSOT / Docs

| 資料 | キャンセル関連の内容 |
|------|----------------------|
| [ONETOONES_DELETE_REQUIREMENTS.md](ONETOONES_DELETE_REQUIREMENTS.md) | **物理削除不採用**。無効化は **`status = canceled`**。誤登録・重複は当面 `canceled` + `notes`。 |
| [DATA_MODEL.md](DATA_MODEL.md) §4.12 | `status`: planned / completed / canceled。**キャンセル理由列は未定義**。`notes` は「その回で話した内容」。 |
| [FIT_AND_GAP_MOCK_VS_UI.md](FIT_AND_GAP_MOCK_VS_UI.md) §6.8 | 削除 API/UI なし。一覧は **`exclude_canceled` 既定 ON**。 |
| [ONETOONES_EDIT_UI_FIT_AND_GAP.md](ONETOONES_EDIT_UI_FIT_AND_GAP.md) | Edit に `status` Select と canceled 方針 helperText。**専用キャンセル導線の Gap 記載なし**（本書で補完）。 |

### 3.2 モック（`religo-admin-mock-v2.html` `#/one-to-ones`）

| 観点 | 内容 |
|------|------|
| ステータス | フィルタに `planned` / `completed` / `canceled`。stats に「キャンセル（今月）」カードあり。 |
| 削除・キャンセル導線 | **一覧 Actions に削除・キャンセルボタンなし**（編集・メモ相当のみ）。 |
| 理由の例 | サンプルデータ id=9: `status=canceled`, `notes="現場の都合でキャンセル。来月再調整。"` — **理由は notes 自由文のみ**。 |

**Fit:** 実装もモックも **専用キャンセル UI は無い**。  
**Gap（要件）:** ユーザー要望の **構造化理由（こちら都合 / 相手都合 / その他＋備考）** はモックにも SSOT にも **未定義**。

### 3.3 実装（API / DB / UI）

| 対象 | 結果 |
|------|------|
| **DB** `one_to_ones` | `status`, `notes`, 日時列のみ。**`cancel_reason` / `cancel_remark` / `canceled_at` 等なし**（migration `2026_03_04_100004`）。 |
| **API** | `PATCH /api/one-to-ones/{id}` で `status` を `canceled` に変更可能（`UpdateOneToOneRequest`）。**専用 cancel エンドポイントなし**。 |
| **一覧** `OneToOnesList.jsx` | 操作列: **📝 メモ**・**✏️ 編集** のみ。**キャンセル導線なし**。既定 `exclude_canceled: true`。 |
| **編集** `OneToOnesEdit.jsx` | `SelectInput` で状態を「キャンセル」に変更可能。helper: 「レコードの削除は行いません」。**理由入力 UI なし**。 |
| **集計** | `OneToOneStatsService`: `canceled_this_month_count`。`MemberOneToOneLeadService`: **`planned` / `canceled` は実施件数に含めない**（現状どおりでよい）。 |
| **Dashboard** | `one_to_one_canceled_count` 等。**理由別集計なし**。 |

---

## 4. ユーザー要件（整理）

### 4.1 機能要件（Must）

| # | 要件 | 備考 |
|---|------|------|
| R1 | **予定中（`planned`）の 1 to 1 を、一覧または詳細からキャンセルできる** | 「削除」ではなく **キャンセル操作**として提供。 |
| R2 | キャンセル時に **理由を必ず選ぶ**: **こちら都合** / **相手都合** / **その他** | 3 択。ラベルは UI 日本語、DB/API は列挙値（§6.1 案）。 |
| R3 | **その他** 選択時は **備考（自由文）を必須** | こちら都合・相手都合は備考 **任意**（推奨・要合意）。 |
| R4 | キャンセル後は **`status = canceled`** とし、**行は物理削除しない** | [ONETOONES_DELETE_REQUIREMENTS.md](ONETOONES_DELETE_REQUIREMENTS.md) 遵守。 |
| R5 | キャンセル後、一覧の **既定表示からは消える**（現行 `exclude_canceled` と整合） | フィルタで canceled を再表示可能（現状維持）。 |

### 4.2 機能要件（Should）

| # | 要件 | 備考 |
|---|------|------|
| R6 | キャンセル理由・備考は **後から参照できる**（一覧 Chip / 編集画面 / 詳細） | `notes` との住み分け要（§6.2）。 |
| R7 | **誤操作防止**: 確認ダイアログ（相手名・日時・理由の再確認） | Meetings 削除調査と同様の UX 期待。 |
| R8 | **`completed` 行にはキャンセル導線を出さない**（または別フローで status 変更のみ） | 実施済みの「取消」は監査上別扱い（§5.3）。 |

### 4.3 非機能・ポリシー（Must not）

| # | 要件 |
|---|------|
| N1 | **`DELETE /api/one-to-ones/{id}` を追加しない** |
| N2 | キャンセルで **`contact_memos` を自動削除しない**（FK は現状維持） |
| N3 | キャンセル理由を **`notes` の上書きだけ**に頼らない（議事・議題と混在するため **専用列推奨**） |

---

## 5. 業務シナリオ

| シナリオ | 期待理由 | 現状の対処 | Gap |
|----------|----------|------------|-----|
| 自分の都合で Zoom 121 を取りやめた | **こちら都合** | Edit → 状態をキャンセル + notes に手書き | **導線が深い・理由が構造化されない** |
| 相手から連絡があり延期不能で中止 | **相手都合** | 同上 | 同上 |
| 重複登録の片方を無効化 | **その他**（備考: 「重複登録 id=xx」） | SSOT 推奨どおり `canceled` + notes | **理由種別が集計・検索できない** |
| 例会欠席に伴い当該週の 121 をしない | こちら都合 or その他 | 手動 status 変更 | 同上 |
| 誤って **実施済み** にした | — | Edit で status 変更 | **キャンセル理由 UI の対象外**とするのが自然（§5.3） |

### 5.1 「こちら都合」「相手都合」の定義（案）

| 値 | 意味（案） |
|----|------------|
| **こちら都合** | `owner_member_id` 側（記録オーナー＝通常は自分）の都合により予定が成立しなかった。 |
| **相手都合** | `target_member_id` 側の都合により予定が成立しなかった。 |
| **その他** | 上記に当てはまらない、または説明が必要（重複手当て・システム都合・双方都合など）。**備考必須**。 |

### 5.3 `completed` の扱い

- **本 Phase スコープ外（推奨）:** `completed` に対しては **「キャンセル」ボタンを出さない**。誤 status は Edit の上級者向け変更または運用で対応。
- **要合意:** 実施済みを canceled に戻す業務必要性があるか。

---

## 6. データ設計案

### 6.1 列挙値（API / DB 案）

| UI ラベル | 提案列挙値 | 備考必須 |
|-----------|------------|----------|
| こちら都合 | `owner_convenience` | 任意 |
| 相手都合 | `target_convenience` | 任意 |
| その他 | `other` | **必須** |

`status = canceled` **以外**のときは `cancel_reason` / `cancel_remark` は **NULL**（または PATCH でクリア）。

### 6.2 保存先の比較

| 案 | 内容 | メリット | デメリット |
|----|------|----------|------------|
| **A（推奨）** | 新列: `cancel_reason` (string/enum), `cancel_remark` (text nullable), `canceled_at` (datetime nullable) | `notes`（議事）と分離。集計・フィルタ可能。監査に強い。 | マイグレーション・API・UI の波及。 |
| B | `notes` 先頭に `[cancel:owner_convenience]` 等の **構文を埋め込む** | スキーマ変更なし。 | パース脆い。Create UX・Markdown 表示と衝突。非推奨。 |
| C | `contact_memos` にキャンセル理由メモを POST | スキーマ変更小。 | 1 to 1 本体の status と **理由が分散**。一覧で理由が見えにくい。 |

### 6.3 API 案

| 案 | 内容 |
|----|------|
| **A1（推奨）** | 既存 `PATCH` に `cancel_reason`, `cancel_remark` を追加。`status=canceled` 時は **reason 必須**（validation）。 |
| A2 | `POST /api/one-to-ones/{id}/cancel` — body: `{ cancel_reason, cancel_remark? }`。サーバ側で `status=canceled`, `canceled_at=now()` を一括設定。 |

**推奨:** 一覧からのワンアクション用途は **A2 の方が意図が明確**。Edit 経路は A1 でも可。**同一 validation を共有**する。

### 6.4 既存 `notes` との関係

| 項目 | 方針（案） |
|------|------------|
| `notes` | **その回の議題・実施内容**の本体のまま維持（DATA_MODEL §4.12）。 |
| キャンセル理由 | **`cancel_reason` + `cancel_remark`** に保存。 |
| 一覧プレビュー | canceled 行では **理由 Chip + 備考抜粋**を表示（`notes` 全文は従来どおり）。 |
| モック id=9 相当 | 移行不要（サンプルのみ）。本番は新列で記録。 |

---

## 7. UI 設計案

### 7.1 導線

| 案 | 内容 | メリット | デメリット |
|----|------|----------|------------|
| **U1（推奨）** | 一覧 **操作列**に「キャンセル」（`planned` のみ表示）→ Dialog | 要望どおり **予定の手早い無効化**。Edit 不要。 | 一覧 JSX の追加。 |
| U2 | Edit 画面に **「予定をキャンセル」** セクション（planned 時のみ） | 詳細確認しやすい。 | 導線が深い（現状と同程度）。 |
| U3 | U1 + U2 の両方 | 一覧・編集どちらからも可能。 | 実装量増。 |

### 7.2 キャンセル Dialog（U1 想定）

1. タイトル: **「1 to 1 予定をキャンセル」**
2. サマリ: 相手名・予定日時（`scheduled_at`）
3. 理由: Radio — こちら都合 / 相手都合 / その他
4. 備考: TextField（**その他は必須**、他は任意）
5. 注意文: 「履歴として残ります。物理削除は行いません。」
6. 確定 → PATCH または POST cancel → 一覧 refresh（行は既定フィルタで非表示）

### 7.3 Edit 画面の `status` Select との関係

| 方針 | 内容 |
|------|------|
| **案 1（推奨）** | Edit で **いきなり `canceled` を選べない**。キャンセルは Dialog 経由のみ（reason 必須を担保）。 |
| 案 2 | Edit でも `canceled` 可だが、選択時に **理由 Dialog を強制** | 実装は Dialog 再利用で U1 と共通化。 |

---

## 8. Fit / Gap 要約

| 観点 | Fit | Gap |
|------|-----|-----|
| **製品方針** | 物理削除なし・`canceled` 正規運用・一覧 `exclude_canceled` | ユーザー語「削除」を **キャンセル UX** で満たす導線が無い |
| **モック** | canceled ステータス・stats・フィルタあり | **理由 3 分類・キャンセル Dialog なし** |
| **DB** | `status` + `notes` で最低限記録可能 | **構造化キャンセル理由列なし** |
| **API** | PATCH で `status=canceled` 可能 | reason 必須 validation なし・**cancel 専用 API なし** |
| **一覧 UI** | 編集・メモ・状態 Chip | **`planned` 向けキャンセル操作なし** |
| **編集 UI** | status Select + canceled 方針 helper | **理由・備考入力なし** |
| **集計** | キャンセル件数（今月）はある | **理由別集計・フィルタなし**（将来 Should） |

---

## 9. 影響範囲（実装 Phase 想定）

| 区分 | 影響 |
|------|------|
| **マイグレーション** | `one_to_ones` に `cancel_reason`, `cancel_remark`, `canceled_at`（案 A） |
| **API** | **`POST /api/one-to-ones/{id}/cancel`**（`CancelOneToOneRequest`）、`OneToOneIndexService::formatRecord`（理由フィールド返却）。PATCH 経由の `canceled` は **不可**（§10.1 #8）。 |
| **UI** | `OneToOnesList.jsx`（Cancel Dialog + POST cancel）、`OneToOneFormFields.jsx`（Edit から **canceled 選択肢除外**）、canceled 行 **理由 Chip** |
| **モック** | `religo-admin-mock-v2.html` `#/one-to-ones` — キャンセル Dialog・理由 Chip（§10.1 #9） |
| **テスト** | Feature: cancel validation、planned のみ、exclude_canceled 連動 |
| **SSOT 更新** | `DATA_MODEL.md` §4.12、`ONETOONES_DELETE_REQUIREMENTS.md` §2 追記、`FIT_AND_GAP_MOCK_VS_UI.md` §6 |
| **対象外（初回）** | Dashboard 理由別 stats、Zoom 連携行の自動キャンセル、completed→canceled |

---

## 10. 決定事項

### 10.1 合意済み

#### UX（2026-06-03 21:34 JST）

| # | 論点 | **確定** |
|---|------|----------|
| 1 | UI 表記 **「削除」vs「キャンセル」** | **「キャンセル」**（ボタン・Dialog）。補足で「履歴として残ります（物理削除しない）」を明示。 |
| 2 | こちら都合・相手都合の **備考** | **任意**。**「その他」** のみ備考 **必須**。 |
| 3 | **`completed` のキャンセル** | **対象外**。キャンセル操作は **`planned` のみ**。 |
| 4 | canceled 行の **理由 Chip（一覧）** | **表示する**（フィルタで canceled を表示したとき。状態 Chip の横または近傍）。 |

#### 技術・API（2026-06-03 22:17 JST）

| # | 論点 | **確定** |
|---|------|----------|
| 5 | **保存先（DB）** | **専用列:** `cancel_reason`（string/enum）・`cancel_remark`（text nullable）・`canceled_at`（datetime nullable）。`notes` とは分離。 |
| 6 | **列挙値** | `owner_convenience`（こちら都合）・`target_convenience`（相手都合）・`other`（その他）。 |
| 7 | **API** | **`POST /api/one-to-ones/{id}/cancel`** のみ。body: `{ cancel_reason, cancel_remark? }`。サーバで `status=canceled`・`canceled_at=now()` を設定。`planned` 以外は 422。 |
| 8 | **Edit の status Select** | **「キャンセル」を選択肢から除外**（または disabled）。キャンセルは **一覧 Dialog → POST cancel** のみ。 |
| 9 | **モック v2** | **実装 Phase と同時に更新**（キャンセル Dialog・理由 Chip）。 |

**validation まとめ（確定）:**

- `cancel_reason`: 必須。上記 3 値のいずれか。
- `cancel_remark`: `other` のとき **必須**（非空）。`owner_convenience` / `target_convenience` は **任意**。
- 対象: `status = planned` のみ。それ以外は POST cancel を拒否。

---

## 11. 確定方針（§10 反映）

1. **物理削除なし** — `POST cancel` で `status=canceled` + 理由列。既存 DELETE ポリシーと両立。
2. **DB** — `cancel_reason` / `cancel_remark` / `canceled_at`（§10.1 #5–6）。
3. **UI** — 一覧 `planned` 行に「キャンセル」→ Dialog → POST cancel（§10.1 #1–4, #7–8）。
4. **Edit** — status から canceled を外す。誤キャンセル防止。
5. **集計** — 理由別 Dashboard は初回見送り。`canceled_this_month_count` は現状維持。
6. **着手前 docs** — [DATA_MODEL.md](DATA_MODEL.md) §4.12 と [ONETOONES_DELETE_REQUIREMENTS.md](ONETOONES_DELETE_REQUIREMENTS.md) に §10.1 を写す（implement Phase PLAN タスク）。

---

## 12. 次 Phase 提案

| 順 | 種別 | 内容 |
|----|------|------|
| 1 | **docs** | `DATA_MODEL` §4.12・`ONETOONES_DELETE_REQUIREMENTS` §2 にキャンセル理由・POST cancel を SSOT 化 |
| 2 | **implement** | マイグレーション + `POST cancel` + 一覧 Dialog + Edit から canceled 除外 + 理由 Chip + テスト |
| 3 | **implement** | `religo-admin-mock-v2.html` 更新（§10.1 #9） |
| 4 | **docs** | `FIT_AND_GAP_MOCK_VS_UI.md` §6.9 Gap 解消記録、本書 §8 更新 |
| 5 | **任意（将来）** | 理由フィルタ、Dashboard 理由別 stats、`completed` 誤登録の救済フロー |

---

**本ドキュメントは調査・要件整理のみを記録する。コード・マイグレーション・API の変更は行っていない。**

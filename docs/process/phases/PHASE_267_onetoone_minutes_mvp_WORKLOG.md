# Phase 267 WORKLOG — 1to1 Minutes MVP

**Branch:** `feature/phase267-onetoone-minutes-mvp`

---

## 判断と実装

### 1. MVP の保存先は既存 `notes` を採用

SPEC-020 §9 で MVP は「コピペ → `notes` 手動保存」、`raw_summary` 列追加は P1（Phase G）と区分されている。`one_to_ones.notes` は既に Markdown 表示・編集プレビュー（`OneToOneFormFields` の `MarkdownReadablePanel`）に対応済みのため、新規列・新規パネルを足さずに既存 `notes` をそのまま実施後記録の保存先とした。これにより Phase 267 はフロント文言＋owner 固定のみで MVP を満たす。

### 2. owner 欄の UI 固定（サーバ強制との二重化）

owner の実体防御は Phase 263 のサーバ側 403 強制で完了している。UI では一般 member が owner を切り替える導線自体を消すため、`OneToOneFormFields` の既存 props `ownerInputDisabled` / `suppressCreateOwnerHint` を活用し、`isChapterAdmin`（`useReligoOwner()`）で出し分ける方式にした。新規 prop を増やさず Phase 265 で導入済みのロール判定を再利用。

- `OneToOnesCreate`: `ownerInputDisabled={!isChapterAdmin}` + `suppressCreateOwnerHint={!isChapterAdmin}`（owner 初期値は Dashboard 設定＝自分の owner）。
- `OneToOnesEdit`: `useReligoOwner()` を読み込み `ownerInputDisabled={!isChapterAdmin}` を付与。
- `OneToOneFormFields` は `ownerInputDisabled` 時に `validate` を空配列にして disabled な必須欄でバリデーションが詰まらないようにする既存挙動をそのまま利用。

### 3. notes の文言を「実施後記録・コピペ可」に明示

入力ハードルを下げる（G3）ため、label を「この回で話した内容・実施後記録」に変更し、helperText（create / edit）に「Zoom や AI の要約をそのまま貼り付け（コピペ）」できる旨を追記。edit 側は Markdown 対応・プレビュー表示も併記。

### 4. ビルド

`npm run build` 成功（2691 modules transformed）。

### 5. 回帰テスト

バックエンド非変更のため、Phase 263/264 で整備した owner / role 強制テストを含む全 Feature テストの回帰確認のみ実施。

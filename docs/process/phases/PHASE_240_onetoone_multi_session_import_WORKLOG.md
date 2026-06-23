# Phase 240 WORKLOG — 1to1 マルチセッション取り込み + 一覧共通メモモーダル

**Phase:** 240  
**tool:** cursor

---

## 判断ログ

### Import を Command から Service 分離

- **判断:** `OneToOneNotesMarkdownParser`（純パース）+ `OneToOneNotesImportService`（DB 更新）に分割。`ImportOneToOneNotesCommand` はパス解決と出力のみ。
- **理由:** セクション単位ループ・後方互換・テスト容易性。chapter/team import と同様に artisan は薄く保つ。

### 後方互換（OQ-1 案 A）

- **判断:** `### 【第N回】` が 0 件のファイルは **従来どおり全文 1 行**へ取り込み。
- **理由:** 旧 fixture・単回ファイルを壊さない。複数回ファイルのみセクション分割。

### Series Markdown のフォールバック

- **判断:** `one_to_ones.notes` に `## ■` または複数 `### 【第N回】` / 3000 字超がある行は **移行期の全文**として最長 1 件を優先返却。
- **理由:** 旧 import の全文 1 行が残っている相手でモーダルが欠けることを防ぐ。セクション単位 import 後は組み立て本文が主になる。

### 一覧 UI

- **判断:** モーダル open 時に `GET /api/one-to-ones/{id}/series-markdown` を fetch。Chip は `has_series_memo` または行 `notes` で表示。
- **理由:** §4.6 合意（同一相手の別行から同じ共通ファイル）。行 `notes` 直表示は廃止。

### P2 は Phase 外

- **判断:** `--create-missing`・共有ブロック → `contact_memos` import は **Phase 241** に残す。
- **理由:** PLAN Scope。本 Phase は既存 id のセクション更新 + 閲覧 UX を先に届ける。

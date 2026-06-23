# Phase 240 PLAN — 1to1 マルチセッション取り込み + 一覧共通メモモーダル（SPEC-019 P1・P3）

**作成:** 2026-06-23 22:41 JST  
**Phase Type:** implement  
**Branch:** `feature/phase240-onetoone-multi-session-import`  
**Related SSOT:** SPEC-019（[ONETOONE_MULTI_SESSION_IMPORT_REQUIREMENTS.md](../../SSOT/ONETOONE_MULTI_SESSION_IMPORT_REQUIREMENTS.md)）、DATA_MODEL §4.12 / §4.11、SPEC-006、SPEC-015  
**Status:** completed  
**モック比較:** [MOCK_UI_VERIFICATION.md](../../SSOT/MOCK_UI_VERIFICATION.md) — 1 to 1 一覧メモモーダル（§6 FIT_AND_GAP_MOCK_VS_UI O12/O17）

---

## Purpose

SPEC-019 の **P1（MVP）** と **P3（一覧 UI）** を実装する。

1. **`dragonfly:import-1to1-notes`** を `### 【第N回】` 単位に拡張し、**1回1レコード**の `one_to_ones.notes` に **当該セクションのみ**を格納する。
2. 一覧 **「メモあり」** タップで、**相手共通のシリーズ全文**（1相手1ファイル相当）を Markdown モーダル表示する（§4.6）。

**製品方針（合意）:** 121 **履歴は 1レコードずつ**、**メモは owner×target で共有可**（§4.5）。

---

## Background

- 現行 import は **1ファイル → 1行・全文 `notes`**。複数回ある相手で手動行作成 + id 追記が必要だった。
- 一覧メモモーダルは **タップ行の `notes` のみ**表示。セクション単位 import 後は UX が破綻するため **P3 を同 Phase で実装**する。

**Follow-up（本 Phase 外）:**

| Phase | 内容 |
|-------|------|
| **241（予定）** | SPEC-019 **P2** — `--create-missing`、同日 dedup、`--owner-member-id`、共有ブロック → `contact_memos` |
| 将来 | 議事録への `one_to_ones.id` 自動追記、CLI 一括同期 UI |

---

## Scope

### 変更可

| 領域 | ファイル（例） |
|------|----------------|
| Import CLI | `www/app/Console/Commands/ImportOneToOneNotesCommand.php` |
| パーサ / 組み立て | `www/app/Services/Religo/OneToOneNotesImportService.php`（新規）、`OneToOneSeriesMarkdownService.php`（新規） |
| API | `www/app/Http/Controllers/Religo/OneToOneController.php`、`OneToOneIndexService.php` |
| Routes | `www/routes/api.php`（series 取得エンドポイント） |
| UI | `www/resources/js/admin/pages/OneToOnesList.jsx` |
| Test | `www/tests/Feature/ImportOneToOneNotesCommandTest.php`、Feature（API・series） |
| Docs | `docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md`（O12/O17 解消）、`docs/process/phases/PHASE_240_*`、`PHASE_REGISTRY.md`、`dragonfly_progress.md` |

### 変更しない

- `contact_memos` への共有ブロック import（P2）
- Edit 画面のメモ UI 分割
- DB → Markdown 書き出し
- `ImportChapterMinutesCommand` との共通化リファクタ（必要最小の独立実装）
- 本番 `db-push`（別 Phase / 人間承認）

---

## 設計方針

### A. セクションパース（P1）

| 項目 | 方針 |
|------|------|
| 境界 | `### 【第N回】`（N は数字） |
| 各回 `notes` | セクション本文 + `【ソース: path#第N回】` |
| 共有ブロック | 各回 `notes` に **含めない**（P2 で `contact_memos`） |
| 後方互換（OQ-1 **案 A**） | `【第N回】` が **0件** → 現行どおり **ファイル全文を1行**に取り込み |
| `status=canceled` | 上書きしない |
| dry-run | **回ごと**に update / skip を複数行表示 |

### B. シリーズ全文 API（P3）

| 項目 | 方針 |
|------|------|
| エンドポイント | `GET /api/one-to-ones/{id}/series-markdown`（`id` から owner×target を解決） |
| レスポンス | `{ markdown: string, source_path: string|null, has_series_memo: bool }` |
| 組み立て順 | (1) 共有 `contact_memos`（`memo_type=one_to_one`, `one_to_one_id` null, 古い順）→ (2) 各 `one_to_ones` 行を `### 【第N回】` 見出し付きで時系列（`COALESCE(started_at, scheduled_at, created_at)`） |
| フォールバック | いずれかの行 `notes` に **全文**（旧 import）が残っていればその最大長本文を `markdown` とする（移行期） |
| ソース path | 任意の行 `notes` / 共有メモから `docs/meetings/1to1/…` を regex 抽出 |

### C. 一覧 UI（P3）

| 項目 | 方針 |
|------|------|
| 「メモあり」表示 | 当該行 `notes` 非空 **または** `has_series_memo`（API index 追加） |
| モーダル | `GET series-markdown` → `MarkdownView`（Meetings 議事録モーダル同系） |
| フッター | **詳細へ** → タップした行の `/one-to-ones/{id}` |

---

## DoD

### Import（P1）

- [ ] `### 【第N回】` 2件以上の fixture で dry-run が **2操作**と表示される
- [ ] 既存 `one_to_ones.id` 付きセクションの `notes` が **セクション単位**で更新され全文が入らない
- [ ] `【第N回】` なし旧ファイルは **全文1行**のまま（後方互換）
- [ ] `status=canceled` 行は skip
- [ ] Feature test 6+ ケース（パーサ + artisan）

### API・UI（P3）

- [ ] `GET /api/one-to-ones/{id}/series-markdown` が owner×target の全文を返す
- [ ] 同一相手の別行 id で **同一 markdown** が返る
- [ ] 一覧 index に `has_series_memo`（または同等）が含まれる
- [ ] `OneToOnesList` メモモーダルが **series API** を使用（行 `notes` 直表示を廃止）
- [ ] `npm run build` 成功
- [ ] FIT_AND_GAP O12/O17 を **Fit** に更新

### Phase 完了

- [ ] `php artisan test` 全 pass
- [ ] WORKLOG・REPORT・Merge Evidence
- [ ] `develop` merge + `git push origin develop`
- [ ] SPEC-019 §12 DoD のうち本 Phase 範囲を満たす

---

## Tasks

### Task 1 — パーサ・Import サービス

- `OneToOneNotesImportService`（セクション分割・日時/status 抽出・id 検出）
- `ImportOneToOneNotesCommand` をサービス利用に拡張
- dry-run 複数行出力

### Task 2 — Import テスト

- 単体 / Feature（第1回+第2回、canceled skip、旧形式、source 行）

### Task 3 — Series Markdown サービス + API

- `OneToOneSeriesMarkdownService`
- `GET /api/one-to-ones/{id}/series-markdown`
- Index: `has_series_memo`

### Task 4 — 一覧 UI

- `OneToOnesList` モーダルを series API に切替
- Chip 表示条件を `has_series_memo` 連動
- ヘルプ文言を §4.6 に合わせて更新

### Task 5 — スモーク

- `1to1_nishiura_miyabi_draci.md` / `1to1_kimura_hidetsugu_kokuhosha.md` で dry-run + import（既存 id）

### Task 6 — ビルド・テスト・docs

- `npm run build`、`php artisan test`
- FIT_AND_GAP・WORKLOG・REPORT・REGISTRY・progress

---

## Open Questions（本 Phase での扱い）

| # | 論点 | 本 Phase |
|---|------|----------|
| OQ-1 | 後方互換 | **案 A 採用** |
| OQ-3 | サマリー in notes | **各回に含めない**（series API で共有ブロックは P2 まで Markdown ソース or 全文 fallback） |
| OQ-8 | Zoom 行の notes 上書き | import 時 **manual 同様に上書き**（canceled 除く）。Zoom 要約保護は P2 以降 |

---

## リスク・注意

- 全文 fallback 行とセクション行が混在する移行期は、series API が **最長全文**を優先するため一時的に古い全文がモーダルに出る可能性がある → import 再実行で解消。
- 本番ではリポジトリの md ファイルを直読しない（§4.6.4）。

---

## 参照

- [ONETOONE_MULTI_SESSION_IMPORT_REQUIREMENTS.md](../../SSOT/ONETOONE_MULTI_SESSION_IMPORT_REQUIREMENTS.md)
- [meetings/1to1/README.md](../../meetings/1to1/README.md)
- [ZOOM_IMPORT_DEDUP_REQUIREMENTS.md](../../SSOT/ZOOM_IMPORT_DEDUP_REQUIREMENTS.md)（P2 用）

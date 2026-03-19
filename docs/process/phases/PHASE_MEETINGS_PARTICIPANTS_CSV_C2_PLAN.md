# Phase M7-C2: 参加者CSVプレビュー — PLAN

**Phase ID:** M7-C2  
**Phase 名:** 参加者CSVプレビュー  
**種別:** implement  
**Related SSOT:** MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS.md, MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md, FIT_AND_GAP_MEETINGS.md

---

## 1. 背景

- M7-C1 で Meeting に CSV をアップロード・保存できるようになった。
- 運用では ChatGPT 等で作成した CSV を優先し、反映前に中身を確認したい。
- いきなり participants に反映せず、まず「見て確認できる」状態を作る。

## 2. 目的

- 保存済み CSV を読み込み、Meeting Drawer でプレビュー表示できるようにする。
- 反映前に内容を確認できる状態を用意する。
- participants にはまだ反映しない（C3 で実施）。

## 3. スコープ

### やること

- 保存済み CSV の読み込み
- CSV のパース（必須列: 種別・名前、任意列: No, よみがな, 大カテゴリー, カテゴリー, 役職, 紹介者, アテンド, オリエン）
- Drawer 内でのプレビュー表示（件数・テーブル）
- CSV 未登録 / 読み込み失敗 / 空 CSV の状態表示
- API でプレビュー結果を返す（専用 GET preview）

### やらないこと

- participants 反映
- members 更新
- CSV 編集
- 差分確認
- PDF フローとの統合
- CSV アップロード履歴管理の高度化

## 4. 変更対象ファイル

| ファイル | 変更内容 |
|----------|----------|
| www/app/Services/Religo/MeetingCsvPreviewService.php | 新規。CSV 読み込み・パース・プレビュー用整形 |
| www/app/Http/Controllers/Religo/MeetingCsvImportController.php | preview メソッド追加 |
| www/routes/api.php | GET meetings/{id}/csv-import/preview 追加 |
| www/resources/js/admin/pages/MeetingsList.jsx | Drawer に CSV プレビュー表示・ボタン・テーブル |
| www/tests/Feature/Religo/MeetingCsvImportControllerTest.php | preview 成功・404・422・空行除外のテスト追加 |
| docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_CSV_C2_PLAN.md | 本ファイル |
| docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_CSV_C2_WORKLOG.md | 新規 |
| docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_CSV_C2_REPORT.md | 新規 |

## 5. CSV パース方針

- 1 行目をヘッダとして扱う。
- 2 行目以降をデータ行。空行は除外。
- 列数不足は null 補完、列過多は切り捨て。
- UTF-8 前提。BOM は除去（ImportParticipantsCsvCommand と同様）。
- プレビュー用に主要列を正規化キーで返す: type, name, kana, category, introducer, attendant, orient。
- ヘッダ名の揺れは最小限（例: カテゴリーは「カテゴリー」のみ。大カテゴリーは category に含めないか別キーでよい）。

## 6. UI 表示方針

- **CSV 未登録:** 「未登録」表示（既存のまま）。
- **CSV あり / 未読込:** ファイル名の下に「プレビュー表示」ボタン。
- **読込成功:** 件数表示 + TableContainer + テーブル（種別・名前・よみがな・カテゴリー・紹介者・アテンド・オリエン）。20 件以上はスクロール。
- **読込失敗:** エラーメッセージ表示。
- PDF ブロックとは完全に分離。

## 7. テスト観点

- CSV プレビュー取得成功時: headers, rows, row_count が返る。
- row_count がデータ行数と一致する。
- CSV 未登録で 404。
- ファイル不在で 404。
- 空行が除外される。
- 空 CSV（ヘッダのみ）で row_count 0, rows 空配列。

## 8. DoD（Definition of Done）

- 保存済み CSV を読み込める。
- Drawer で CSV 内容を確認できる。
- row_count が表示できる。
- CSV 未登録時の状態表示がある。
- PDF フローを壊さない。
- `php artisan test` が通る。
- `npm run build` が通る。

# Phase M7-C2: 参加者CSVプレビュー — REPORT

**Phase ID:** M7-C2  
**完了日:** 2026-03-17

---

## 変更ファイル一覧

| ファイル | 変更内容 |
|----------|----------|
| www/app/Services/Religo/MeetingCsvPreviewService.php | 新規。CSV 読み込み・パース・プレビュー用整形 |
| www/app/Http/Controllers/Religo/MeetingCsvImportController.php | preview メソッド追加、MeetingCsvPreviewService 注入 |
| www/routes/api.php | GET meetings/{meetingId}/csv-import/preview 追加 |
| www/resources/js/admin/pages/MeetingsList.jsx | fetchCsvPreview、プレビュー state、Drawer に「プレビュー表示」ボタンとテーブル |
| www/tests/Feature/Religo/MeetingCsvImportControllerTest.php | preview 関連テスト 7 件追加 |
| docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_CSV_C2_PLAN.md | 新規 |
| docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_CSV_C2_WORKLOG.md | 新規 |
| docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_CSV_C2_REPORT.md | 本ファイル |

## 実装要約

- 保存済み CSV を Meeting に紐づく最新の meeting_csv_imports から読み、プレビュー用に headers / rows / row_count を返す API を追加した。
- CSV パースは MeetingCsvPreviewService で実施。必須列は種別・名前。プレビュー表示列は種別・名前・よみがな・カテゴリー・紹介者・アテンド・オリエン。空行除外・BOM 除去・列数不足補完を実施。
- Drawer の「参加者CSV」ブロックに「プレビュー表示」ボタンを追加し、押下で preview API を呼び出し、件数とテーブルを表示。CSV 未登録・読込失敗・空の状態を表示する。

## 追加した API / Service

- **Service:** `App\Services\Religo\MeetingCsvPreviewService::preview(string $fullPath): array` — CSV を開き headers / rows / row_count を返す。
- **API:** `GET /api/meetings/{meetingId}/csv-import/preview` — 紐づく最新 CSV のプレビューを返す。CSV 未登録・ファイル不在は 404、必須列なし等は 422。

## UI に追加した CSV プレビュー表示

- Drawer「参加者CSV」ブロック内で、CSV 登録済み時に「プレビュー表示」ボタンを表示。
- 押下で preview API を呼び出し、成功時は「○件」と TableContainer（maxHeight 280px）で種別・名前・よみがな・カテゴリー・紹介者・アテンド・オリエンを表示。読み込み中は「読込中…」、エラー時はメッセージ表示。

## テスト結果

- **php artisan test:** 166 passed（654 assertions）。MeetingCsvImportControllerTest で preview 成功・404（未登録/Meeting 不在/ファイル不在）・422（必須列なし）・空行除外・ヘッダーのみの 7 件を追加。
- **npm run build:** 成功。

## 既知の制約

- 文字コードは UTF-8 前提。BOM は除去するが、Shift-JIS 等は未対応。
- 列名揺れは最小限。過度な正規化はしない。
- participants への反映は行っていない（C3 で実施予定）。

## 次の改善候補

- C3: CSV を participants に反映する。
- 列名揺れの吸収（必要に応じて）。

## Merge Evidence

（develop 取り込み後に記入）

merge commit id:  
source branch: feature/phase-m7-c2-csv-preview  
target branch: develop  
phase id: M7-C2  
test result: 166 passed  
changed files: MeetingCsvPreviewService.php（新規）, MeetingCsvImportController.php, api.php, MeetingsList.jsx, MeetingCsvImportControllerTest.php, PHASE_MEETINGS_PARTICIPANTS_CSV_C2_*.md（3 件）

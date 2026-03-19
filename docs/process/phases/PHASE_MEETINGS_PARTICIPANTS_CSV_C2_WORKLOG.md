# Phase M7-C2: 参加者CSVプレビュー — WORKLOG

**Phase ID:** M7-C2

---

## サンプル CSV から採用した列

- 必須: 種別, 名前
- 任意: No, よみがな, 大カテゴリー, カテゴリー, 役職, 紹介者, アテンド, オリエン
- dragonfly_201_20260317_all_csv.txt のヘッダーをそのまま採用。列名揺れは今回の範囲では吸収しない（「カテゴリー」のみ。大カテゴリーは category_group として別キーで保持）。

## ヘッダ解釈の方針

- 1 行目を str_getcsv でパースしヘッダとする。trim する。
- 必須列（種別・名前）が無い場合はエラーとして 422。
- プレビュー用の正規化キー: type←種別, name←名前, kana←よみがな, category_group←大カテゴリー, category←カテゴリー, role←役職, introducer←紹介者, attendant←アテンド, orient←オリエン。

## 空行・列不足の扱い

- 空行（trim 後が ''）はスキップ。
- 列数不足: array_pad で null 補完。
- 列過多: array_slice でヘッダ数に揃える。

## API を show に混ぜるか分けるかの判断

- プレビューは CSV が大きい場合があるため、show に混ぜるとレスポンスが重くなる。専用 GET .../csv-import/preview で分ける。

## 実装内容

- **MeetingCsvPreviewService:** CSV を file_get_contents で読み、BOM 除去・1 行目ヘッダ・2 行目以降をデータ行。空行スキップ、列不足は array_pad、過多は array_slice。正規化キーは HEADER_TO_KEY で type, name, kana, category_group, category, role, introducer, attendant, orient。返却は headers（PREVIEW_HEADERS 固定）, rows, row_count。必須列なし時は RuntimeException 422、ファイル読めない時は 404。
- **MeetingCsvImportController::preview:** 最新の MeetingCsvImport を取得、Storage::path で絶対パス取得、is_readable でファイル不在なら 404。previewService->preview() を呼び JSON 返却。例外コード 404/422 をそのまま HTTP で返す。
- **ルート:** GET /api/meetings/{meetingId}/csv-import/preview を追加。
- **MeetingsList.jsx:** fetchCsvPreview(meetingId)、state: csvPreviewData, csvPreviewLoading, csvPreviewError。Drawer 閉じ時・csv 未登録時にプレビューをクリア。「プレビュー表示」ボタンで API 呼び出し、成功時は件数 + TableContainer（種別・名前・よみがな・カテゴリー・紹介者・アテンド・オリエン）を表示。エラー時はメッセージ表示。

## テスト内容

- preview 成功: ヘッダ + 2 行の CSV を保存し GET preview → 200, headers/rows/row_count, row_count=2, 1 行目 type=メンバー name=山田 太郎, 2 行目 type=ビジター name=帆苅 有希。
- CSV 未登録: GET preview → 404。
- Meeting 不在: GET preview → 404。
- ファイル不在: import レコードのみでファイルを put しない → GET preview → 404。
- 空行除外: データ行の間に空行 → row_count=2, rows が 2 件。
- 必須列なし: ヘッダに「種別」なし → 422。
- ヘッダーのみ: データ行なし → row_count=0, rows=[]。

## 結果

- php artisan test: 166 passed（MeetingCsvImportControllerTest 10 件含む）。
- npm run build: 成功。

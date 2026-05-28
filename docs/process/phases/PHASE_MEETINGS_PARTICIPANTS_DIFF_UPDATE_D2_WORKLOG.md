# Phase D2: participants 差分プレビューUI（名前解決ベース）— WORKLOG

**Phase ID:** D2

---

## なぜ No をキーにしないか

- CSV の No は「表示順・行番号」であり、同じ人が別の CSV で別の No になる。同一人物の識別に使うと、No が変わっただけで別人扱いになる。participants は (meeting_id, member_id) UNIQUE なので、名前から解決した member_id で一意に追加・更新・未掲載が決まる。No は source_no として表示用のみ利用する。

## member_id を軸にした差分判定の理由

- MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS で「同一 participant は member_id で判定」としている。apply 時のロジックと揃えることで、プレビューと反映結果が一致する。

## added / updated / missing の定義

- **added:** CSV にあり既存 participants にその member_id がないもの。名前解決で member が存在しない行も「新規 member 作成＋participant 追加」になるため added（member_id は null で返す）。
- **updated:** CSV にあり既存にもその member_id の participant があり、type が異なるもの。
- **unchanged:** CSV にあり既存にもあり type も同じ。件数のみ返す。
- **missing:** 既存 participant にあり CSV 側にその member_id が存在しないもの。今回は削除せず残すため「未掲載（残存）」として表示。

## has_breakout 取得方針

- Participant を with(['breakoutRooms']) で取得し、missing 各要素で relation が load されていれば breakoutRooms->isNotEmpty()、そうでなければ breakoutRooms()->exists() で has_breakout を設定した。

## 実装内容

- **MeetingCsvPreviewService:** HEADER_TO_KEY と PREVIEW_HEADERS に「No」を追加（表示用）。識別には使わない。
- **MeetingCsvDiffPreviewService:** 新規。preview で rows 取得 → 名前で Member 解決（作成せず）→ resolveRowsToCsvEntries で member_id => [type, source_no, name]。既存 participants と比較し added / updated / unchanged_count / missing を算出。missing には has_breakout を付与。
- **MeetingCsvImportController:** diffPreview() を追加。GET .../csv-import/diff-preview で diffService->diffPreview を返す。
- **routes/api.php:** GET diff-preview を追加。
- **MeetingsList.jsx:** fetchCsvDiffPreview、csvDiffData / csvDiffLoading / csvDiffError 状態、「差分を確認」ボタン、差分プレビュー表示（summary Chip・追加/更新/未掲載の Table）、participantTypeLabel、確認ダイアログに csvDiffData.summary 表示。プレビュー表のヘッダーに 'No': 'no' を追加。
- **MeetingCsvImportControllerTest:** diff-preview の成功・updated 時・missing・member_id ベース（No でない）・has_breakout・404・422 のテストを追加。preview の headers 数を 10 に変更。

## テスト内容

- test_diff_preview_success_returns_summary_and_lists（added 1, unchanged 1）
- test_diff_preview_returns_updated_when_type_changes
- test_diff_preview_existing_participant_not_in_csv_is_missing
- test_diff_preview_uses_member_id_not_no（同一名前で No が違っても 1 件）
- test_diff_preview_missing_with_breakout_has_has_breakout_true
- test_diff_preview_returns_404_when_no_csv
- test_diff_preview_returns_422_when_csv_has_no_data_rows

## 結果

- php artisan test 181 passed。npm run build 成功。DoD を満たした。

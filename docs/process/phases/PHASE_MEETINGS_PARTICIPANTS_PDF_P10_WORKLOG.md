# Phase M7-P10: 再解析導線の追加（UI中心）— WORKLOG

**Phase:** M7-P10  
**作成日:** 2026-03-17

---

## なぜ clear API ではなく再解析導線を先に入れるか

- M7-P9 調査で「解析成功後に詰まる」ことが判明。専用 clear-result API を追加するとルート・Controller・テストが増える。既存 parse API は結果を毎回上書きするため、**UI から parse を再実行できるようにするだけで**「クリア＋再解析」が成立する。最小差分で目的を満たすため、まず再解析導線のみ実装した。

## parse_status ごとの表示ルール

- **has_pdf = false:** 解析ボタンは出さない（従来どおり）。
- **has_pdf = true, parse_status = pending:** 「PDF解析」ボタン（初回解析）。
- **has_pdf = true, parse_status = failed:** 「再解析」ボタン。
- **has_pdf = true, parse_status = success:** 「再解析」ボタン（M7-P10 で追加）。ただし候補編集モード中は出さない。

## 編集モードとの競合の扱い

- candidateEditMode === true のときは再解析ボタンを表示しない（showParseButton = has_pdf && !candidateEditMode）。編集内容が未保存のまま上書きされるのを防ぐ。保存またはキャンセル後に再解析可能になる。

## 実装内容

- **MeetingsList.jsx:** needsParse を廃止し、showParseButton = participantImport?.has_pdf && !candidateEditMode、parseButtonLabel = parsePending ? 'PDF解析' : '再解析' を追加。解析/再解析ボタンの表示条件を needsParse から showParseButton に変更し、ラベルを parseButtonLabel に統一。押下処理は従来どおり postParticipantImportParse 実行後に onDetailRefresh()。
- **MeetingParticipantImportControllerTest:** test_parse_can_be_re_run_after_success_overwrites_result を追加。parse_status = success かつ既存 extracted_result がある import に対して parse を再実行し、結果が上書きされることと candidate_count / meta が新結果になることを断言。

## テスト内容

- test_parse_can_be_re_run_after_success_overwrites_result: 既存 success の import で parse を再実行 → 200、extracted_text / candidates / meta が新結果で上書きされることを確認。
- 既存の test_parse_success、test_show_returns_parse_status_and_candidate_count、apply/updateCandidates 系は変更なしで通過。

## 結果

- php artisan test 156 passed。npm run build 成功。解析成功後も UI から再解析可能になり、編集モード中は再解析ボタンが非表示になることをコードで担保した。

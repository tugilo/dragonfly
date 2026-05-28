# Phase M7-P2-IMPLEMENT-1: PDFテキスト抽出と解析結果保存 — WORKLOG

**Phase:** M7-P2-IMPLEMENT-1  
**作成日:** 2026-03-17

---

## 採用したテキスト抽出方式

- **smalot/pdfparser** を Composer で追加。PHP 純粋のためサーバにバイナリ不要。`Parser::parseFile($fullPath)->getText()` でテキスト埋め込み PDF から文字列を取得。
- テキスト埋め込み PDF のみ対象。スキャン PDF（OCR）は今回対象外。抽出失敗時は例外をキャッチし、parse_status = failed とし、ログに記録して 422 を返す。

---

## 候補抽出の最初のルール

- 抽出テキストを `preg_split('/\R/u', ...)` で改行分割。空でない行を 1 行 1 候補とする。
- 各候補: `name`（トリムした行）, `raw_line`（元の行）, `type_hint`（行内に「ゲスト」「ビジター」「代理」があれば guest / visitor / proxy、なければ regular）。
- 保存形式: `{ "candidates": [ { "name", "raw_line", "type_hint" } ], "meta": { "line_count", "parser_version": 1 } }`。設計ドキュメントの形式に合わせた。members 照合は行わない。

---

## 失敗時の扱い

- PDF が存在しない・Meeting が存在しない: 404 または 422 でメッセージを返す。
- テキスト抽出で例外: parse_status = failed, parsed_at = now() を保存し、extracted_text / extracted_result は null。ログに warning を出し、422 で「PDF text extraction failed」を返す。
- いずれも participants には触れない。

---

## 実装内容

- **Migration:** meeting_participant_imports に extracted_text（longText nullable）, extracted_result（json nullable）を追加。
- **Model:** fillable に extracted_text, extracted_result を追加。extracted_result を array に cast。
- **PdfParticipantParseService:** extractText($fullPath), buildCandidates($text) を実装。AppServiceProvider で Parser を bind。
- **MeetingParticipantImportController:** parse(int $meetingId) を追加。PDF 取得 → 抽出 → 候補生成 → 保存。store() で新規アップロード時に parse_status = pending, parsed_at / extracted_* を null にリセット。
- **Route:** POST /api/meetings/{meetingId}/participants/import/parse を追加。
- **MeetingController@show:** participant_import に candidate_count を追加（parse_status === success かつ candidates が配列のときのみ件数、それ以外は null）。
- **MeetingsList.jsx:** postParticipantImportParse(meetingId), Drawer 内で「PDF解析」ボタン（has_pdf かつ parse_status !== success のとき）、解析成功時「候補 N件」表示。onDetailRefresh で解析後に詳細を再取得。
- **テスト:** parse の 404/422（PDF なし・import なし・ファイル不在）、parse 成功時の DB 保存とレスポンス、show に parse_status / candidate_count が含まれることを Feature テストで検証。parse 成功は PdfParticipantParseService を mock して PDF ファイル不要にした。

---

## テスト内容

- test_parse_returns_404_when_meeting_not_found
- test_parse_returns_422_when_no_participant_import
- test_parse_returns_422_when_pdf_file_missing
- test_parse_success_saves_extracted_text_and_result_and_returns_candidate_count（mock で extractText / buildCandidates を固定）
- test_show_returns_parse_status_and_candidate_count_in_meeting_detail（GET /api/meetings/{id} の participant_import に parse_status, candidate_count が含まれること）
- 既存の MeetingController の show 期待値に candidate_count を追加。

---

## 判断理由

- テキスト抽出は PHP のみで完結する smalot/pdfparser を採用し、Docker 環境にバイナリを増やさないようにした。
- 候補抽出は「行＝1 候補」の簡易ルールにし、type_hint はキーワード一致のみ。精度は次の Phase でサンプル PDF に合わせて調整可能。
- 解析 API は同期で実行。重い場合は将来キュー化できる。
- UI は「解析実行」と「候補 N件」表示に留め、候補一覧・編集は次 Phase に分離した。

# Phase M7-P7: 内容ベースのページ判定 — WORKLOG

**Phase:** M7-P7  
**作成日:** 2026-03-17

---

## ignore / members / participants の判定根拠

- **ignore:** 実サンプル（定例会参加者リスト）の 1 ページ目に「BNIとは」「TIME SCHEDULE」「コアバリュー」等の説明文があり、ここから抽出した行は候補としてノイズになるため、これらのキーワードを含むページは無視する。
- **members:** 「メンバー表」「よみがな」「カテゴリー」「役職」はメンバー一覧表に特有の見出しであり、参加者一覧とは別の構造なので members として分類。将来的にメンバー表専用パーサを載せる前提。
- **participants:** 「ミーティング参加者」「ビジター様」「代理出席者様」「ゲスト様」は参加者一覧ページに現れる文言で、現行の candidates 抽出の主対象とする。

## なぜページ番号依存を避けるか

- PDF のレイアウト変更（説明ページの追加・削除、ページ順の入れ替え）に強いため。ページ番号で「1 ページ目は捨てる」と固定すると、テンプレ変更のたびに壊れる。内容ベースなら「BNIとはが含まれるページは捨てる」となり、ページ位置に依存しない。

## 既存 parse 処理への組み込み方

- これまで MeetingParticipantImportController::parse では extractText() で全文取得し buildCandidates() で候補を出していた。今回から parseFile($fullPath) を 1 回だけ呼び、戻り値の candidates / meta / extracted_text をそのまま保存する形に変更。parseFile 内で Smalot の getPages() でページ単位に取得し、各ページを ParticipantPdfPageClassifier::classify で判定。type が ignore のページはスキップし、members / participants のページのみ buildCandidates に渡して候補をマージ。extracted_text は非 ignore ページのテキストを \n\n で結合したものにした。

## meta.pages の設計

- meta に pages 配列を追加: 各要素は { "page": 1-based ページ番号, "type": "ignore"|"members"|"participants" }。line_count は従来どおり（今回では非 ignore ページの行数合計）。parser_version を 2 に上げ、既存の updateCandidates 等で meta を引き継ぐ際も pages がそのまま残るようにした。

## 実装内容

- **ParticipantPdfPageClassifier:** 新規。classify(string $pageText): string。IGNORE_KEYWORDS / PARTICIPANTS_KEYWORDS / MEMBERS_KEYWORDS を containsAny で判定。判定順は ignore → participants → members。どれにも当たらなければ ignore。当初 mb_convert_kana で正規化していたが「ミーティング参加者」が ignore になる不具合があったため、正規化をやめて生テキストでキーワード一致にした。
- **PdfParticipantParseService:** ParticipantPdfPageClassifier をコンストラクタ注入。PARSER_VERSION = 2。parseFile($fullPath) を追加: getPages() でページ取得 → 各ページで getText() と classify() → ignore はスキップ → members/participants のみ buildCandidates してマージ。meta に pages, line_count, parser_version を設定。extractText / buildCandidates は後方互換のため残置。
- **MeetingParticipantImportController::parse:** extractText + buildCandidates の 2 呼び出しをやめ、parseFile($fullPath) 1 回に統一。返却の extracted_text と extracted_result（candidates + meta）を保存。
- **ParticipantPdfPageClassifierTest:** 新規。ignore（BNIとは / TIME SCHEDULE / コアバリュー）、members（メンバー表・よみがな）、participants（ミーティング参加者・ビジター様等）、不明は ignore、participants 優先・ignore 優先の 10 本。
- **MeetingParticipantImportControllerTest:** test_parse_success で parseFile を 1 回だけモックし、戻り値に meta.pages と parser_version 2 を含める形に変更。保存後の extracted_result.meta に pages が含まれ parser_version === 2 であることを断言。

## テスト内容

- Unit: ParticipantPdfPageClassifierTest で説明ページ風→ignore、メンバー表風→members、参加者一覧風→participants、不明→ignore、優先順の 10 ケース。
- Feature: parse 成功時に parseFile の戻り値がそのまま保存され、meta.pages と parser_version が persisted されることを確認。既存の parse/apply/updateCandidates 関連テストはすべて通過。

## 結果

- php artisan test 145 passed。npm run build 成功。既存解析・反映フローは変更なしで動作。

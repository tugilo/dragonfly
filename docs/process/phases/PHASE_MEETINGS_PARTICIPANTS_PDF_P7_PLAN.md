# Phase M7-P7: 内容ベースのページ判定（ignore / members / participants）— PLAN

**Phase:** M7-P7  
**Phase Type:** implement  
**作成日:** 2026-03-17

---

## 1. 背景

現在の PDF 解析は抽出テキスト全体または実質ページ順依存で候補抽出している。実際の PDF では 1 ページ目に説明文（BNIとは / TIME SCHEDULE / コアバリュー等）が入りノイズになる一方、2 ページ目以降に「メンバー表」「ミーティング参加者」など構造化ページがある。レイアウト変更に耐えるため、ページ番号ではなく内容ベースでページ種別を判定する。

## 2. 目的

PDF の各ページを内容で判定し、ignore / members / participants のいずれかに分類する。解析対象は members と participants のみとし、ignore ページは候補抽出から除外する。

## 3. スコープ

**今回やること**

- ページごとの内容判定ロジック（ParticipantPdfPageClassifier）を追加する。
- ページ種別を ignore / members / participants の 3 種類で返す。
- PdfParticipantParseService で PDF をページ単位で読み、ignore をスキップし members/participants のみから candidates を生成する。
- extracted_result.meta に pages（各 page 番号と type）を保存し、parser_version を 2 にする。
- 既存 candidates 抽出を壊さず、対象ページだけに限定する。

**今回やらないこと**

- OCR、レイアウト認識の高度化、members/participants 別パーサの大規模実装、ページごとUIの作り込み、participants 反映ロジックの変更。

## 4. 変更対象ファイル

- www/app/Services/Religo/ParticipantPdfPageClassifier.php（新規）
- www/app/Services/Religo/PdfParticipantParseService.php（ページ単位取得・classifier 組み込み・meta.pages）
- www/app/Http/Controllers/Religo/MeetingParticipantImportController.php（parse で parseFile 利用）
- www/tests/Unit/Religo/ParticipantPdfPageClassifierTest.php（新規）
- www/tests/Feature/Religo/MeetingParticipantImportControllerTest.php（ignore 除外・meta.pages のテスト）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P7_PLAN.md（本ファイル）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P7_WORKLOG.md
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P7_REPORT.md
- docs/INDEX.md, docs/process/PHASE_REGISTRY.md, docs/dragonfly_progress.md

## 5. ページ判定方針

- **ignore:** BNIとは / TIME SCHEDULE / コアバリュー 等のキーワードを含むページ。説明・スケジュール等。
- **members:** メンバー表 / よみがな / カテゴリー / 役職 等。メンバー一覧表。
- **participants:** ミーティング参加者 / ビジター様 / 代理出席者様 / ゲスト様 等。参加者一覧。
- 判定順: まず ignore キーワード → 次に participants → 次に members。どれにも当てはまらない場合は ignore（安全側）。
- 1 キーワードに依存しすぎず、複数キーワードで判定する。

## 6. meta 保存方針

- meta に pages 配列を追加: `[{ "page": 1, "type": "ignore" }, { "page": 2, "type": "members" }, ...]`。既存の line_count, parser_version は維持。parser_version は 2 に上げる。既存 meta を参照するコード（updateCandidates の meta 維持）では pages があってもそのまま引き継ぐ。

## 7. テスト観点

- 説明ページ風テキストは ignore と判定されること。
- メンバー表風テキストは members と判定されること。
- 参加者一覧風テキストは participants と判定されること。
- parse 実行時に ignore と判定されたページの内容が candidates に入らないこと。
- meta.pages にページ番号と type が保存されること。
- 既存の parse 成功・候補数・type_hint 等のテストが通ること。

## 8. DoD

- [x] PDF ページを内容ベースで ignore / members / participants に分類できる
- [x] ignore ページは candidates 抽出対象から除外される
- [x] meta.pages にページ判定結果が保存される
- [x] 既存解析機能を壊さない
- [x] php artisan test が通る
- [x] npm run build が通る
- [x] PLAN / WORKLOG / REPORT と INDEX・REGISTRY・progress を更新している

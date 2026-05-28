# Phase M7-P2-IMPLEMENT-1: PDFテキスト抽出と解析結果保存 — PLAN

**Phase:** M7-P2-IMPLEMENT-1  
**Phase ID:** M7-P2-IMPLEMENT-1  
**作成日:** 2026-03-17  
**フェーズ種別:** implement  
**Related:** [MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md](../../SSOT/MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md), [MEETINGS_PARTICIPANTS_PDF_P2_DESIGN.md](../../design/MEETINGS_PARTICIPANTS_PDF_P2_DESIGN.md), [FIT_AND_GAP_MEETINGS.md](../../SSOT/FIT_AND_GAP_MEETINGS.md)

---

## 1. 背景

- M7-P2-PREP で parsed_at / parse_status を追加済み。M7-P2-DESIGN で PDF 解析・参加者抽出の設計を記載済み。
- 今回「PDF からテキストを抽出して保存する」までを実装する。participants への反映・members 照合・候補確認 UI は行わない。

---

## 2. 目的

- Meeting に紐づく参加者 PDF を解析し、extracted_text / extracted_result（候補 JSON）/ parse_status / parsed_at を保存できるようにする。
- 解析実行 API を追加し、Drawer から「解析実行」できる最小導線を用意する。
- 既存 M7-P1 系機能を壊さない。participants には一切触れない。

---

## 3. スコープ

### やること

1. DB: meeting_participant_imports に extracted_text（nullable longText）, extracted_result（nullable json）を追加する migration
2. PDF テキスト抽出: テキスト埋め込み PDF を前提に、PHP ライブラリ（smalot/pdfparser 等）で抽出
3. 候補抽出: 抽出テキストから行単位で簡易候補を生成し、extracted_result 形式で保存
4. parse_status / parsed_at の更新（success / failed）
5. 解析実行 API: POST /api/meetings/{id}/participants/import/parse
6. show API: participant_import に candidate_count 等を追加（一覧 API は重くしない）
7. Drawer: PDF あり・未解析 or failed 時に「PDF解析」ボタン、成功時に「候補 N件」表示
8. Feature テスト: parse 成功、PDF なしで失敗、保存内容確認、show に parse_status 等が含まれること

### やらないこと

- participants への登録
- 既存 member との自動照合
- OCR（スキャン PDF）
- 完全自動登録
- 候補一覧の大きな UI

---

## 4. 変更対象ファイル

- www/database/migrations/*（新規: extracted_text, extracted_result 追加）
- www/app/Models/MeetingParticipantImport.php（fillable, casts）
- www/app/Services/Religo/PdfParticipantParseService.php（新規）
- www/app/Http/Controllers/Religo/MeetingParticipantImportController.php（parse アクション、store で parse 状態リセット）
- www/app/Http/Controllers/Religo/MeetingController.php（show の participant_import に candidate_count 追加）
- www/routes/api.php（POST .../participants/import/parse）
- www/resources/js/admin/pages/MeetingsList.jsx（Drawer 内の解析ボタン・候補数表示）
- www/tests/Feature/Religo/*（Parse API の Feature テスト）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_IMPLEMENT_1_*.md（PLAN / WORKLOG / REPORT）
- docs/INDEX.md, docs/process/PHASE_REGISTRY.md, docs/dragonfly_progress.md

---

## 5. 実装方針

### 5.1 DB

- extracted_text: nullable longText（または text）。PDF から取り出した生テキスト。
- extracted_result: nullable json。Laravel の JSON cast で配列として扱う。
- 既存 parse_status / parsed_at はそのまま。parse_status は pending / success / failed のみ使用（processing は今回は不要とする）。

### 5.2 テキスト抽出

- ライブラリ: smalot/pdfparser（Composer で追加）。テキスト埋め込み PDF のみ対象。
- 抽出失敗・例外時は parse_status = failed、parsed_at は更新する（失敗した日時を記録）。extracted_text は空または null 可。
- エラーはログに記録する。

### 5.3 候補抽出

- 抽出テキストを改行で分割し、空行でない行を 1 行 1 候補とする。最低限 name（トリムした行）、raw_line、type_hint（判定できれば regular/guest/visitor/proxy、できなければ null または regular）。
- 保存形式: { "candidates": [ { "name", "raw_line", "type_hint" } ], "meta": { "line_count", "parser_version": 1 } }。
- 精度 100% は狙わず、設計ドキュメントに沿った「候補」の形で保存する。

### 5.4 API

- POST /api/meetings/{meetingId}/participants/import/parse
  - meeting に紐づく meeting_participant_imports が存在し、PDF ファイルが存在すること。
  - 処理: PDF 読み取り → テキスト抽出 → 候補生成 → extracted_text / extracted_result / parse_status / parsed_at を保存。
  - 成功時 200: { "parse_status": "success", "parsed_at": "...", "candidate_count": N }。
  - PDF なし・Meeting なし: 404 または 422。解析例外時: parse_status = failed を保存し 422 または 500 を返す。

### 5.5 show API 拡張

- participant_import に candidate_count（成功時のみ数値、それ以外は null）を追加。既に parse_status / parsed_at は含まれている。
- extracted_result 本体は show では返さず、candidate_count のみで軽量に保つ（必要なら後で拡張）。

### 5.6 UI

- Drawer の参加者 PDF ブロック内: has_pdf かつ（parse_status が pending または failed または未設定）のとき「PDF解析」ボタンを表示。クリックで POST parse を呼び、成功後に詳細再取得で candidate_count を表示。
- 解析成功時: 「候補 N件」と表示。大きな候補一覧テーブルは作らない。

---

## 6. データ保存方針

- 新規 PDF アップロード（store）時: parse_status を pending に戻し、parsed_at / extracted_text / extracted_result を null にする（再解析が必要なため）。
- parse 実行時: 成功なら extracted_text, extracted_result, parse_status=success, parsed_at=now()。失敗なら parse_status=failed, parsed_at=now()（extracted_text は空または例外メッセージを保存してもよい）。

---

## 7. テスト観点

- Parse API: Meeting が存在し PDF が存在する場合に 200 で parse_status success と candidate_count が返る。
- PDF が存在しない Meeting で parse を呼ぶと 404 または 422。
- Parse 成功時に DB に extracted_text / extracted_result / parse_status / parsed_at が保存されている。
- GET /api/meetings/{id} の participant_import に parse_status, parsed_at, candidate_count が含まれる。
- 既存の participants/import の show/store/download および MeetingController の既存テストが回帰しない。

---

## 8. DoD

- [x] PDF 解析実行 API（POST .../participants/import/parse）が存在する
- [x] extracted_text / extracted_result が meeting_participant_imports に保存される
- [x] parse_status / parsed_at が適切に更新される
- [x] Drawer から解析実行できる、または少なくとも解析状態・候補数が確認できる
- [x] participants には一切影響しない
- [x] php artisan test が通る
- [x] npm run build が通る
- [x] PLAN / WORKLOG / REPORT が揃い、INDEX・PHASE_REGISTRY・dragonfly_progress を更新している

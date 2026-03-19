# Phase M7-P8: participants / members 専用パーサ強化 — PLAN

**Phase:** M7-P8  
**Phase Type:** implement  
**作成日:** 2026-03-17

---

## 1. 背景

M7-P7 でページを内容ベースで ignore / members / participants に分類し、ignore を除外できるようになった。一方、candidates 抽出は依然として汎用的な 1 行 1 候補であり、members ページ（メンバー表）と participants ページ（参加者一覧）で行構造や区分が異なるのに同じ扱いをしている。ノイズ除去と区分精度向上のため、ページ種別ごとに専用の抽出処理を使い分ける。

## 2. 目的

- ページ種別ごとに専用パーサを使い分け、candidates の精度を上げる。
- members ページ: 見出し行・カテゴリ見出しを除外し、人名行のみ regular 候補とする。
- participants ページ: ビジター様 / 代理出席者様 / ゲスト様 のセクションを追跡し、type_hint を visitor / proxy / guest に正確に付与する。

## 3. スコープ

**今回やること**

- members ページ用の抽出処理を追加する（見出し除外・人名行のみ候補化・type_hint=regular, page_type=members）。
- participants ページ用の抽出処理を追加する（セクション見出し追跡・区分に応じた type_hint・page_type=participants, source_section）。
- PdfParticipantParseService でページ type に応じて専用パーサを呼び分ける。
- candidates に page_type（members|participants）および source_section（visitor|proxy|guest|null）を付与可能にする。
- 既存の name / raw_line / type_hint を維持し、編集・apply・手動マッチングを壊さない。

**今回やらないこと**

- OCR、完全な表認識、introducer/attendant の厳密抽出、participants 反映ロジックの変更、手動マッチングUIの変更。

## 4. 変更対象ファイル

- www/app/Services/Religo/ParticipantPdfMembersPageParser.php（新規）
- www/app/Services/Religo/ParticipantPdfParticipantsPageParser.php（新規）
- www/app/Services/Religo/PdfParticipantParseService.php（type 別パーサ呼び分け・candidates に page_type/source_section）
- www/tests/Unit/Religo/ParticipantPdfMembersPageParserTest.php（新規）
- www/tests/Unit/Religo/ParticipantPdfParticipantsPageParserTest.php（新規）
- www/tests/Feature/Religo/MeetingParticipantImportControllerTest.php（meta.pages 維持・区分 type_hint の検証）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P8_PLAN.md（本ファイル）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P8_WORKLOG.md
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P8_REPORT.md
- docs/INDEX.md, docs/process/PHASE_REGISTRY.md, docs/dragonfly_progress.md

## 5. members / participants 専用パーサ方針

### members ページ（ParticipantPdfMembersPageParser）

- 行単位に分割。
- 除外: 「No.」「名前」「よみがな」「カテゴリー」「役職」「備考」等のヘッダ行、「建設・不動産」等のカテゴリ見出し行。
- 人名らしい行のみ候補化（日本語の姓・名らしいパターン、または数字＋スペース＋文字列の行で見出しでないもの）。
- 候補: name, raw_line, type_hint=regular, page_type=members, source_section=null。

### participants ページ（ParticipantPdfParticipantsPageParser）

- 行単位に分割。
- セクション見出しを追跡: 「ビジター様」→ visitor、「代理出席者様」→ proxy、「ゲスト様」→ guest。見出し行は候補にしない。
- 現在のセクションに応じて type_hint および source_section を付与。
- 候補: name, raw_line, type_hint, page_type=participants, source_section。

## 6. type_hint 改善方針

- members: 常に regular。
- participants: セクションに応じて visitor / proxy / guest。セクション不明の行は regular とする。

## 7. テスト観点

- members ページの見出し行が候補に入らないこと。
- members ページの人名行が regular 候補（page_type=members）になること。
- participants ページでビジター様セクションの候補が type_hint=visitor になること。
- participants ページで代理出席者様セクションの候補が type_hint=proxy になること。
- participants ページでゲスト様セクションの候補が type_hint=guest になること。
- ignore ページは引き続き candidates に入らないこと。
- parse 実行時に meta.pages が維持されること。
- 既存の parse/apply/updateCandidates の回帰がないこと。

## 8. DoD

- [x] members / participants で抽出処理を使い分けられる
- [x] members 見出し行が候補に入りにくくなる
- [x] participants の区分ごとの type_hint が改善される
- [x] ignore ページは引き続き除外される
- [x] 既存編集 / apply / 手動マッチング機能を壊さない
- [x] php artisan test が通る
- [x] npm run build が通る
- [x] PLAN / WORKLOG / REPORT と INDEX・REGISTRY・progress を更新している

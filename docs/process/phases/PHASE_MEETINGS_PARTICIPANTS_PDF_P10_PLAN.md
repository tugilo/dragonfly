# Phase M7-P10: 再解析導線の追加（UI中心）— PLAN

**Phase:** M7-P10  
**Phase Type:** implement  
**作成日:** 2026-03-17

---

## 1. 背景

M7-P9 調査で、解析成功後は「PDF解析」ボタンが表示されず同一 PDF で再解析できないことが判明。既存 parse API は結果を毎回上書きするため、UI から再実行できる導線を整えれば「クリア＋再解析」が成立する。clear-result 専用 API は追加せず、既存 parse の再実行で対応する。

## 2. 目的

解析成功後でも Drawer から「再解析」できるようにし、解析結果のやり直しを UI 上で可能にする。

## 3. スコープ

**今回やること**

- parse_status === success のときも再解析ボタンを表示する。
- 再解析ボタン押下で既存 parse API を実行し、成功後に onDetailRefresh で detail を再取得する。
- ボタン文言を「PDF解析」（初回/待ち）と「再解析」（失敗後・成功後）で切り替える。
- 候補編集モード中は再解析ボタンを出さず、編集確定 or キャンセル後に再解析可能にする。

**今回やらないこと**

- clear-result 専用 API、PDF 削除、candidates 個別クリア UI、OCR、apply ロジック変更。

## 4. 変更対象ファイル

- www/resources/js/admin/pages/MeetingsList.jsx（再解析導線・表示条件・文言）
- www/tests/Feature/Religo/MeetingParticipantImportControllerTest.php（必要なら success 後の parse 再実行テスト）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P10_PLAN.md（本ファイル）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P10_WORKLOG.md
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P10_REPORT.md
- docs/INDEX.md, docs/process/PHASE_REGISTRY.md, docs/dragonfly_progress.md

## 5. 再解析導線方針

- **表示条件:** has_pdf === true かつ candidateEditMode === false のとき、解析/再解析ボタンを表示。
- **文言:** parse_status が pending（または未設定）のとき「PDF解析」、failed または success のとき「再解析」。
- **処理:** 押下で POST .../participants/import/parse を実行し、成功後に onDetailRefresh() で candidates / meta / parse_status 等を最新化。既存 postParticipantImportParse をそのまま利用。

## 6. 編集中の扱い

- 候補編集モード（candidateEditMode === true）のときは再解析ボタンを表示しない。編集保存またはキャンセル後に再解析可能になる。未保存編集の上書きを防ぐ。

## 7. テスト観点

- parse_status === success のときも再解析ボタンが表示されること（編集モードでない場合）。
- 再解析実行後に detail 再取得が行われること。
- parse_status が pending / failed のときも従来どおり解析導線があること。
- 編集モード中は再解析ボタンが表示されないこと。
- 既存の候補表示・apply・手動マッチングに影響がないこと。
- Backend: 既存 parse API が success 後に再実行されても正常に上書きできること（既存テストで保証されていれば補強のみ）。

## 8. DoD

- [x] parse_status === success でも UI から再解析できる
- [x] 再解析後に解析結果が上書き更新される
- [x] 既存の候補表示 / 編集 / apply を壊さない
- [x] php artisan test が通る
- [x] npm run build が通る
- [x] PLAN / WORKLOG / REPORT と INDEX・REGISTRY・progress を更新している

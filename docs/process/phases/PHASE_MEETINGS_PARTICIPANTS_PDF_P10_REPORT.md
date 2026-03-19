# Phase M7-P10: 再解析導線の追加（UI中心）— REPORT

**Phase:** M7-P10  
**完了日:** 2026-03-17

---

## 変更ファイル一覧

- www/resources/js/admin/pages/MeetingsList.jsx（再解析導線・showParseButton / parseButtonLabel・編集時非表示）
- www/tests/Feature/Religo/MeetingParticipantImportControllerTest.php（test_parse_can_be_re_run_after_success_overwrites_result 追加）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P10_PLAN.md（既存）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P10_WORKLOG.md（新規）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P10_REPORT.md（本ファイル）
- docs/INDEX.md, docs/process/PHASE_REGISTRY.md, docs/dragonfly_progress.md（追記）

---

## 実装要約

- 解析成功後でも Drawer から再解析できるように、表示条件を「needsParse（= parse_status !== success）」から「showParseButton（= has_pdf && !candidateEditMode）」に変更。pending のとき「PDF解析」、failed / success のとき「再解析」とラベルを切り替え。既存 POST parse API をそのまま利用し、成功後に onDetailRefresh で結果を最新化。候補編集モード中は再解析ボタンを出さない。

---

## 再解析導線の追加内容

- **表示条件:** participantImport.has_pdf が true かつ candidateEditMode が false のとき、1 本のボタンを表示。
- **ラベル:** parse_status が pending（または未設定）のとき「PDF解析」、failed または success のとき「再解析」。
- **動作:** クリックで postParticipantImportParse(meeting.id) を実行し、完了後に onDetailRefresh() で detail を再取得。candidates / meta / parse_status / parsed_at が最新の解析結果で更新される。
- **編集モード:** 候補を編集中は再解析ボタンを表示しない。保存またはキャンセル後に再解析可能。

---

## テスト結果

- php artisan test: **156 passed**（test_parse_can_be_re_run_after_success_overwrites_result を含む）
- npm run build: **成功**

---

## 既知の制約

- 再解析前に確認ダイアログは出していない（最小差分のため）。必要なら次フェーズで追加可能。
- 専用 clear-result API は未実装。再アップロードや本再解析導線で代替。

---

## 次の改善候補

- 再解析押下時の確認ダイアログ（「現在の解析結果を上書きします」）。
- 解析結果のみをクリアする clear-result API と UI（M7-P9 提案 A/C）。

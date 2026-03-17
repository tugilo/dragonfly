# Phase M7-P2-IMPLEMENT-2: PDF解析候補表示UI — REPORT

**Phase:** M7-P2-IMPLEMENT-2  
**完了日:** 2026-03-17

---

## 変更ファイル一覧

- www/app/Http/Controllers/Religo/MeetingController.php（participant_import に candidates 追加）
- www/resources/js/admin/pages/MeetingsList.jsx（typeHintLabel、解析待ち・解析失敗・候補一覧テーブル、MUI Table 関連 import）
- www/tests/Feature/Religo/MeetingControllerTest.php（candidates 期待値追加、test_show_includes_candidates_when_parse_success 新規）
- www/tests/Feature/Religo/MeetingParticipantImportControllerTest.php（candidates アサート追加）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_IMPLEMENT_2_PLAN.md（新規）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_IMPLEMENT_2_WORKLOG.md（新規）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_IMPLEMENT_2_REPORT.md（本ファイル）
- docs/INDEX.md, docs/process/PHASE_REGISTRY.md, docs/dragonfly_progress.md（追記）

---

## 実装要約

- GET /api/meetings/{id} の participant_import に、parse_status === success のときのみ extracted_result['candidates'] を `candidates` として返すようにした。それ以外は candidates: null。
- Drawer の参加者PDFブロックで、解析待ち・解析失敗・解析成功（候補 N件＋一覧）を状態別に表示。成功時は MUI Table で名前・種別推定（Chip）・抽出元行を表示。種別は type_hint を「メンバー候補／ゲスト候補／ビジター候補／代理候補／不明」に変換して表示。候補 0 件のときは「候補なし」と表示。
- candidate_count と candidates の件数は API で一致させ、UI では candidate_count を「候補 N件」、表示行を candidates で描画し整合を取った。

---

## API に追加した項目

- **participant_import.candidates:** parse_status === success かつ候補が存在するとき、配列（各要素は name, raw_line, type_hint）。それ以外は null。

---

## UI に追加した表示

- **解析待ち:** parse_status が pending のとき「解析待ち」のキャプション。
- **解析失敗:** parse_status が failed のとき「解析失敗」のキャプション（error 色）。
- **候補一覧:** parse_status が success のとき「候補 N件」＋ TableContainer 内の Table（名前・種別推定・抽出元行）。種別は Chip で表示。抽出元行は 24 文字で省略、title で全文表示。候補 0 件のときは「候補なし」。

---

## テスト結果

- php artisan test: **112 passed**
- npm run build: **成功**

---

## 既知の制約

- 候補の編集・削除・participants への反映は未実装。表示のみ。
- 候補が多い場合は TableContainer のスクロールで対応。ページネーションは未実装。

---

## 次の改善候補

- 候補の編集・削除 UI（P3）。
- 候補の participants への一括反映（P3）。
- 既存 members との照合表示（P4）。

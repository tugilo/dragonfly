# Phase M7-P3-IMPLEMENT-1: 候補確認・修正UI — REPORT

**Phase:** M7-P3-IMPLEMENT-1  
**完了日:** 2026-03-17

---

## 変更ファイル一覧

- www/app/Http/Requests/Religo/UpdateParticipantImportCandidatesRequest.php（新規）
- www/app/Http/Controllers/Religo/MeetingParticipantImportController.php（updateCandidates 追加）
- www/routes/api.php（PUT .../participants/import/candidates）
- www/resources/js/admin/pages/MeetingsList.jsx（編集モード・putParticipantImportCandidates・候補追加/削除/保存/キャンセル）
- www/tests/Feature/Religo/MeetingParticipantImportControllerTest.php（updateCandidates 関連 5 本追加）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P3_IMPLEMENT_1_PLAN.md（新規）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P3_IMPLEMENT_1_WORKLOG.md（新規）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P3_IMPLEMENT_1_REPORT.md（本ファイル）
- docs/INDEX.md, docs/process/PHASE_REGISTRY.md, docs/dragonfly_progress.md（追記）

---

## 実装要約

- PUT /api/meetings/{meetingId}/participants/import/candidates で候補（candidates）を更新。extracted_result の meta は維持し、candidates のみ上書き。空 name 行は除外、type_hint は regular/guest/visitor/proxy または null に正規化。
- Drawer で「候補を編集」により編集モードにし、各行で名前（TextField）・種別（Select）・抽出元行（読取専用）・削除を表示。「候補追加」で行追加、保存で PUT を実行し、成功後に詳細再取得で表示を更新。キャンセルまたは Drawer 閉じで編集モードを解除。

---

## 追加した API

- **PUT /api/meetings/{meetingId}/participants/import/candidates**  
  - リクエスト: `{ "candidates": [ { "name", "raw_line", "type_hint" } ] }`  
  - 処理: parse_status が success の import のみ更新。meta 保持、candidates 上書き。空 name 除外。  
  - レスポンス: `{ "candidate_count", "candidates" }`

---

## UI に追加した編集機能

- 「候補を編集」ボタン（解析成功時のみ）
- 編集モード: 各行に名前入力・種別 Select（メンバー候補/ゲスト候補/ビジター候補/代理候補/不明）・抽出元行（読取専用）・行削除ボタン
- 「候補追加」で 1 行追加
- 「保存」で API 送信後、詳細再取得して編集モード終了
- 「キャンセル」で編集モード終了。Drawer 閉じでも編集モードをリセット

---

## テスト結果

- php artisan test: **117 passed**
- npm run build: **成功**

---

## 既知の制約

- participants への反映は未実装。候補の編集・保存のみ。
- 候補が多い場合は既存の TableContainer スクロールで対応。ページネーション・一括操作は未実装。

---

## 次の改善候補

- 候補を participants に反映する確定フロー（次 Phase）
- 既存 members との照合表示・マッチング

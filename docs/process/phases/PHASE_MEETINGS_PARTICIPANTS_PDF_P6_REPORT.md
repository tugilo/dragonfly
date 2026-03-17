# Phase M7-P6: 反映履歴の記録 — REPORT

**Phase:** M7-P6  
**完了日:** 2026-03-17

---

## 変更ファイル一覧

- www/database/migrations/2026_03_17_160000_add_apply_history_to_meeting_participant_imports.php（新規）
- www/app/Models/MeetingParticipantImport.php（fillable, casts）
- www/app/Services/Religo/ApplyParticipantCandidatesService.php（反映成功後に imported_at, applied_count 更新）
- www/app/Http/Controllers/Religo/MeetingController.php（participant_import に imported_at, applied_count）
- www/resources/js/admin/pages/MeetingsList.jsx（反映履歴表示）
- www/tests/Feature/Religo/MeetingParticipantImportControllerTest.php（apply 履歴 4 本追加・既存 1 本に断言追加）
- www/tests/Feature/Religo/MeetingControllerTest.php（participant_import 期待値に imported_at, applied_count 追加）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P6_PLAN.md（新規）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P6_WORKLOG.md（新規）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P6_REPORT.md（本ファイル）
- docs/INDEX.md, docs/process/PHASE_REGISTRY.md, docs/dragonfly_progress.md（追記）

---

## 実装要約

- meeting_participant_imports に imported_at（nullable datetime）, applied_count（nullable integer）を追加。apply 成功時に ApplyParticipantCandidatesService で両方を更新。GET meeting show の participant_import に imported_at（ISO8601）, applied_count を追加。Drawer の解析候補ブロックで「未反映」または「YYYY/MM/DD HH:mm に N件反映」を表示。再反映時は最新の日時・件数で上書き。

---

## 追加した履歴項目

- **imported_at:** 最後に participants へ反映した日時。apply 成功時のみ更新。
- **applied_count:** 最後に反映した participant 件数。再反映時は上書き。

---

## UI に追加した履歴表示

- 参加者PDFブロック内、解析成功時かつ候補件数・「participants に反映」ボタン付近に、caption で「未反映」または「YYYY/MM/DD HH:mm に N件反映」（imported_at を ja-JP で整形、applied_count を使用）。

---

## テスト結果

- php artisan test: **135 passed**
- npm run build: **成功**

---

## 既知の制約

- 最新 1 回分のみ保持。複数回の履歴を別テーブルで管理する監査ログは未実装。imported_by は未対応。

---

## 次の改善候補

- 反映履歴の複数件保持（別テーブル）、imported_by_member_id、監査ログ。

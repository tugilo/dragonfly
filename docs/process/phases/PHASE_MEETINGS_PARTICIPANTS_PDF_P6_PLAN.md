# Phase M7-P6: 反映履歴の記録 — PLAN

**Phase:** M7-P6  
**Phase Type:** implement  
**作成日:** 2026-03-17

---

## 1. 背景

- M7-P3〜P5 で candidates の編集・手動マッチング・participants への反映ができるようになった。
- 「いつ反映したか」「何件反映したか」「どの import を使ったか」が残らず、再反映や確認時に追跡しにくい。

## 2. 目的

participants 反映時の履歴を meeting_participant_imports に記録し、Drawer 上で反映済みかどうか・いつ反映したか・何件反映したかが分かるようにする。

## 3. スコープ

**今回やること**

- meeting_participant_imports に imported_at（nullable datetime）, applied_count（nullable integer）を追加する。
- apply 成功時に imported_at = now(), applied_count = 反映件数 を保存する。
- GET /api/meetings/{meetingId} の participant_import に imported_at, applied_count を追加する。
- Drawer の参加者PDF／解析候補ブロックに反映履歴を表示する（未反映／反映済み＋日時＋件数）。
- 再反映時は imported_at / applied_count を最新で上書きする。

**今回やらないこと**

- 複数回履歴の別テーブル管理、imported_by、差分更新、ロールバック、BO 保護ロジック。

## 4. 変更対象ファイル

- www/database/migrations/*_add_apply_history_to_meeting_participant_imports.php（新規）
- www/app/Models/MeetingParticipantImport.php（fillable, casts）
- www/app/Services/Religo/ApplyParticipantCandidatesService.php（反映成功後に import を更新）
- www/app/Http/Controllers/Religo/MeetingController.php（participant_import に imported_at, applied_count）
- www/resources/js/admin/pages/MeetingsList.jsx（反映履歴表示）
- www/tests/Feature/Religo/MeetingParticipantImportControllerTest.php（apply 履歴のテスト）
- www/tests/Feature/Religo/MeetingControllerTest.php（show に imported_at, applied_count の断言）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P6_PLAN.md（本ファイル）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P6_WORKLOG.md
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P6_REPORT.md
- docs/INDEX.md, docs/process/PHASE_REGISTRY.md, docs/dragonfly_progress.md

## 5. 履歴保存方針

- imported_at: 最後に participants へ反映した日時。apply 成功時のみ更新。失敗時は更新しない。
- applied_count: 最後に反映した participant 件数。再反映時は上書きする。今回は「最新 1 回分」のみ保持する。

## 6. UI 表示方針

- 参加者PDFブロック内、解析成功時かつ「participants に反映」ボタン付近に表示。
- 未反映: imported_at が null のとき「未反映」と表示。
- 反映済み: imported_at があるとき「YYYY-MM-DD HH:mm に N件反映」と表示（applied_count を使用）。Chip または補助テキストでよい。

## 7. テスト観点

- apply 成功時に imported_at / applied_count が保存されること。
- apply 失敗時（import なし・parse_status 不正・candidates 空）は imported_at / applied_count が更新されないこと。
- 再反映で imported_at / applied_count が上書きされること。
- show API の participant_import に imported_at, applied_count が含まれること（has_pdf false のときは null）。

## 8. DoD

- [x] apply 成功時に imported_at / applied_count が保存される
- [x] Drawer で反映済みかどうか分かる
- [x] 再反映時に最新値へ更新される
- [x] 既存 apply フローを壊さない
- [x] php artisan test が通る
- [x] npm run build が通る
- [x] PLAN / WORKLOG / REPORT と INDEX・REGISTRY・progress を更新している

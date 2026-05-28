# Phase M7-M7: 未解決ガイド付き解決フロー REPORT

## 変更ファイル一覧

- `www/database/migrations/2026_03_17_230000_create_meeting_csv_import_resolutions_table.php`
- `www/app/Models/MeetingCsvImportResolution.php`
- `www/app/Models/MeetingCsvImport.php`（`resolutions()`、`use` 重複削除）
- `www/app/Services/Religo/MeetingCsvUnresolvedSummaryService.php`
- `www/app/Services/Religo/MeetingCsvDiffPreviewService.php`
- `www/app/Services/Religo/MeetingCsvMemberDiffPreviewService.php`
- `www/app/Services/Religo/MeetingCsvRoleDiffPreviewService.php`
- `www/app/Services/Religo/ApplyMeetingCsvImportService.php`
- `www/app/Services/Religo/ApplyMeetingCsvRoleDiffService.php`
- `www/app/Http/Controllers/Religo/MeetingCsvImportController.php`
- `www/app/Http/Controllers/Religo/CategorySearchController.php`
- `www/app/Http/Controllers/Religo/RoleSearchController.php`
- `www/routes/api.php`
- `www/resources/js/admin/pages/MeetingsList.jsx`
- `www/tests/Feature/Religo/MeetingCsvImportControllerTest.php`
- `docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_RESOLUTION_FLOW_M7_{PLAN,WORKLOG,REPORT}.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`
- `docs/SSOT/MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS.md`（実装メモ追記）

## 実装要約

- **テーブル** `meeting_csv_import_resolutions`: import ごとに `source_value` → `resolved_id`（member/category/role）、`action_type` mapped|created。
- **API**
  - `GET /api/meetings/{id}/csv-import/unresolved` → `unresolved_member` / `unresolved_category` / `unresolved_role`
  - `POST .../resolutions`（既存への mapped/created 登録）
  - `POST .../resolutions/create-member|create-category|create-role`
  - `GET /api/categories/search?q=` / `GET /api/roles/search?q=`
- **プレビュー・apply**: 既存ロジックの**前**に `mapsForImport` を参照（member / category / role）。
- **UI**: 例会詳細の参加者 CSV 欄に「未解決を解消」→ 一覧・検索ダイアログ・新規作成・プレビュー再取得。

## テスト結果

- `php artisan test`: **236 passed**（全件）
- `npm run build`: **成功**

## Merge Evidence

- merge commit id: **（未 merge: feature ブランチ上で完了。develop 取り込み時に追記）**
- source branch: （取り込み時に記載）
- target branch: develop
- phase id: M7-M7
- phase type: implement
- related ssot: MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS.md

## 既知の制約

- 権限チェックなし（管理画面想定の既存 API と同様の扱い）。
- `source_value` は**完全一致**（CSV 側の正規化済み文字列と一致させる必要あり）。
- Category のラベルは `MeetingCsvMemberDiffPreviewService` と同じ規則（大カテゴリー/カテゴリーの結合）に依存。
- Drawer 幅は従来どおり狭いが、未解決ダイアログは `maxWidth="md"` で別表示。

## 次の改善候補

- あいまい一致・候補ランキング
- resolution の一覧・削除 UI（誤マッピングの訂正）
- 権限と監査（誰がどの解決を行ったか）
- FIT_AND_GAP への Meetings CSV ブロックの明示的記載

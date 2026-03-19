# Phase M7-M7: 参加者CSV — 未解決データのガイド付き解決フロー PLAN

| 項目 | 内容 |
|------|------|
| Phase ID | **M7-M7**（CSV 連番 M7-M* の続き。トップレベル M7 PDF 要件と区別） |
| 種別 | implement |
| 関連 SSOT | [MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS.md](../../SSOT/MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS.md) |
| 参照 REPORT | M6 監査ログ、M5 role-apply、M3 member-apply、D3 差分更新 |

## 背景

- D3 / M2–M6 までで participants 差分・members 差分・Role History 差分・監査ログは揃ったが、**unresolved member / category / role** は件数表示・スキップに留まり、運用者が画面上で解消できない。
- 実運用ではマスタ未登録・表記ゆれを**人が安全に紐づけ**ないと取り込みが止まる。

## 目的

- CSV 反映時に unresolved になる **member / category / role** を、画面上で一覧し、**既存マスタの選択**または**最小限の新規作成**で解決できるようにする。
- 解決結果を **import 単位**で保持し、**preview / apply で最優先**参照する。
- 既存の participants / members / role apply の流れを壊さない。

## スコープ（やる / やらない）

**やる**

1. unresolved の一覧 API と UI（解決済みは status で区別）。
2. 既存検索（members 既存 + categories / roles 検索 API 追加）と POST resolutions（mapped）。
3. 新規 Member / Category / Role の最小作成 + resolution（created）。
4. `meeting_csv_import_resolutions` テーブルとモデル。
5. `MeetingCsvDiffPreviewService` / `MeetingCsvMemberDiffPreviewService` / `MeetingCsvRoleDiffPreviewService` / `ApplyMeetingCsvImportService` / `ApplyMeetingCsvRoleDiffService` で **resolution 優先**。

**やらない（明示）**

- CSV ファイルの書き換え、PDF フロー、あいまい一致、rollback、一括自動解決、本格権限。

## 解決優先順位（共通）

1. `meeting_csv_import_resolutions` に `(resolution_type, source_value)` 一致 → `resolved_id` でマスタ参照  
2. 従来どおり（名前一致・category マスタ照合・roles.name 一致）  
3. 解決できなければ unresolved

## 変更対象ファイル（予定）

- `www/database/migrations/*_create_meeting_csv_import_resolutions_table.php`
- `www/app/Models/MeetingCsvImportResolution.php`
- `www/app/Models/MeetingCsvImport.php`（`resolutions()`、重複 use 修正）
- `www/app/Services/Religo/MeetingCsvUnresolvedSummaryService.php`
- `www/app/Services/Religo/MeetingCsv*PreviewService.php` / `ApplyMeetingCsv*Service.php`（resolution 参照）
- `www/app/Http/Controllers/Religo/MeetingCsvImportController.php`
- `www/app/Http/Controllers/Religo/CategorySearchController.php` / `RoleSearchController.php`
- `www/routes/api.php`
- `www/resources/js/admin/pages/MeetingsList.jsx`
- `www/tests/Feature/Religo/MeetingCsvImportControllerTest.php`
- 本 PLAN / WORKLOG / REPORT

## UI 方針

- 例会詳細 Drawer の「参加者CSV」に **「未解決を解消」** ボタン。
- ダイアログで member / category / role をセクション分け、各行 **既存を選ぶ / 新規作成**。
- 解決後 **未解決 → 解決済み** を Chip で表示。
- 「プレビュー類を再取得」で、既に開いている preview / diff を再フェッチ（任意）。

## テスト観点

- unresolved GET（404/構造）
- resolutions POST（member/category/role、422）
- create-*（201 + DB）
- resolution 登録後 member-diff / role-diff で優先解決されること
- `php artisan test` / `npm run build`

## DoD

- [x] unresolved 一覧が API / UI で見られる  
- [x] 既存選択・新規作成で解決でき、DB に保存される  
- [x] preview / apply が resolution を優先利用  
- [x] 既存フローを壊さない  
- [x] `php artisan test` / `npm run build` 成功  
- [x] PLAN / WORKLOG / REPORT・REGISTRY・INDEX・進捗・SSOT メモ更新  

## モック比較

- 本 Phase は CSV 管理画面の拡張。SSOT のモック HTML に同項目がないため **FIT_AND_GAP 追記は任意**（必要なら `docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md` に 1 行）。

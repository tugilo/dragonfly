# Phase M8.5: member 解決順の統一 REPORT

## 変更ファイル一覧

| パス |
|------|
| `www/app/Services/Religo/MeetingCsvMemberResolver.php`（コメント・利用範囲） |
| `www/app/Services/Religo/ApplyMeetingCsvImportService.php` |
| `www/app/Services/Religo/MeetingCsvDiffPreviewService.php` |
| `www/app/Services/Religo/MeetingCsvMemberDiffPreviewService.php` |
| `www/app/Services/Religo/MeetingCsvRoleDiffPreviewService.php` |
| `www/app/Services/Religo/MeetingCsvUnresolvedSummaryService.php` |
| `www/tests/Feature/Religo/MeetingCsvImportControllerTest.php` |
| `www/tests/Unit/Religo/MeetingCsvMemberResolverTest.php` |
| `docs/SSOT/MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS.md` |
| `docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_FINAL_CHECK_REPORT.md` |
| `docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_RESOLUTION_ORDER_M85_PLAN.md` |
| `docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_RESOLUTION_ORDER_M85_WORKLOG.md` |
| `docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_RESOLUTION_ORDER_M85_REPORT.md` |
| `docs/process/PHASE_REGISTRY.md` |
| `docs/INDEX.md` |
| `docs/dragonfly_progress.md` |

## 実装要約

- **統一後の member 解決順（CSV 名 → Member）**: **① `meeting_csv_import_resolutions`（type=member, source_value=CSV 名）の `resolved_id` が存在し Member が取れる → それを採用 ② なければ `Member::where('name', CSV名)->first()` ③ プレビュー系はここまでで null なら unresolved／apply のみ create**。
- **`MeetingCsvMemberResolver::resolveExistingForCsvName(importId, csvName)`** に集約。`ApplyMeetingCsvImportService` はこの結果が null のときだけ `Member::create`。

## 競合テスト

- **Feature** `test_m85_duplicate_member_name_resolution_wins_across_preview_apply_and_unresolved`: 同名 2 件（先に作成した方が `where()->first()` で先に来やすい）、resolution が **2 件目** を指す。`diff-preview` の added、`member-diff-preview` / `role-diff-preview` の unresolved 0、`unresolved` の resolved が **2 件目**、`apply` 後の participant が **2 件目** のみ。
- **Unit** `MeetingCsvMemberResolverTest`: resolution 優先、無 resolution 時の名前一致。

## テスト結果

- `php artisan test`: **250 passed**（実施時点）
- `npm run build`: **成功**

## Merge Evidence

- merge commit id: **（develop 取り込み後に追記）**
- source branch: `feature/phase-m85-member-resolution-order`（推奨）
- target branch: develop
- phase id: M8.5
- phase type: implement
- test command: `php artisan test`
- test result: 250 passed
- scope check: OK
- dod check: OK

## 既知の制約

- **`Member::where('name')->first()`** の選択順は **DB が保証しない**（通常は低 id）。resolution が無い同名複数は **依然あいまい**（M8 候補 UI で緩和）。
- **role 名**の解決順（マスタ名 → resolution）は **変更していない**（本 Phase は member のみ）。

## 次の改善候補

- 同名 member の DB 制約・運用ルールの明文化。
- role 解決を「resolution 最優先」に揃えるかは **別 Phase** で要件判断。

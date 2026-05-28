# Phase M7-M3: members 基本情報の確定更新 — PLAN

**Phase ID:** M7-M3（ユーザー表記: M3 members 基本情報の確定更新）  
**種別:** implement  
**Related SSOT:** MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS.md, MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS.md, PHASE_MEETINGS_PARTICIPANTS_MEMBER_DIFF_M2_REPORT.md, PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_D3_REPORT.md

---

## 背景

- M7-M2 で members 更新候補をプレビューのみ表示できるようになったが、DB は更新されない。
- 毎週名簿から members を少しずつ最新化したいが、自動一括上書きは危険。確認のうえ確定反映するフローが必要。

## 目的

- M2 の差分候補（name / name_kana / category）を、確認後に members に反映できるようにする。
- participants 差分更新（csv-import/apply）とは別 API で、members マスタ更新を安全に実行する。
- Role History・役職には触れない。

## スコープ

**やること**

1. member 差分を実際に members に反映する API（POST member-apply）。
2. 更新対象は name / name_kana / category_id（既存マスタに解決できた category のみ）。
3. unresolved_member は反映しない。category_master_resolved=false は反映しない。
4. Drawer から「members に反映」・確認ダイアログ・件数返却。
5. 反映後に member-diff-preview を再取得し UI を自然に更新。

**やらないこと**

- Role History / 役職 / introducer / attendant。
- categories の自動作成、新規 member 一括作成。
- PDF フロー、監査ログ別テーブル、rollback。

## 変更対象ファイル

- www/app/Services/Religo/ApplyMeetingCsvMemberDiffService.php（新規）
- www/app/Services/Religo/MeetingCsvMemberDiffPreviewService.php（category_changed に resolved_category_id 追加）
- www/app/Http/Controllers/Religo/MeetingCsvImportController.php（memberApply）
- www/routes/api.php
- www/resources/js/admin/pages/MeetingsList.jsx
- www/tests/Feature/Religo/MeetingCsvImportControllerTest.php
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_DIFF_M3_*.md

## members 更新方針

- `MeetingCsvMemberDiffPreviewService::memberDiffPreview` の結果を利用。
- `updated_member_basic` の各行について `new_name` / `new_name_kana`（キー存在時）を `members` に UPDATE。
- `category_changed` のうち `category_master_resolved === true` かつ `resolved_category_id` がある行のみ `category_id` を UPDATE。
- 新規 Member::create は行わない。

## category 解決方針

- 反映はマスタ解決済みのみ。未解決はスキップし `skipped_unresolved_category_count` で返す。
- categories の firstOrCreate は使わない（M2 と同様）。

## UI 方針

- member 差分プレビュー表示中かつ、基本情報候補が 1 件以上またはマスタ解決済みカテゴリー変更が 1 件以上あるとき「members に反映」ボタンを表示。
- 確認ダイアログで役職/Role History 非更新とスキップ条件を明示。
- 成功後 `onDetailRefresh` と `member-diff-preview` 再取得。

## テスト観点

- member-apply 成功で kana / category_id が更新されること。
- マスタ未解決カテゴリーのみのとき 422。
- 未解決名前はスキップ件数に含まれること。
- member_roles 件数が変わらないこと。
- CSV 未登録 404、適用対象なし 422。

## DoD

- members 基本情報を反映できる。
- unresolved / 未解決カテゴリーは反映しない。
- Role History に触れていない。
- participants / PDF フローを壊さない。
- php artisan test / npm run build が通る。

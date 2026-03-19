# Phase D3: 削除候補 + BO保護付き削除オプション — PLAN

**Phase ID:** D3（M7-D3）  
**Phase 名:** 削除候補 + BO保護付き削除オプション  
**種別:** implement  
**Related SSOT:** MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS.md, MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS.md, PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_M1_REPORT.md, PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_D2_REPORT.md

---

## 背景

- M1 で participants 差分更新（削除なし安全モード）は実装済み。
- D2 で差分プレビュー（added / updated / missing）は見えるようになった。
- しかし missing は残るだけなので、CSV と実データが徐々にズレる。
- 一方で、既存 participant を安易に削除すると participant_breakout が cascadeOnDelete で消え、BO 割当が壊れる。
- そのため「削除候補を見せる」「BO ありは削除しない」「BO なしのみ安全に削除する」方針で進める。

## 目的

- CSV にない既存 participant を「未掲載（残存）」だけで終わらせず、「削除候補」として扱えるようにする。
- BO（participant_breakout）付き participant は削除しないことを最優先とする。
- 反映時に、追加 / 更新 / 削除（安全に許可されたもののみ）を実行できるようにする。

## スコープ

**やること**

1. diff-preview に「削除候補」として扱える missing 情報を返す（deletable / reason）。
2. BO あり / BO なし を明確に区別する。
3. apply 実行時に「削除して反映する」オプション（delete_missing）を受け取れるようにする。
4. BO あり participant は削除対象から除外する。
5. UI で削除候補を表示し、削除あり / なしを選べるようにする。
6. 確認ダイアログで削除件数と BO 保護内容を明示する。

**やらないこと**

- BO あり participant の強制削除。
- members 基本情報更新、Role History 更新、introduced / attendant 更新。
- rollback、監査ログ別テーブル。
- PDF フローの削除候補対応。

## 変更対象ファイル

- www/app/Services/Religo/ApplyMeetingCsvImportService.php（delete_missing オプション、deleteMissingParticipants、applied_count = added+updated+deleted）
- www/app/Services/Religo/MeetingCsvDiffPreviewService.php（missing に deletable / reason 追加）
- www/app/Http/Controllers/Religo/MeetingCsvImportController.php（apply で delete_missing 受け取り、レスポンスに deleted_count / protected_count）
- www/resources/js/admin/pages/MeetingsList.jsx（削除候補表示・削除オプション・確認ダイアログ強化・apply 時に delete_missing 送信）
- www/tests/Feature/Religo/MeetingCsvImportControllerTest.php（delete_missing と BO 保護のテスト）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_D3_*.md

## 削除候補方針

- D2 の missing を今回から「削除候補」として扱う。
- 削除実行はユーザーが opt-in（delete_missing=true）したときのみ。デフォルトは削除しない（安全モード維持）。

## BO 保護方針

- has_breakout=true の participant は削除しない。
- 「削除して反映」を選んでも、BO ありは削除対象から自動除外する。
- UI では「BO ありのため削除されません」と明示する。

## 削除対象

削除されるのは以下のみ。

- CSV に存在しない既存 participant。
- has_breakout=false。
- ユーザーが「削除して反映」を選んだ場合。

## applied_count 定義

- applied_count = added_count + updated_count + deleted_count。
- meeting_csv_imports.applied_count も同じ定義に合わせる。

## テスト観点

- delete_missing=false または未指定では missing participant が削除されないこと。
- delete_missing=true で has_breakout=false の missing participant が削除されること。
- delete_missing=true でも has_breakout=true の participant は削除されないこと。
- deleted_count / protected_count が正しいこと。
- added / updated の既存ロジックが壊れていないこと。
- CSV 未登録 / rows 0 件 / 不正時のエラーが維持されていること。
- diff-preview の missing に deletable と reason が含まれること。

## DoD

- 削除候補が UI で見える。
- delete_missing オプションで削除を選べる。
- BO あり participant は削除されない。
- デフォルトでは削除されない。
- added / updated / missing / deleted / protected が分かる。
- php artisan test が通る。
- npm run build が通る。

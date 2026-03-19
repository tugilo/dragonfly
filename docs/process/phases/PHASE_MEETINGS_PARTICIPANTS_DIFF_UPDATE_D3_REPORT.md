# Phase D3: 削除候補 + BO保護付き削除オプション — REPORT

**Phase ID:** D3（M7-D3）  
**完了日:** 2026-03-17

---

## 変更ファイル一覧

- www/app/Services/Religo/MeetingCsvDiffPreviewService.php（missing に deletable / reason 追加）
- www/app/Services/Religo/ApplyMeetingCsvImportService.php（delete_missing オプション、buildParticipantDiff で missing 一覧返却、deleteMissingParticipants、applied_count 定義変更）
- www/app/Http/Controllers/Religo/MeetingCsvImportController.php（apply で delete_missing 受け取り、レスポンスに deleted_count / protected_count）
- www/resources/js/admin/pages/MeetingsList.jsx（削除候補表示・削除オプション・確認ダイアログ・apply 時に delete_missing 送信）
- www/tests/Feature/Religo/MeetingCsvImportControllerTest.php（delete_missing と BO 保護のテスト 5 件・既存 apply レスポンス拡張）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_D3_PLAN.md
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_D3_WORKLOG.md
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_D3_REPORT.md（本ファイル）

---

## 実装要約

- 差分プレビューの missing を「削除候補」として扱い、各要素に deletable（BO なしなら true）と reason（BO ありなら 'breakout_attached'）を追加。apply API に delete_missing オプションを追加し、true のときのみ missing のうち has_breakout=false の participant を削除。BO ありは常に保護し、レスポンスに deleted_count / protected_count を返す。applied_count を added + updated + deleted に変更。UI で削除候補セクション・削除可否列・「CSVにない既存 participant を削除する」チェックボックス・確認ダイアログの削除見込み/BO 保護文言を追加し、反映時に delete_missing を送信する。

## 追加した削除候補ロジック

- **ApplyMeetingCsvImportService::deleteMissingParticipants(array $missing):** missing のうち has_breakout=false の participant のみ delete。deleted_count と protected_count を返す。
- **apply(Meeting, MeetingCsvImport, options):** options['delete_missing'] が true かつ missing があるとき deleteMissingParticipants を実行。applied_count = added + updated + deleted_count。

## UI に追加した削除オプション

- 削除候補セクション: ラベル「削除候補（CSVにない既存 participant）」「BO ありは削除されません」。表に「削除可否」列（削除可 / BO ありのため削除不可）。
- チェックボックス: 「CSVにない既存 participant を削除する（BO ありは削除しない）」— 削除候補があるときのみ表示、デフォルト OFF。
- 確認ダイアログ: 削除候補 K 件・実際に削除される見込み D 件・BO ありのため削除されない P 件を表示。deleteMissing が true のとき「削除オプションが有効なため…」「BO が設定されている participant は削除しません」を表示。
- 反映成功時: 削除件数・BO保護件数を notify に含める。

## テスト結果

- MeetingCsvImportControllerTest 30 件すべて成功（D3 関連 5 件追加、既存 apply 3 件のレスポンス拡張）。全体 186 passed (753 assertions)。npm run build 成功。

## 既知の制約

- BO あり participant の強制削除は行わない。members 更新・Role History・introducer/attendant 更新は別 Phase。PDF フローの削除候補対応は未対応。

## 次の改善候補

- members 基本情報更新・Role History 連携（M7-C4.5 に沿った別 Phase）。
- PDF フローの削除候補対応。
- 監査ログ・rollback の検討。

---

## Merge Evidence

（develop 取り込み後に記入）

merge commit id:  
source branch: feature/phase-d3-delete-candidates  
target branch: develop  
phase id: D3 (M7-D3)  
phase type: implement  

test command: php artisan test  
test result: 186 passed  

changed files: 上記 8 ファイル + INDEX + PHASE_REGISTRY + dragonfly_progress  

scope check: OK  
ssot check: OK  
dod check: OK  

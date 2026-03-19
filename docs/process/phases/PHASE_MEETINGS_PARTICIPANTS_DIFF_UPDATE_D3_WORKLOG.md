# Phase D3: 削除候補 + BO保護付き削除オプション — WORKLOG

**Phase ID:** D3

---

## なぜ削除候補を導入するか

- D2 まで missing は「残存」表示のみで、CSV と実データのズレが蓄積する。運用で「CSV にない人を整理したい」ニーズに応えるため、削除候補として明示し、opt-in で削除できるようにする。

## なぜデフォルト削除なしにするか

- 誤操作で BO 割当や手動調整が消えるリスクを避ける。delete_missing は未指定・false のときは M1 と同様「追加・更新のみ」にし、削除はユーザーが明示的にチェックしたときのみ実行する。

## BO ありを保護する理由

- participant_breakout は participant_id に FK で cascadeOnDelete のため、participant 削除で BO 割当が消える。BO 設定済み participant は絶対に削除対象から除外し、protected_count で件数を返す。

## deleted_count / protected_count の定義

- **deleted_count:** 実際に削除した participant 件数（missing のうち has_breakout=false のみ）。
- **protected_count:** missing のうち has_breakout=true の件数（削除しなかった件数）。delete_missing=false のときは 0。

## 実装内容

- **MeetingCsvDiffPreviewService:** missing 各要素に `deletable`（!has_breakout）、`reason`（has_breakout なら 'breakout_attached'、そうでなければ null）を追加。
- **ApplyMeetingCsvImportService:** buildParticipantDiff で既存を with('breakoutRooms') で取得し、missing を [participant_id, has_breakout] の配列で返す。apply に options['delete_missing'] を追加。delete_missing が true かつ missing があるとき deleteMissingParticipants を呼び、deleted_count / protected_count を取得。applied_count = added + updated + deleted_count。返り値に deleted_count, protected_count を追加。deleteMissingParticipants は has_breakout=false の participant のみ delete。
- **MeetingCsvImportController:** apply で Request を受け取り、delete_missing を filter_var(..., FILTER_VALIDATE_BOOLEAN) で取得。applyService->apply(..., ['delete_missing' => $deleteMissing]) を呼び、レスポンスに deleted_count, protected_count を追加。
- **MeetingsList.jsx:** postCsvImportApply(meetingId, body) で body に delete_missing を送信。state deleteMissing（初期 false）、チェックボックス「CSVにない既存 participant を削除する（BO ありは削除しない）」を missing があるとき表示。差分プレビューの missing セクションを「削除候補（CSVにない既存 participant）」「BO ありは削除されません」に変更し、列「削除可否」を追加（deletable ? '削除可' : 'BO ありのため削除不可'）。確認ダイアログで削除候補 K 件・実際に削除される見込み D 件・BO ありのため削除されない P 件を表示。deleteMissing が true のとき「削除オプションが有効なため…」「BO が設定されている participant は削除しません」を表示。反映成功時に deleted_count / protected_count を notify に含める。
- **MeetingCsvImportControllerTest:** 既存 apply テストのレスポンスに deleted_count, protected_count を追加。test_apply_delete_missing_false_does_not_delete_missing、test_apply_delete_missing_true_deletes_missing_without_breakout、test_apply_delete_missing_true_does_not_delete_participant_with_breakout、test_apply_delete_missing_mixed_deleted_and_protected_counts、test_diff_preview_missing_has_deletable_and_reason を追加。

## テスト内容

- delete_missing 未指定/false → missing は削除されず deleted_count=0, protected_count=0。
- delete_missing true、missing が BO なしのみ → 削除され deleted_count=1, protected_count=0。
- delete_missing true、missing が BO あり → 削除されず deleted_count=0, protected_count=1。
- delete_missing true、missing が BO なし1件・BO あり1件 → deleted_count=1, protected_count=1。
- diff-preview の missing に deletable と reason（breakout_attached）が含まれること。

## 結果

- php artisan test 186 passed（MeetingCsvImportControllerTest 30 件）。npm run build 成功。DoD を満たした。

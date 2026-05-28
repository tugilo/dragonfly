# Phase M1: participants 差分更新（BO保護あり）— REPORT

**Phase ID:** M1  
**完了日:** 2026-03-19

---

## 変更ファイル一覧

- www/app/Services/Religo/ApplyMeetingCsvImportService.php
- www/app/Http/Controllers/Religo/MeetingCsvImportController.php
- www/resources/js/admin/pages/MeetingsList.jsx
- www/tests/Feature/Religo/MeetingCsvImportControllerTest.php
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_M1_PLAN.md
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_M1_WORKLOG.md
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_M1_REPORT.md（本ファイル）

---

## 実装要約

- CSV 反映を**全置換**から**差分更新**に変更した。既存 participants は削除せず、CSV に存在する member_id については追加または type 更新のみ行う。CSV にない既存 participant（未掲載）はそのまま残すため、participant_breakout（BO 割当）は維持される。

## 差分更新ロジック

- **resolveCsvRowsToMembers($rows):** プレビュー形式の rows から有効行（種別・名前あり）のみ処理し、member を名前で解決 or 新規作成。戻りは [member_id => participants.type]。
- **buildParticipantDiff($meeting, $csvMemberIdToType):** 当該 meeting の既存 participants と比較。CSV にあり既存にない → added。CSV にあり既存にもあり type が異なる → updated。既存にあり CSV にない → missing_count。
- **applyParticipantDiff($meeting, $diff):** added は Participant::create（introducer/attendant は null）。updated は Participant::where('id')->update(['type' => ...]) のみ。missing は何もしない。

## UI 文言変更

- 確認ダイアログ:「この Meeting の参加者をCSV内容で差分更新します」「既存 participant は削除せず、追加・更新のみ行います。CSV にない既存 participant は残ります（BO 割当は維持されます）」。
- 実行後: notify で「追加 N件、更新 M件、未掲載 K件（残存）」を表示（0 の項目は出さない）。

## テスト結果

- MeetingCsvImportControllerTest 18 件すべて成功。追加: test_apply_keeps_existing_participants_not_in_csv, test_apply_updates_existing_participant_type, test_apply_preserves_participants_with_breakout。
- 全体 php artisan test: 174 passed (692 assertions)。npm run build 成功。

## 既知の制約

- 削除は行わないため、名簿から外れた参加者も participant として残り続ける。削除候補の表示・実削除は今後の Phase で対応。
- introducer_member_id / attendant_member_id は今回反映しない（既存は維持、新規は null）。
- 差分プレビュー画面は未実装。

## 次の改善候補

- 差分プレビュー（追加・更新・未掲載を反映前に表示）。
- 削除候補の扱い（BO ありは削除しないオプション、確認のうえ削除など）。
- members 基本情報更新・Role History 連携（M7-C4.5 要件に沿った別 Phase）。

---

## Merge Evidence

（develop 取り込み後に記入）

merge commit id:  
source branch: feature/phase-m7-m1-participants-diff-update  
target branch: develop  
phase id: M1  
phase type: implement  
related ssot: MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS.md  

test command: php artisan test  
test result: 174 passed  

changed files: 上記 7 ファイル + INDEX + PHASE_REGISTRY + dragonfly_progress  

scope check: OK  
ssot check: OK  
dod check: OK  

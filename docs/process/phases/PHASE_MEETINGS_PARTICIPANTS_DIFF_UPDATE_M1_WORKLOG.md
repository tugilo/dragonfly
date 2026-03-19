# Phase M1: participants 差分更新（BO保護あり）— WORKLOG

**Phase ID:** M1

---

## 全置換から差分更新へ変える理由

- 全置換では participant 削除に伴い participant_breakout が cascade で削除され、BO 割当が失われる。運用で「反映し直したら BO が消えた」を防ぐため、participant を削除しない差分更新に変更した。

## member_id をキーにした理由

- MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS で「同一 participant」の判定に member_id を第一候補としている。participants は (meeting_id, member_id) UNIQUE のため、CSV 行から解決した member_id と既存 participants の member_id を突き合わせれば追加・更新・未掲載が一意に決まる。

## 削除しない安全モードを採用した理由

- 第一歩では「壊さない」を最優先とする。削除候補のプレビューや BO あり削除制御は次フェーズに分け、今回も削除は一切行わない。

## applied_count の定義

- applied_count = added_count + updated_count（実処理した件数）。meeting_csv_imports の applied_count および imported_at はこの値で更新する。

## 実装内容

- **ApplyMeetingCsvImportService:** apply() の戻りを int から array に変更。resolveCsvRowsToMembers() で CSV 行を member 解決し member_id => participant_type の配列を取得。buildParticipantDiff() で既存 participants と比較し added / updated / missing_count を算出。applyParticipantDiff() で追加（create）と更新（type のみ update）を実行。introducer/attendant は更新時も既存維持（新規追加時は null）。
- **MeetingCsvImportController:** apply() のレスポンスに added_count, updated_count, missing_count, message を返す。
- **MeetingsList.jsx:** CSV 反映確認ダイアログの文言を「差分更新」「既存は削除せず追加・更新のみ」「CSV にない既存は残る」に変更。実行後は「追加 N件、更新 M件、未掲載 K件（残存）」を notify で表示。
- **MeetingCsvImportControllerTest:** test_apply_success を差分レスポンス形式に変更。test_apply_replaces_existing_participants を test_apply_keeps_existing_participants_not_in_csv に変更（未掲載は残ることを検証）。test_apply_updates_existing_participant_type（同一 member で type 更新）、test_apply_preserves_participants_with_breakout（BO 付き participant が残る）を追加。

## テスト内容

- 既存の apply 系テストを差分レスポンス（added_count, updated_count, missing_count）に合わせて更新。
- 未掲載 participant が残ること、既存 participant の type が更新されること、BO 付き participant が残ることを新規テストで検証。
- 全 174 テスト実行で回帰なし。

## 結果

- php artisan test 成功（174 passed）。npm run build 成功。DoD を満たした。

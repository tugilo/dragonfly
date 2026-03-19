# Phase M7-C4-REQUIREMENTS: participants 差分更新 要件整理 — WORKLOG

**Phase ID:** M7-C4-REQUIREMENTS

---

## 現状全置換方式の確認

- ApplyMeetingCsvImportService: Participant::where('meeting_id', $meeting->id)->delete() ののち、CSV 行から member 解決 or 新規作成し Participant::create。imported_at / applied_count を meeting_csv_imports に保存。
- DATA_MODEL 確認: participant_breakout は participant_id → participants.id に cascadeOnDelete。よって participant 削除で BO 割当が消える。
- P3-IMPLEMENT-2 REPORT にも「participant 削除で participant_breakout は cascade で削除される想定のため、反映後は BO 割当は空になる可能性あり。要確認」とある。C3 でも同様。

## BO 影響の論点

- participant を削除しない限り、participant_breakout は残る。したがって「更新」は type 等の更新に留め、participant 行を削除しなければ BO は保護できる。
- 削除候補をどう扱うか: 即削除すると BO が消える。BO 設定済みは削除しないルールにすれば安全。
- 差分更新では「追加」「更新」「削除候補」の 3 種を出し、削除は「BO なしのみ」または「ユーザー確認のうえ」に限定する。

## 比較した差分更新案

- **案A（全置換）:** 現状維持。シンプルだが BO が消える。
- **案B（未掲載は残す）:** CSV にない参加者は削除しない。BO は残るが、参加者一覧が CSV と一致しなくなる。
- **案C（未掲載は削除候補）:** 削除候補を表示し、確認のうえ削除。BO ありは削除しないオプションで保護。実装コストは大きいが、安全と参加者一覧の一致を両立できる。

## 判断理由

- 同一人物の判定は **member_id** をキーにするのが現実的。meeting 内で (meeting_id, member_id) が UNIQUE のため、CSV から解決した member_id と既存 participant の member_id を突き合わせれば追加・更新・削除候補が決まる。
- 推奨は案C。削除を即実行せず、プレビューと確認を必須にし、BO ありは削除しないことをデフォルトにすることで、安全に反映できる。

## まとめ

- 要件整理本体（MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS.md）に、現状整理・守りたいデータ・差分判定キー・案 A/B/C・BO 影響・UI/UX・データ要件・フェーズ案 D1〜D5・推奨方針・今後の確認事項を記載した。
- 実装は行っていない。次に進む場合は D1（差分比較ロジックの設計・Service 化）から。

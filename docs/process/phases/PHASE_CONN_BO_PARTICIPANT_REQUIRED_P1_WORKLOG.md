# PHASE CONN-BO-PARTICIPANT-REQUIRED-P1 — WORKLOG

## 判断

- **一括検証:** ルームごとに `firstWhere` していた処理を、対象 `member_id` を unique 化し `Participant::whereIn` で取得 → `keyBy('member_id')` し、**欠席・欠損をまとめて 422** に変更。トランザクション内の無駄な `create` を削除。
- **メッセージ:** `rooms` / `rounds` キーは Laravel の既存 JSON 形を維持。欠席・代理は別メッセージに分離し、複数 ID は `implode`。
- **フロント:** 422 時 `errors.rooms` と `errors.rounds` を結合して `throw new Error(detail)` — `message` 単体（汎用）より原因が読める。
- **テスト:** setUp で `Participant::create(regular)` を seed し、従来の「無 participant で PUT 成功」テストを **422 期待**に置換。Dashboard の BO アクティビティテストも事前 participant 作成。

## 実施日

- 2026-03-31 JST

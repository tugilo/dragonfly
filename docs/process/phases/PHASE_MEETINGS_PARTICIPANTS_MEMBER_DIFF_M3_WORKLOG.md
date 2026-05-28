# Phase M7-M3: members 基本情報の確定更新 — WORKLOG

**Phase ID:** M7-M3

---

## なぜ members 確定反映を別フェーズにしたか

- M2 は「見える化」のみでリスクを隔離。確定反映は別 API（POST member-apply）にし、participants の csv-import/apply と操作・権限・確認文面を混同しないようにした。

## なぜ Role History を除外するか

- M7-C4.5 の方針どおり、役職履歴の自動更新は別設計が必要。本 Phase は `members` テーブルの 3 フィールドのみ更新し、`member_roles` / `roles` には一切アクセスしない。

## unresolved / 未解決カテゴリーを反映しない理由

- 名前がマスタにない行は Member を特定できず、新規作成はスコープ外。
- カテゴリーが categories に存在しない場合に勝手に作成するとデータ品質を壊すため、プレビューでは warning 表示のまま apply ではスキップし件数で可視化する。

## 実装内容

- **MeetingCsvMemberDiffPreviewService:** `category_changed` に `resolved_category_id`（解決時は ID、未解決時は null）を追加。apply 側が ID を再計算せずに済む。
- **ApplyMeetingCsvMemberDiffService:** `memberDiffPreview` を呼び、`updated_member_basic` を順に `Member::where('id')->update`（name / name_kana）。`category_changed` は `category_master_resolved` かつ `resolved_category_id` ありのみ `category_id` 更新。適用対象ゼロなら 422。戻り値に skipped 系カウント。
- **Controller:** JSON で `skipped_unresolved_count`（= 未解決名簿行数）と `skipped_unresolved_category_count` を返す。
- **MeetingsList.jsx:** `postCsvMemberApply`、`hasCsvMemberApplyTarget`、確認 Dialog、成功後再 fetch member-diff-preview。

## テスト内容

- kana 更新、category 更新、未解決名＋更新混在、未解決カテゴリーのみで 422、member_roles 非変化、404、422（対象なし・全件変更なし）、基本情報のみ反映＋未解決カテゴリー件数。

## 結果

- php artisan test 203 passed。npm run build 成功。

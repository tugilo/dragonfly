# Phase M8.5: member 解決順の統一 WORKLOG

## なぜ不整合を潰すか

- 運用者は **diff プレビュー**を見てから **apply** する。preview と apply で **別 member_id** になると、**見えている変更と実際の反映が一致しない**という信頼性欠如につながる。

## なぜ resolution を最優先か

- resolution は **人が明示的に選んだマッピング**。同名が複数あっても **CSV 文字列 → 意図した 1 人** を固定するための SSOT。名前一致の `first()` は **DB 実装依存**で不安定。

## preview と apply の違い

- **preview**: Member を **新規作成しない**。①②で見つからなければ **unresolved / スキップ**。
- **apply**: ①②で見つからなければ **③ Member::create**（従来どおり）。順序だけ preview と揃える。

## 共通化

- M8 候補実装で追加済みの **`MeetingCsvMemberResolver::resolveExistingForCsvName`** を **`ApplyMeetingCsvImportService`** からも利用し、**重複ロジックを削除**した。
- `MeetingCsvUnresolvedSummaryService` は **action_type** を「実際に使った member が resolution の resolved_id と一致するときのみ」付与するよう整理（旧実装は map があれば常に resolution の action を付け、実際は direct を使っていた可能性）。

## 実装・テスト・結果

- 上記サービスを resolver 経由に変更。`MeetingCsvDiffPreviewService` の **added 推定ループ**も resolver 化。
- Feature: `test_m85_duplicate_member_name_resolution_wins_across_preview_apply_and_unresolved`
- Unit: `MeetingCsvMemberResolverTest` 2 本
- `php artisan test` 250 passed、`npm run build` 成功

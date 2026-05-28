# Phase M7-FINAL-CHECK: CSV 同期フロー最終確認 WORKLOG

## 確認したフロー（コード上の対応）

| ステップ | 読み取り | 保存 / 更新 | 主な実装 |
|----------|-----------|-------------|----------|
| 1. CSV アップロード | multipart `csv` | `meeting_csv_imports` + Storage | `MeetingCsvImportController@store` |
| 2. CSV プレビュー | 最新 import のファイル | なし | `MeetingCsvPreviewService` |
| 3. participants 差分プレビュー | 同上 + `members` / `participants` | なし | `MeetingCsvDiffPreviewService` |
| 4. participants 反映 | 同上 | `participants`（± delete_missing）, `meeting_csv_imports.imported_at/applied_count` | `ApplyMeetingCsvImportService`, controller `apply` |
| 5. members 差分プレビュー | 同上 | なし | `MeetingCsvMemberDiffPreviewService` |
| 6. members 反映 | M2 と同じ差分計算 | `members` の name / name_kana / category_id のみ | `ApplyMeetingCsvMemberDiffService` |
| 7. role 差分プレビュー | 同上 | なし | `MeetingCsvRoleDiffPreviewService`（`Member::currentRole()`） |
| 8. Role History 反映 | M4 プレビュー再計算 | `member_roles` のみ | `ApplyMeetingCsvRoleDiffService` |
| 9. unresolved 解消 | プレビュー相当の CSV 読み | `meeting_csv_import_resolutions`（+ create-* でマスタ作成） | `MeetingCsvUnresolvedSummaryService`, controller |
| 10. resolution 優先 | 各サービスで `mapsForImport` | 反映は import に紐づく行のみ | 各 Preview / Apply サービス |
| 11. 監査ログ | なし | `meeting_csv_apply_logs` 追記 | `MeetingCsvApplyLogWriter`（各 apply 成功後のみ） |

## 特に注意した観点

- **member 解決順序**: `ApplyMeetingCsvImportService::resolveOrCreateMember` は **resolution → 名前一致 → 新規作成**。一方 `MeetingCsvDiffPreviewService::resolveRowsToCsvEntries` / `MeetingCsvMemberDiffPreviewService` / `MeetingCsvRoleDiffPreviewService` / `MeetingCsvUnresolvedSummaryService`（member 行）は **名前一致 → resolution**。→ **エッジケースで preview と apply が不一致になりうる**（REPORT 詳述）。
- **role 解決順序**: `canonicalRoleNameForCsv` と `resolveRoleForCsv` は **roles.name 完全一致 → resolution**。仕様書で「resolution 最優先」と読める場合、**実装は「マスタ同名優先」**（意図的と解釈可能：CSV 文字列がそのままマスタ名ならマップ不要）。
- **category 解決**: `resolveCategoryIdWithResolutions` は **ラベルで resolution → 既存 categories 照合**で一貫。
- **No 列**: diff の `source_no` のみ。`buildParticipantDiff` / apply は **member_id キー**。
- **BO**: `delete_missing` 時も `has_breakout=true` は削除対象外。削除された participant は FK cascade で `participant_breakout` も消える設計。

## 見つかった整合

- participants: delete_missing false で削除なし、true で BO なしのみ削除（サービス・テスト・UI 文言の方向性は一致）。
- members apply: プレビューで `category_master_resolved` かつ `resolved_category_id` ありのみ反映、unresolved はスキップ件数で返却。categories の自動作成は member-apply 経路にない（resolution の create-category は別 API）。
- role apply: `Role::create` なし。effective_date は request → held_on → today（M5/M6 と一致）。
- role preview / apply: 「現在役職」はいずれも `term_end` null かつ `term_start <= effectiveDate` の open 行（preview は `currentRole()`、apply は `currentOpenMemberRole`）で **同趣旨**。
- 監査ログ: controller で try 成功後のみ `MeetingCsvApplyLogWriter` 呼び出し。422 はログなし（テストあり）。
- Meeting `show`: 最新 CSV は `csvImports` orderByDesc `uploaded_at` limit 1。apply logs は `meeting_id` + `executed_at` desc limit 12。
- resolutions: unique `(meeting_csv_import_id, resolution_type, source_value)`。

## 見つかった不整合・注意点

1. **member: participants apply は resolution 優先、全プレビュー系は名前優先** → 稀に「CSV 名と完全一致する別 member が存在しつつ resolution が別 ID を指す」場合、**差分表示と実際の反映対象 member がずれる**。
2. **role: マスタ名一致が resolution より先** → 仕様を「常に resolution 最優先」と厳密に読むとズレ。実運用では「CSV 文字列＝既存 Role 名ならそのまま解決」が自然。
3. **resolution の訂正・削除**: API/UI なし（再登録で上書いは可能）。一覧専用 GET もなく、unresolved ダイアログ経由が事実上の確認導線。
4. **UI**: participants apply 成功後は `onDetailRefresh` のみ。ローカルの diff/member/role プレビュー state は**自動クリアされない**（古い差分が画面に残りうる）。ユーザーは再クリックで更新。

## テストの穴（要約）

- member **名前 vs resolution 競合**のプレビュー/apply 不一致を検証するテストはない。
- resolution **削除・明示的 GET 一覧**は未実装のためテストもなし。
- UI と API の文言の E2E 一致確認はなし（手動比較前提）。

## まとめ

- 主線（BO 保護、members/roles 境界、監査ログ、effective_date、No 非使用、category の resolution 優先）は **整合**。
- **最重要の注意**は **participants apply とプレビュー間の member 解決順の差**。
- 実務投入は「上記エッジケースを運用で避ける（同名 member を作らない・resolution は名前不一致時のみ）」前提で **可能**と判断。完全な機械保証には follow-up 実装を推奨。

# Phase M7-FINAL-CHECK: CSV 同期フロー最終確認 REPORT

## 作成したドキュメント一覧

| ファイル | 役割 |
|----------|------|
| [PHASE_MEETINGS_PARTICIPANTS_FINAL_CHECK_PLAN.md](./PHASE_MEETINGS_PARTICIPANTS_FINAL_CHECK_PLAN.md) | 目的・調査対象・DoD |
| [PHASE_MEETINGS_PARTICIPANTS_FINAL_CHECK_WORKLOG.md](./PHASE_MEETINGS_PARTICIPANTS_FINAL_CHECK_WORKLOG.md) | 判断・整合/不整合のメモ |
| 本 REPORT | **14 セクションの最終チェック結果（SSOT）** |

---

## 1. 全体フロー確認結果

- **アップロード**: `POST .../csv-import` → `meeting_csv_imports` + `Storage`（`MeetingCsvImportController@store`）。
- **プレビュー**: 最新 import のパスを `MeetingCsvPreviewService::preview` が読む（DB 更新なし）。
- **participants 差分 / 反映**: `MeetingCsvDiffPreviewService` / `ApplyMeetingCsvImportService`（`resolveCsvRowsToMembers` → `buildParticipantDiff` → `applyParticipantDiff`、任意で `deleteMissingParticipants`）。
- **members 差分 / 反映**: `MeetingCsvMemberDiffPreviewService` / `ApplyMeetingCsvMemberDiffService`（後者はプレビュー再実行してサブセットのみ UPDATE）。
- **role 差分 / 反映**: `MeetingCsvRoleDiffPreviewService` / `ApplyMeetingCsvRoleDiffService`（`member_roles` のみ）。
- **unresolved / resolution**: `MeetingCsvUnresolvedSummaryService` + `GET .../unresolved`、登録は `POST .../resolutions` および `create-*`。
- **監査ログ**: 各 apply の **try 成功直後**に `MeetingCsvApplyLogWriter::{participants,members,roles}`。
- **Meeting 詳細**: `GET .../meetings/{id}` が `csv_import`（最新1件）と `csv_apply_logs_recent`（12件）を返す（`MeetingController@show`）。
- **UI 再取得**: CSV 再アップロード・各 apply・PDF 系は `onDetailRefresh` → `fetchMeetingDetail`。resolution 後は `refreshCsvAfterResolution` で **既に開いている** preview/diff のみ再フェッチ。

---

## 2. resolution 優先解決順序の確認結果

| 対象 | 実装順序 | メソッド / 箇所 |
|------|-----------|-----------------|
| **participants apply（member）** | ① resolution（`TYPE_MEMBER`）② `Member::where('name')` ③ `Member::create` | `ApplyMeetingCsvImportService::resolveOrCreateMember` → **`MeetingCsvMemberResolver`**（M8.5） |
| **participants diff preview（member）** | ① resolution ② `Member::where('name')` ③ 解決できなければ行スキップ（新規作成なし） | `MeetingCsvDiffPreviewService::resolveRowsToCsvEntries` → **`MeetingCsvMemberResolver`**（**M8.5 で apply と統一**） |
| **members diff preview（member）** | ① resolution ② 名前 ③ unresolved | `MeetingCsvMemberDiffPreviewService` + **`MeetingCsvMemberResolver`**（**M8.5 で統一**） |
| **role diff preview（member）** | 同上 | `MeetingCsvRoleDiffPreviewService` + **`MeetingCsvMemberResolver`**（**M8.5 で統一**） |
| **unresolved summary（member）** | ① resolution ② 名前 ③ open | `MeetingCsvUnresolvedSummaryService` + **`MeetingCsvMemberResolver`**（**M8.5 で統一**） |
| **members diff preview（category）** | ① resolution（ラベル一致）② `categories` 照合 | `resolveCategoryIdWithResolutions` |
| **role diff preview（role 名）** | ① `Role::where('name', csv文字列)` ② resolution ③ null | `canonicalRoleNameForCsv` |
| **role apply（role 解決）** | ① `Role::where('name')` ② resolution ③ null | `ApplyMeetingCsvRoleDiffService::resolveRoleForCsv` |

**結論**

- **category**: ドキュメント想定の「resolution → 従来」に **一致**。
- **member（CSV 名 → Member）**: **M8.5 により全系統で「① resolution → ② 名前一致」に統一**。プレビューと participants apply で **同じ member_id** を参照する（同名複数行がある場合も resolution が優先）。旧「プレビューは名前先」の **不整合リスクは解消済み**。
- **role**: **マスタ同名が resolution より先**。CSV 文字列が既存 `roles.name` と一致すればマップ不要で解決する動き。**「resolution を常に最優先」と読む SSOT とは文言上ズレうる**が、preview と apply で **同順**のため **相互整合**は取れている。（※対象は **役職名** の解決。member 解決とは別。）

---

## 3. No 列の扱い確認結果

- `MeetingCsvDiffPreviewService` クラスコメント: **「No は表示用のみで識別には使わない」**。
- `resolveRowsToCsvEntries`: キーは **`member_id`**。同一 member の複数行は **最後の行で上書き**（コメント明示）。`source_no` は `row['no']` から付与のみ。
- `buildParticipantDiff` / `applyParticipantDiff`: **participant は member_id 単位**。No 未使用。
- `MeetingCsvMemberDiffPreviewService` / `MeetingCsvRoleDiffPreviewService` / `MeetingCsvUnresolvedSummaryService`: 識別は **CSV `name`（と種別）** ベース。No 未使用。
- **根拠ファイル**: `MeetingCsvDiffPreviewService.php`（コメント・`resolveRowsToCsvEntries`）、`ApplyMeetingCsvImportService.php`（diff 構造）。

**結論**: No は **表示用（source_no）のみ**で、差分・apply・member/role/unresolved いずれも **識別キーに使っていない**。

---

## 4. participants / BO 保護確認結果

- `delete_missing === false`: `deleteMissingParticipants` **未呼び出し** → 削除なし。
- `delete_missing === true`: `deleteMissingParticipants` が `has_breakout === false` のみ `Participant::delete`。`protected_count` は BO あり件数。
- `has_breakout`: `breakoutRooms` の有無（eager または exists）で判定。diff preview の `missing[].deletable` と同趣旨。
- **cascade**: `participant_breakout.participant_id` は `participants` に **cascadeOnDelete** → 削除された participant の BO 行は消える（**意図的に削除しない**ことで BO を壊さない）。
- UI: 削除オプション・確認ダイアログで BO 保護を説明（文言はコード上「CSVにない既存…BO ありは削除しない」系で一致）。

**結論**: 仕様どおり。**participant を消さない限り BO 行を壊す経路はない**（削除は participant delete のみ）。

---

## 5. members 更新確認結果

- `ApplyMeetingCsvMemberDiffService`: `updated_member_basic` は `name` / `name_kana`、`category_changed` は **`category_master_resolved` かつ `resolved_category_id` あり**のみ `category_id` 更新。
- **unresolved_member**: プレビューに出るが、apply は **スキップ件数**にのみ反映（行は更新しない）。
- **unresolved category**: `category_master_resolved === false` の行は apply 対象外（スキップ件数）。
- **categories 自動作成**: member-apply 経路に **なし**（`resolveCategoryIdReadOnly` のみ。コメントで firstOrCreate 禁止明示）。
- **Role History**: `ApplyMeetingCsvMemberDiffService` は **member_roles に触れない**。

**結論**: 要件どおり。**注意**: resolution の `create-category` は **別 API** で categories を作る（member-apply 本体ではない）。

---

## 6. Role History 確認結果

- **現在役職（プレビュー）**: `Member::currentRole()` — `term_end` null、`term_start <= today`、最新 `term_start`。
- **現在役職（反映時の閉じる対象）**: `currentOpenMemberRole($member, $effectiveDate)` — `term_end` null、`term_start <= effectiveDate`。**基準日が今日でない場合、プレビュー日と apply 日で「いま効いている行」が理論上ずれる可能性**（運用上は通常 held_on 等で一致させる）。
- **changed / csv_only / current_only**: プレビュー分類と apply のフィルタは **同一プレビューサービス**に依存するため整合。
- **unchanged**: プレビューで `unchangedCount` に入る行は apply 対象リストに **含めない** → **no-op**。
- **roles 自動作成**: `ApplyMeetingCsvRoleDiffService` に **なし**（`resolveRoleForCsv` のみ）。`Role::create` は resolution の `create-role` のみ。
- **effective_date**: `request` → `held_on` → `today`（`resolveEffectiveDate`）。M6 仕様と一致。

---

## 7. 監査ログ確認結果

- **participants / members / roles** それぞれ、対応する apply が **成功したときのみ** `MeetingCsvApplyLogWriter` が実行（controller の try 内）。
- **422 / 404**: ログ **作成されない**（`test_role_apply_422_does_not_create_audit_log` 等）。
- **applied_on**: participants/members は `now()->toDateString()`、roles は **`effective_date`**（基準日）。
- **executed_at**: `now()`。
- **counts / meta**: Writer 内で result / meta を構造化。`MeetingCsvApplyLog::toApiArray` / `summaryLabel` で UI 表示。
- **最新ログ**: `show` は `orderByDesc('executed_at')->limit(12)`。専用 `GET .../csv-import/apply-logs` は別途 limit 指定可。

**結論**: 整合。**members の applied_count** は「基本＋カテゴリ」の合算で Writer 側計算（メタにも内訳あり）。

---

## 8. unresolved / resolution 確認結果

- **一覧**: `GET .../csv-import/unresolved` で `unresolved_member` / `unresolved_category` / `unresolved_role`（各行 `status`: open / resolved）。
- **登録**: `POST .../resolutions`（mapped/created）、`create-member` / `create-category` / `create-role`。
- **preview / apply への反映**: 各サービスが `MeetingCsvImportResolution::mapsForImport` を参照（§2）。
- **source_value**: **完全一致**（trim 済み文字列）。UI は API 返却の `source_value` をそのまま POST する設計。
- **訂正・削除専用 API / UI**: **未実装**。同一キーで `updateOrCreate` による **上書き**は可能。

---

## 9. UI 再取得タイミング確認結果（MeetingsList.jsx）

| 操作 | 再取得 |
|------|--------|
| CSV 再アップロード成功 | `onDetailRefresh`（Meeting 詳細全体） |
| participants apply 成功 | `onDetailRefresh` のみ |
| members apply 成功 | `onDetailRefresh` + **member-diff-preview のみ** 明示再取得 |
| role apply 成功 | `onDetailRefresh` + **role-diff-preview のみ** 明示再取得 |
| resolution 保存 / create | `refreshCsvAfterResolution` → unresolved + **既に state がある** preview / diff / member-diff / role-diff のみ |
| 「プレビュー類を再取得」ボタン | 上と同じ `refreshCsvAfterResolution` |

**取りこぼし**: participants apply 後、**ローカルの csvDiffData は自動更新されない**（ユーザーが「差分を確認」を再度押す必要あり）。**二重取得**: 意図的でないが、members/role apply で detail + 該当 preview の並列取得はある（許容範囲）。

---

## 10. DB / 制約 / index 確認結果

- **meeting_csv_import_resolutions**: `UNIQUE(meeting_csv_import_id, resolution_type, source_value)`。FK `meeting_csv_import_id` → `meeting_csv_imports` cascadeOnDelete。
- **resolution_type / source_value**: 型は string。アプリ側定数 `member|category|role`。
- **meeting_csv_apply_logs**: `INDEX(meeting_id, executed_at)`。FK meeting / import。
- **リレーション**: `MeetingCsvImport` hasMany `resolutions` / `applyLogs`。import 削除で resolutions / logs は cascade。**破綻しにくい構造**。

---

## 11. テストの穴

- **member: 名前一致と resolution の競合**: **M8.5 で Feature テスト追加＋解決順統一により解消**（当時はテスト **なし**）。
- **role: 同名マスタと resolution の優先**の明示テストは薄い（現状は「マスタ未登録文字列を map で解決」中心）。
- **effective_date**: `held_on` null 時の `today` フォールバックの **専用テスト**は限定的（一部シナリオでカバー）。
- **resolution 削除 API** なし → テストなし **（仕様通り未実装）**。
- **UI 文言と API メッセージ**の一致: 自動テストなし。

**推奨（実装は別 Phase）**: ~~競合 member の統合テスト~~ **→ M8.5 で実施済み**。残りは role 同名マスタ優先の明示テスト強化等。

---

## 12. ドキュメント整合確認結果

- **PHASE_REGISTRY**: M7-C1〜D3, M7-M1〜M7-M7 が列挙されている。**本 M7-FINAL-CHECK を追記**（docs）。
- **INDEX**: process/phases の M7 系リンクが多数。**FINAL_CHECK 3 ファイルを追記**。
- **dragonfly_progress**: 本 Phase の 1 行を追記。
- **SSOT 実装メモ**（`MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS.md`）: M2〜M7 の列挙は **おおむね実装と一致**。**M8.5** で member 解決順を **全系 resolution → 名前** に統一した旨を追記済み（旧注意書きは不要）。

---

## 13. 総合評価

- **主幹フロー**（アップロード → 各種プレビュー → 反映 → ログ）は **一貫**している。
- **BO 保護・members/roles 境界・監査ログ・No 非使用・category resolution 優先**は **良好**。
- ~~**最大リスク**は **member 解決順の preview/apply 差**~~ → **M8.5 で解消**（`MeetingCsvMemberResolver`）。
- **role** は preview/apply が **同順**のため **内部整合**は取れている。

**現状で実務投入可能か**: **Yes** — member は preview/apply で同一解決順。運用上の取り違えリスクは **大幅に低減**。

---

## 14. リリース前に追加でやるべきこと（あれば）

1. ~~SSOT に member 解決順の差~~ / ~~競合テスト~~ / ~~プレビュー統一~~ → **M8.5 で対応済み**。  
2. **（任意）** participants apply 成功後に **diff preview state を null にする** or **自動再取得**（UX）。  
3. **（任意）** resolution の **一覧・削除**（監査・誤操作修正用）。  
4. **マイグレーション**: 本番未適用環境では `meeting_csv_import_resolutions` / `meeting_csv_apply_logs` の適用確認。

---

## 最終チェック要約（エグゼクティブサマリ）

- **整合**: category resolution、BO、members 更新範囲、role apply、監査ログ、No 列、DB 制約、ドキュメントの M7 Phase 列挙。  
- **不整合 / 注意**: ~~member の preview/apply 解決順の差~~ → **M8.5 で解消**。role は **マスタ名が resolution より先**だが preview/apply で一致。  
- **総合**: **実務投入は可能**（member 整合性は M8.5 以降で強化済み）。  

---

## 作成ドキュメント（本 Phase）

- `docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_FINAL_CHECK_PLAN.md`
- `docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_FINAL_CHECK_WORKLOG.md`
- `docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_FINAL_CHECK_REPORT.md`（本ファイル）

## Merge Evidence

- docs Phase: merge 時にコミット ID を追記可。

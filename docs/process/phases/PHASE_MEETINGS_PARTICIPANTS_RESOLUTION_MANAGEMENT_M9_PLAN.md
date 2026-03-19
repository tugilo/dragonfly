# PHASE: M9 — resolution 管理UIの強化 + 同名member運用補強

| 項目 | 内容 |
|------|------|
| Phase ID | M9 |
| 種別 | implement |
| Related SSOT | `docs/SSOT/MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS.md`（実装メモ追記） |
| 参照レポート | M7 REPORT（resolution flow）, M8（suggestions）, M8.5（resolver 順）, FINAL_CHECK |

## 背景

- M7–M8.5 で `meeting_csv_import_resolutions` と `MeetingCsvMemberResolver` により preview / apply の整合は改善済み。
- ただし **resolution が無い同名 member** は `where('name')->first()` 依存のまま誤解決リスクが残る。
- resolution は作成できるが、**一覧・解除・再マップ**の運用 UI が弱く、現場での見直しがしづらい。

## 目的

- 最新 import に紐づく resolution を **一覧・削除・再マップ** できるようにする。
- member 解決時に **同名競合** を検知し、preview / unresolved / diff / suggestions 応答に **警告用フィールド** を載せる。
- UI で「同名 member が複数」「resolution 推奨」を明示する。
- 変更後は **preview / 各 diff / unresolved** が自然に再取得・反映されるようにする。

## スコープ（やる）

1. `GET /api/meetings/{meetingId}/csv-import/resolutions` — 最新 import の resolutions 一覧。
2. `DELETE /api/meetings/{meetingId}/csv-import/resolutions/{resolutionId}` — レコード削除のみ（マスタ非削除）。
3. `PUT /api/meetings/{meetingId}/csv-import/resolutions/{resolutionId}` — 同一 `resolution_type` 内で `resolved_id` / `action_type` 再マップ（`source_value` / `resolution_type` 不変）。
4. `MeetingCsvMemberResolver` に **同名メタ**（`exact_name_match_count`, `duplicate_name_warning`, `duplicate_candidates`）を返す API（`resolveExistingWithMeta`）。既存 `resolveExistingForCsvName` はそのラッパー。
5. `MeetingCsvUnresolvedSummaryService` / diff preview 各種 / `preview`（CSV行）/ `unresolved-suggestions`（member）に警告フィールドを付与。
6. `MeetingsList.jsx`：「解決済みを確認」ダイアログ、解除・再マップ、同名 Alert、再取得の強化。

## スコープ外（やらない）

- Member / Category / Role マスタ削除、resolution 履歴テーブル、`executed_by` 本格連携、異体字辞書、Role 解決順変更、PDF フロー。

## 変更対象ファイル（予定）

- `www/app/Services/Religo/MeetingCsvMemberResolver.php`
- `www/app/Services/Religo/MeetingCsvUnresolvedSummaryService.php`
- `www/app/Services/Religo/MeetingCsvDiffPreviewService.php`
- `www/app/Services/Religo/MeetingCsvMemberDiffPreviewService.php`
- `www/app/Services/Religo/MeetingCsvRoleDiffPreviewService.php`
- `www/app/Http/Controllers/Religo/MeetingCsvImportController.php`
- `www/routes/api.php`
- `www/resources/js/admin/pages/MeetingsList.jsx`
- `www/tests/Feature/Religo/MeetingCsvImportControllerTest.php`
- `www/tests/Unit/Religo/MeetingCsvMemberResolverTest.php`
- 本 PLAN / WORKLOG / REPORT、`docs/process/PHASE_REGISTRY.md`、`docs/INDEX.md`、`docs/dragonfly_progress.md`、`docs/SSOT/MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS.md`（実装メモ）

## resolution 管理方針

- 一覧・PUT・DELETE は **常にその Meeting の最新 `MeetingCsvImport`** に紐づく resolutions のみ。旧 import の行は **404**（誤操作防止）。
- PUT は型ごとにマスタ存在検証（member / category / role）。存在しない ID は 422。
- マスタ削除は行わない。解除後は resolver 順に戻る（名前一致 or 未解決）。

## 同名警告方針

- **resolution で解決済み**の場合は警告なし（明示的な紐づけ）。
- **名前一致のみ**かつ DB 上 `name` の **完全一致が 2 件以上**のとき `duplicate_name_warning: true`。自動停止はしない。
- `duplicate_candidates` は最大 15 件（id / name）。

## UI 方針

- 「解決済みを確認」→ テーブル（type / source / resolved / action / 日時）＋ 解除 / 再マップ。
- 再マップは既存の検索ダイアログを流用し、確定時は **PUT**。
- unresolved の member **解決済み**行で同名警告を Alert / Chip 表示。
- preview / diff 表で `duplicate_name_warning` を表示。
- `refreshCsvAfterResolution`: CSV あり時は **ロード済みパネル + 未解決/管理ダイアログ開放時**に再取得し、表示が古くならないようにする。

## テスト観点

- 一覧 / 削除 / 再マップの成功、Meeting / import / resolution 不在 404、型不整合 422。
- 削除後 unresolved / preview が期待どおり変化。
- 再マップ後 diff で `resolved_id` が反映。
- 同名 2 件時に warning 系フィールドが付く。
- 既存 M7–M8.5 テストの回帰。

## DoD

- [x] resolution 一覧・解除・再マップが API / UI から利用できる。
- [x] 同名警告が API / UI で確認できる。
- [x] 変更後に preview / diff / unresolved が整合する。
- [x] `php artisan test` / `npm run build` が通る。
- [x] PLAN / WORKLOG / REPORT / REGISTRY / INDEX / progress / SSOT メモ更新済み。

# Phase M7-M5（ユーザー表記: M5）: Role History の確定反映 — PLAN

**Phase ID:** M7-M5  
**種別:** implement  
**Related SSOT:** MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS.md, PHASE_MEETINGS_PARTICIPANTS_ROLE_DIFF_M4_REPORT.md, PHASE_MEETINGS_PARTICIPANTS_MEMBER_DIFF_M3_REPORT.md, DATA_MODEL.md

**モック比較:** Meetings Drawer 内の既存 CSV ブロック拡張。個別の MOCK_UI_VERIFICATION 対象外（既存パターンに準拠）。

---

## 背景

- M7-M4 で CSV 役職と `Member::currentRole()` の差分を **表示のみ** できるようになった。
- 毎週 CLI 的に「常に閉じて新規」すると同じ役職でも履歴が細切れになるため、**同一名の継続は触らず**、候補だけを人が確認してから反映するフローが必要。

## 目的

- M4 の分類（changed / csv_only / current_only / unchanged / unresolved）に沿い、**確認後に member_roles のみ** を更新する API と UI を追加する。
- `changed` / `csv_only` は **roles マスタに解決できる行のみ** 反映。`current_only` は現在の open 行を **基準日で終了**。
- participants / members / PDF / roles 自動作成とは切り分ける。

## スコープ

**やること**

1. `ApplyMeetingCsvRoleDiffService`: `MeetingCsvRoleDiffPreviewService::roleDiffPreview` の結果を利用し、トランザクション内で member_roles を close / create。
2. `POST /api/meetings/{meetingId}/csv-import/role-apply` と件数レスポンス。
3. Drawer に「Role History に反映」・確認ダイアログ・成功後 `role-diff-preview` 再取得。

**やらないこと**

- roles の自動作成、未解決役職の推測、participants / members 更新、PDF、rollback、監査ログ別テーブル、過去履歴の補正 UI、基準日のユーザー指定（別 Phase）。

## 変更対象ファイル

- www/app/Services/Religo/ApplyMeetingCsvRoleDiffService.php（新規）
- www/app/Http/Controllers/Religo/MeetingCsvImportController.php（`roleApply`）
- www/routes/api.php
- www/resources/js/admin/pages/MeetingsList.jsx
- www/tests/Feature/Religo/MeetingCsvImportControllerTest.php
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_ROLE_APPLY_M5_*.md
- docs/process/PHASE_REGISTRY.md、docs/INDEX.md、docs/dragonfly_progress.md
- docs/SSOT/MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS.md（実装メモ）

## Role apply 方針

- **反映対象:** `changed_role` かつ `role_master_resolved`、`csv_role_only` かつ `role_master_resolved`、`current_role_only`（全件）。
- **反映しない:** `unchanged`、`unresolved_member`、`role_master_resolved === false` の changed / csv_only。
- **changed / csv_only:** open な現在行（`term_end` null かつ `term_start <= 基準日`、最大 `term_start`）を `term_end = 基準日` で閉じ、新行を `term_start = 基準日`, `term_end = null` で作成（csv_only で open が無い場合は閉じ処理は no-op）。
- **current_only:** 上記 open 行があれば同様に `term_end = 基準日` のみ（新規行なし）。

## 基準日方針

- **今回:** `now()->toDateString()`（アプリタイムゾーンの「今日」）。CSV 反映日・ユーザー指定は行わない。拡張は別 Phase。

## unresolved role の扱い

- プレビュー上は件数・一覧に残す。apply ではスキップし `skipped_unresolved_role_count` で返す。
- 適用可能行が 0 件のときは **422**（`反映対象の Role History 差分がありません。`）。

## UI 方針

- `hasCsvRoleApplyTarget`: 解決済み changed / csv_only が1件以上、または `current_role_only` が1件以上。
- 確認ダイアログで終了・開始・CSV 無し時の終了・同一継続しないこと・未登録役職はスキップを明示。
- 成功後 notify、`onDetailRefresh`、role-diff-preview 再取得。

## テスト観点

- changed / csv_only / current_only の DB 結果（term_end / 新規行）。
- 同一継続のみ → 422。
- 未解決役職スキップ + current_only 適用の併存。
- 未解決メンバーのみ / 未解決役職のみ → 422。
- 404（CSV なし）、members / participants 非更新。

## DoD

- [x] Role History を確定反映できる（member_roles のみ）。
- [x] 同一役職継続は apply 対象外（プレビュー段階で既に除外済み、422 でガード）。
- [x] changed / csv_only / current_only を仕様どおり処理。
- [x] 未解決 role は反映しない（件数返却）。
- [x] `php artisan test` / `npm run build` 成功。
- [x] PLAN / WORKLOG / REPORT、REGISTRY / INDEX / progress / SSOT メモ。

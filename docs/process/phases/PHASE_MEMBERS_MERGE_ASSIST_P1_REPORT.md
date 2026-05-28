# PHASE MEMBERS-MERGE-ASSIST-P1 — REPORT

## Phase 番号

**MEMBERS-MERGE-ASSIST-P1**

## 方針

- **手動・管理者向け**（トークン必須）。自動マージ・推測による同一人物判定なし。
- **プレビュー API** で件数・ブロック理由を返し、**実行 API** は確認フレーズ `MERGE {merge} INTO {canonical}` が一致する場合のみ。
- **同一例会に両方 `participants` がある場合は実行不可**（手動で participant を整理してから）。

## 変更ファイル（主要）

| 種別 | パス |
|------|------|
| Service | `www/app/Services/Religo/MemberMergeService.php` |
| Controller | `www/app/Http/Controllers/Religo/MemberMergeController.php` |
| Middleware | `www/app/Http/Middleware/VerifyReligoMemberMergeToken.php` |
| Routes | `www/routes/api.php`（`POST /api/admin/member-merge/preview` · `execute`） |
| Config | `www/config/religo.php` · `www/.env.example` |
| Test | `www/tests/Feature/Religo/MemberMergeTest.php` |
| UI | `www/resources/js/admin/pages/MemberMerge.jsx` · `app.jsx` · `ReligoMenu.jsx` · `ReligoLayout.jsx` |
| Bootstrap | `www/bootstrap/app.php`（middleware alias） |
| SSOT | `docs/SSOT/MEMBERS_DEDUPLICATION_RUNBOOK.md` §7.1 · `MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md` §3.4 |

## 付け替え対象（`merge_id` → `canonical_id`）

実行時に更新または削除処理の対象となるもの（`merge` メンバー行は最後に **DELETE**）。

| 領域 | テーブル / 内容 |
|------|------------------|
| マスタ | `members.introducer_member_id` / `attendant_member_id`（他行が merge を指す場合） |
| 例会 | `participants.member_id` / `introducer_member_id` / `attendant_member_id` |
| 関係 | `contact_memos`（owner / target） |
| | `dragonfly_contact_events`（owner / target） |
| | `dragonfly_contact_flags`（owner / target・**一意衝突時は行削除**） |
| 1to1 | `one_to_ones`（owner / target） |
| 紹介 | `introductions`（owner / from / to） |
| 役職 | `member_roles.member_id` |
| CSV | `meeting_csv_import_resolutions`（`resolution_type = member` かつ `resolved_id = merge`） |
| ユーザー | `users.owner_member_id` |
| 監査 | `bo_assignment_audit_logs.actor_owner_member_id` |
| ログ | `meeting_csv_apply_logs.executed_by_member_id` |

**明示的に未実装（別課題）:** 参加者 PDF import の `meeting_participant_imports` 内 **JSON candidates の `matched_member_id`**（スキーマ都合で本 Phase では触れず）。

## テスト結果

- `php artisan test` — **356 passed**（`MemberMergeTest` 4 ケース含む）
- `npm run build` — 成功

## リスク

- **不可逆:** `merge` の `members` 行は削除。バックアップなしの本番実行は禁止推奨。
- **contact_flags:** 一意衝突時に **行削除**しうる（フラグ内容が失われる）。
- **監査ログ:** `actor_owner_member_id` 付け替えで、過去ログの「誰が actor だったか」の解釈が変わる場合がある。
- **トークン流出:** ヘッダ 1 本で実行可能。ローテーション・HTTPS 前提。
- **誤マージ:** ID 入れ間違いは防げない（人手確認のみ）。

## 残課題

- 重複 **候補一覧**（読み取りのみ）API
- PDF candidates JSON 内の member 参照更新
- ロールベース認可への移行

## Merge Evidence

- ローカル実施。merge / push はリポジトリ運用に従うこと。

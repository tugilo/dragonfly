# PHASE05 Religo メモ追加API / 1 to 1 登録API — WORKLOG

**Phase:** 関係ログ作成の入口  
**作成日:** 2026-03-04

---

## Step 1: ブランチ・PLAN

- develop から `feature/relationship-log-create-v1` を作成。
- PHASE05_RELIGO_RELATIONSHIP_LOG_CREATE_PLAN.md を作成。

## Step 2: 実装

- **Models:** ContactMemo, OneToOne を新規作成（table: contact_memos, one_to_ones）。
- **StoreContactMemoRequest:** owner_member_id, target_member_id 必須。memo_type=meeting 時 meeting_id 必須、memo_type=one_to_one 時 one_to_one_id 必須。workspace_id 任意。body 1..2000。
- **StoreOneToOneRequest:** workspace_id 必須。status: planned/completed/canceled。scheduled_at/started_at/ended_at/notes 任意。
- **ContactMemoService / ContactMemoController:** store() で作成し 201 で返却。
- **OneToOneService / OneToOneController:** store() で作成し 201 で返却。
- **routes/api.php:** POST /api/contact-memos, POST /api/one-to-ones を追加。

## Step 3: テスト

- RelationshipLogCreateTest: 8 ケース（other 作成、one_to_one で one_to_one_id 無し 422、meeting で meeting_id 無し 422、workspace_id NULL 許容、owner 不正 422、one-to-one workspace_id 無し 422、status 不正 422、one-to-one 作成 201）。すべて green。

## Step 4: ドキュメント

- WORKLOG / REPORT 作成。INDEX に Phase05 を追記。

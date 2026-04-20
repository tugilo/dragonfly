# PHASE MEMBERS-MERGE-ASSIST-P1 — PLAN

## Phase ID

**MEMBERS-MERGE-ASSIST-P1**

## Type

implement

## Related SSOT

- **SPEC-007:** [MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md](../../SSOT/MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md)
- **SPEC-008:** [MEMBERS_DEDUPLICATION_RUNBOOK.md](../../SSOT/MEMBERS_DEDUPLICATION_RUNBOOK.md)

## Scope

- `www/app/Services/Religo/MemberMergeService.php`（新規）
- `www/app/Http/Controllers/Religo/MemberMergeController.php`（新規）
- `www/app/Http/Middleware/VerifyReligoMemberMergeToken.php`（新規）
- `www/routes/api.php` / `www/bootstrap/app.php`
- `www/config/religo.php` / `www/.env.example`
- `www/tests/Feature/Religo/MemberMergeTest.php`（新規）
- `www/resources/js/admin/pages/MemberMerge.jsx`（新規）
- `www/resources/js/admin/app.jsx` / `ReligoLayout.jsx` / `ReligoMenu.jsx`
- `docs/SSOT/MEMBERS_DEDUPLICATION_RUNBOOK.md` / `MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md` §3.4
- `docs/process/phases/*` · `docs/INDEX.md` · `docs/dragonfly_progress.md` · `docs/process/PHASE_REGISTRY.md`

## Goal

管理者が **canonical `member_id` に統合する `merge` 側を削除**するまで、関連 FK をトランザクションで付け替える。**自動同一人物判定なし**。**プレビュー必須・確認フレーズ必須**。トークンで API を非公開化。

## DoD

- 付け替え対象がコードとドキュメントで一致
- 同一例会に両 participants がある場合は **ブロック**
- Feature テスト 4 ケース以上
- `php artisan test` 緑 · `npm run build` 成功
- REPORT にリスク記載

## Out of scope

- PDF candidates JSON の `matched_member_id` 更新
- 重複候補の自動検出一覧

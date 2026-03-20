# PHASE: MEMBER-SUMMARY-WORKSPACE-NULL-P1 — PLAN

## 種別

implement（Query + SSOT + テスト）

## Related SSOT

- `docs/SSOT/DATA_MODEL.md` §5.1
- `docs/SSOT/WORKSPACE_RESOLUTION_POLICY.md`
- `docs/SSOT/DASHBOARD_DATA_SSOT.md` §0（Dashboard stale は対象外・文脈のみ）

## 目的

`MemberSummaryQuery::getSummaryLiteBatch(..., $workspaceId)` で **`$workspaceId` が非 null** のとき、`contact_memos` / `one_to_ones` / `dragonfly_contact_flags` の workspace 条件を **DATA_MODEL** と揃え、**`(workspace_id = :id OR workspace_id IS NULL)`** とする（単一チャプター運用の legacy 行を現在所属チャプターに含める）。

## 採用案

- **案A（DATA_MODEL 既存）:** `workspace_id IS NULL` は「デフォルト workspace」相当 → OR 許容。
- **Dashboard stale:** 方針D **変更しない**（`getSummaryLiteBatch(..., null)` のまま）。

## 見送り条件

- 回帰が大きい場合は設計のみ → **実装で最小差分 + Feature テストで検証済みのため実施**。

## DoD

- [ ] SSOT に `MemberSummaryQuery` の挙動が明記されている
- [ ] `applyWorkspaceScopeForSummary` 相当で 3 テーブル統一
- [ ] `$workspaceId === null` のとき従来どおり（workspace 列で絞らない）
- [ ] テスト追加
- [ ] `php artisan test` / `npm run build` 通過
- [ ] develop merge + REPORT Merge Evidence + push

## モック比較

（本 Phase は API クエリ層のため MOCK_UI_VERIFICATION 対象外）

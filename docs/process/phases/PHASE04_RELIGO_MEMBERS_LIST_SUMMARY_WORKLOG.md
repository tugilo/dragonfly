# PHASE04 Religo Members一覧に summary 統合 — WORKLOG

**Phase:** Members一覧に summary-lite 統合  
**作成日:** 2026-03-04

---

## Step 1: ブランチ・PLAN

- develop から `feature/members-list-summary-v1` を作成。
- PHASE04_RELIGO_MEMBERS_LIST_SUMMARY_PLAN.md を作成。A案（一覧APIに summary-lite 同梱）を採用。

## Step 2: 実装

- **MemberSummaryQuery:** getSummaryLiteBatch(ownerId, targetIds, workspaceId) を実装。same_room_count / one_to_one_count / last_memo（最新1件・body短縮80文字）/ last_contact_at / flags をバッチ取得。N+1 回避。
- **DragonFlyMemberController:** index() を拡張。Query params: owner_member_id, workspace_id, with_summary。with_summary かつ owner_member_id ありの場合に getSummaryLiteBatch を呼び、各 member に summary_lite を付与して返却。
- **DragonFlyBoard.jsx:** メンバー取得を `?owner_member_id={owner}&with_summary=1` に変更。Autocomplete の renderOption で summary_lite を表示（同室回数・1on1回数・最終接触日・last_memo 短縮・interested/want_1on1）。last_contact_at が null の場合は「未接触」表示。

## Step 3: テスト・確認

- DragonFlyMembersListSummaryTest: with_summary なしなら summary_lite なし、owner_member_id + with_summary=1 なら全要素に summary_lite あり（キー・型チェック）、with_summary のみなら summary_lite なし。3 件すべて green。
- UI: 一覧（Autocomplete ドロップダウン）で summary_lite が表示されることを手動確認。WORKLOG 上は「手動確認 OK」とする。

## Step 4: ドキュメント

- WORKLOG / REPORT 作成。INDEX に Phase04 を追記。

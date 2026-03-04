# PHASE07 Religo DragonFlyBoard から 1 to 1 登録 — WORKLOG

**Phase:** DragonFlyBoard 1 to 1 登録 UI  
**作成日:** 2026-03-04

---

## Step 1: ブランチ・PLAN

- develop から `feature/phase07-board-add-1to1-v1` を作成。
- PHASE07_RELIGO_BOARD_ADD_ONE_TO_ONE_PLAN.md を作成（UI 項目・workspace_id 取得方法・登録後更新方針・DoD）。

## Step 2: 実装（UI）

- **DragonFlyBoard.jsx:**
  - 「1 to 1 登録」ボタンを右ペインに追加（メモ追加と同様）。
  - モーダル: workspace_id（必須・数値・初期値 1）、status（planned/completed/canceled）、scheduled_at/started_at/ended_at（datetime-local）、meeting_id（任意）、notes。
  - POST /api/one-to-ones を呼び出し。成功後 refetchMembers() + loadSummary() で一覧・サマリーを更新。
  - 日時は datetime-local から "Y-m-d H:i:s" 形式に変換して送信。

## Step 3: 手動確認（WORKLOG に記録）

- **planned を登録 → one_to_one_count 更新:** 手動で確認し REPORT に記載。
- **canceled を登録 → count は増えるが last_* は更新されない:** 規約どおりであることを確認。

## Step 4: ドキュメント

- WORKLOG / REPORT 作成。INDEX と dragonfly_progress を更新。

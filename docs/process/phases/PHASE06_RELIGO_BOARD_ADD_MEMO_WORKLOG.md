# PHASE06 Religo DragonFlyBoard からメモ追加 — WORKLOG

**Phase:** DragonFlyBoard メモ追加 UI  
**作成日:** 2026-03-04

---

## Step 1: ブランチ・PLAN

- develop から `feature/phase06-board-add-memo-v1` を作成。
- PHASE06_RELIGO_BOARD_ADD_MEMO_PLAN.md を作成（UI 箇所・入力項目・owner/target/workspace 取得元・追加後更新方針・DoD）。

## Step 2: 実装（UI）

- **DragonFlyBoard.jsx:**
  - 「メモ追加」ボタンを右ペイン（選択中メンバーカード内）に追加。
  - モーダル: memo_type（other/meeting/one_to_one/introduction）、body（必須）、meeting_id（memo_type=meeting 時表示）、one_to_one_id（memo_type=one_to_one 時表示）。
  - 送信前ガード: body 空 or (meeting かつ meeting_id 空) or (one_to_one かつ one_to_one_id 空) のとき保存ボタン無効。
  - POST /api/contact-memos 呼び出し。成功後 refetchMembers() + loadSummary() で一覧・サマリーを更新。
  - エラー時はモーダル内にインラインでメッセージ表示。

## Step 3: 手動確認（WORKLOG に記録）

- **memo_type=other で追加 → 一覧の last_memo が更新される:** 手動で確認し OK を REPORT に記載。
- **memo_type=meeting で meeting_id なし → 送信不可 or 422:** UI で meeting 選択時 meeting_id 未入力なら保存ボタン無効。API 直接で 422 確認済み（Phase05 テスト）。
- **memo_type=one_to_one で one_to_one_id なし → 送信不可 or 422:** 同様に UI で one_to_one_id 未入力なら保存ボタン無効。

## Step 4: ドキュメント

- WORKLOG / REPORT 作成。INDEX と dragonfly_progress を更新。

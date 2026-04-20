# PHASE CONN-BO-UX-GUARDS-P1 — WORKLOG

## 判断

- **単一の真実源:** 左ペインと同じ `GET /api/dragonfly/members?meeting_id=` の行に **`bo_assignable`** / **`participant_type`** があるため、クライアント側の「割当可能か」は **`membersById`（Map）+ `getBoAssignBlockReason`** に集約した。API の「欠席・proxy」は一覧に出ない／`bo_assignable false` で表現され、UI と矛盾しにくい。
- **保存前の防ぎ:** `collectBoSaveValidationErrors` で rooms ペイロード全体を検証。stale な `member_id`（一覧にない）や代理の ID がローカル state に残っていても **PUT 前に止める**。
- **422 表示:** Laravel の `errors.rooms` 本文はそのまま活かし、先頭に **「BO割当を保存できませんでした。」** を付けて文脈を明示。
- **BO1→BO2:** コピーは運用上のショートカット。BO1 に不正 ID が混入していても **コピー先には持ち込まない**（除外数を Snackbar で通知）。

## 実装メモ

- 新規 `boAssignmentGuards.js` は純関数のみ。React に依存しない。
- `toggleRoundMember` 内で `setSnackbarMessage` を呼ぶのは、ブロック時のみ。状態更新は `return prev` でノーオペ。
- `MenuItem` の「に追加」は `bo_assignable === false` のとき **disabled**（左ペインからは通常開かないが二重化）。

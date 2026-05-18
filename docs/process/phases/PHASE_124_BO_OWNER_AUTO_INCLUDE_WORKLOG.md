# Phase 124 WORKLOG — BO Owner 自動 BO1 追加

## 判断

- **なぜ BO1 か:** 2 ルーム固定の主線 API で「最低限同席の箱」を一つ決める必要がある。運用上「最初の BO」を BO1 とみなし、未所属時のみ BO1 に追加。既に BO2 のみに明示配置されている場合は **移動しない**（現場で第2ブロックのみにいた記録を壊さない）。
- **サーバ側でマージ:** Connections が必ず `owner_member_id` を送る前提でも、API を直接叩くクライアントの後方互換のため **省略時は何もしない**。監査ログはマージ後ペイロードで記録し、保存結果と一致させる。
- **フロント:** `ReligoOwnerContext` の `ownerMemberId` を保存ペイロードに載せる。Owner 未選択時はキー自体を送らない（従来どおり）。

## 実装メモ

- `MeetingBreakoutService::mergeEnsureMemberInBo1IfAbsent`
- `UpdateMeetingBreakoutsRequest` に `owner_member_id` ルール追加
- `DragonFlyBoard.jsx` の `saveRounds` で `owner_member_id` をマージ

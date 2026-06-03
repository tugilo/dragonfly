# WORKLOG: Phase 185 — ONETOONES-CANCEL-API-P1

## 判断

- **cancel 専用メソッド:** `OneToOneService::cancel` で `status`・理由列・`canceled_at` を一括更新（POST の意図をコードで固定）。
- **PATCH 拒否:** `UpdateOneToOneRequest` の `status` から `canceled` を除外（SSOT: POST cancel のみ）。
- **422 条件:** `status !== planned` は Controller で 422 + 明確メッセージ（validation 前）。
- **formatRecord:** UI Phase 186 向けに `cancel_reason` / `cancel_remark` / `canceled_at` を index/show/cancel 応答に含める。

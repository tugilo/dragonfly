# PHASE_246_sonae_training_response WORKLOG

**作成日時:** 2026-06-24 21:19 JST  
**最終更新日時:** 2026-06-24 21:19 JST

---

## 訓練発報フロー

- `SonaeTrainingDispatchService` で training_event → alert_notification → notification_targets をトランザクション作成。
- 各 target に `SonaeResponseTokenService` で SHA-256 ハッシュ保存 + 平文 URL を LINE Push 本文に埋め込み。
- LINE 設定未完了時は RuntimeException → API 422。Push 失敗は target 単位で `send_status=failed` 記録。

## 回答・集計

- 公開ルート `/sonae/respond/{token}` は Sanctum 不要。トークンは DB に hash のみ保存。
- `SonaeSafetyResponseService` で 3 軸（安否・活動・例会参加）を検証し `responded_at` を更新。
- `SonaeAggregationService` で harmful / activity_difficult / meeting_cannot / response_rate を算出。訓練一覧は executed_at desc + 前回訓練との delta。

## テスト修正判断

1. **422 FK 違反:** `created_by_user_id` に Religo `users.id` を渡していたが FK は `sonae_users`。PoC では null に変更。
2. **集計 JSON パス:** レスポンスは `data.summary.*` 構造。テストの assert パスを修正。
3. **訓練一覧順:** 最新訓練が index 0。前回比較テストの期待順を desc 順に合わせた。

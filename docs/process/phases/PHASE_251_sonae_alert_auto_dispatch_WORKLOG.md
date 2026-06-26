# PHASE_251_sonae_alert_auto_dispatch WORKLOG

**作成日時:** 2026-06-24 21:53 JST  
**最終更新日時:** 2026-06-24 21:53 JST

---

## 判断記録

### マッチロジック

`SonaeAlertMatchService` が alert type・地域（prefecture/city）・severity_rank と chapter の `sonae_chapter_alert_settings` を突合。OFF の種別はスキップ。

### 自動発報タイミング

`SonaeJmaFetchService::run()` の ingest 成功後、`SonaeAlertAutoDispatchService::dispatchEvents()` で新規 event のみ処理。訓練 API とは別経路だが同一回答 UI・集計を利用（SPEC-017 §6.4）。

### 通知対象

既存 `SonaeNotificationTargetResolver`（LINE 紐付け済みのみ）を再利用。未紐付けは通知対象外。

### UI

`/admin#/sonae/jma` — 取得設定・手動取得・ログ一覧。  
`/admin#/sonae/alert-settings` — 種別別閾値・地域・ON/OFF。

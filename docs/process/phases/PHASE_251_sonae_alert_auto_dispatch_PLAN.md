# PHASE_251_sonae_alert_auto_dispatch PLAN

**作成日時:** 2026-06-24 21:53 JST  
**最終更新日時:** 2026-06-24 21:53 JST  
**Phase Type:** implement  
**Branch:** feature/phase249-251-sonae-jma-l2  
**Related SSOT:** SPEC-017 §9.6 発報条件、§5.5 通知対象、SONAE_IMPLEMENTATION_PLAN Phase 251  
**Status:** completed

---

## 目的

チャプター別発報条件に基づき JMA イベントをマッチし、条件を満たす場合に安否確認通知を自動発報する。管理 UI で発報条件と JMA 設定を操作可能にする。

---

## Scope

| 対象 | 内容 |
|------|------|
| Service | `SonaeAlertMatchService`、`SonaeAlertAutoDispatchService` |
| API | `GET/PUT /api/sonae/chapters/{chapter}/alert-settings`（`sonae.chapter`） |
| Pipeline | ingest 直後に auto dispatch |
| React | `SonaeJmaPage`、`SonaeAlertSettingsPage`、メニュー・ルート |
| Tests | `SonaeAlertAutoDispatchTest` |

---

## DoD

- [x] 発報条件 API（種別・地域・閾値・ON/OFF）
- [x] マッチしたイベントで notification 作成（訓練と別履歴）
- [x] 手動 fetch 後に自動発報が走る
- [x] JMA 設定・発報条件 UI
- [x] `npm run build` 成功
- [x] `php artisan test` — 536 passed

---

## モック比較

モック比較: `docs/SSOT/MOCK_UI_VERIFICATION.md` に従う。SONAE JMA/発報条件はモック未収録。Gap は Phase 251 REPORT / FIT_AND_GAP §SONAE 参照。

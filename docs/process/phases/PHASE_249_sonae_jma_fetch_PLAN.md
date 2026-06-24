# PHASE_249_sonae_jma_fetch PLAN

**作成日時:** 2026-06-24 21:53 JST  
**最終更新日時:** 2026-06-24 21:53 JST  
**Phase Type:** implement  
**Branch:** feature/phase249-251-sonae-jma-l2  
**Related SSOT:** SPEC-017 §9 JMA 連携、SONAE_IMPLEMENTATION_PLAN Phase 249  
**Status:** completed

---

## 目的

PoC 向け JMA 取得基盤を実装する。本番 HTTP ではなく fixture JSON フィードを読み込み、取得設定・手動取得・ログ API と Artisan コマンドを提供する。

---

## Scope

| 対象 | 内容 |
|------|------|
| Provider | `SonaeJmaFeedProviderInterface`、`SonaeJmaFixtureFeedProvider` |
| Service | `SonaeJmaFetchService`（取得・設定・ログ） |
| API | `GET/PUT /api/sonae/jma/settings`、`POST /api/sonae/jma/fetch`、`GET /api/sonae/jma/logs` |
| Artisan | `sonae:jma-fetch` |
| Fixture | `storage/app/sonae/jma/fixtures/*.json` |
| Tests | `SonaeJmaFetchTest` |

---

## DoD

- [x] fixture フィードから entries を読み込める
- [x] 手動取得 API でログが success になる
- [x] 設定 API（有効化・間隔）が動作する
- [x] `sonae:jma-fetch` が実行できる
- [x] `php artisan test` — SonaeJmaFetchTest 含む全件 pass

---

## モック比較

対象外（API 基盤）。UI は Phase 251 で JMA 画面を追加。

---

## Phase 250 以降に委譲

- Normalizer + `SonaeAlertEvent` ingest
- 発報条件マッチ + 自動発報

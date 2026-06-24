# PHASE_250_sonae_jma_ingest PLAN

**作成日時:** 2026-06-24 21:53 JST  
**最終更新日時:** 2026-06-24 21:53 JST  
**Phase Type:** implement  
**Branch:** feature/phase249-251-sonae-jma-l2  
**Related SSOT:** SPEC-017 §9 JMAXML 9種、SONAE_IMPLEMENTATION_PLAN Phase 250  
**Status:** completed

---

## 目的

JMA フィード entry を 9 種 Normalizer で正規化し、`sonae_alert_events` / `sonae_alert_event_areas` に ingest する。`source_event_key` で重複スキップ。

---

## Scope

| 対象 | 内容 |
|------|------|
| Registry | `SonaeJmaNormalizerRegistry` |
| Normalizers | earthquake, tsunami, heavy_rain, flood, landslide, typhoon, heavy_snow, volcano, nankai_trough |
| Service | `SonaeJmaIngestService` |
| Integration | `SonaeJmaFetchService::run()` で ingest 呼び出し・ログカウンタ更新 |
| Tests | `SonaeJmaIngestTest` |

---

## DoD

- [x] 9 種 type の Normalizer が registry に登録される
- [x] ingest で `SonaeAlertEvent` + areas が作成される
- [x] 同一 `source_event_key` は skipped_duplicate になる
- [x] fetch パイプラインに ingest が組み込まれる
- [x] `SonaeJmaIngestTest` pass

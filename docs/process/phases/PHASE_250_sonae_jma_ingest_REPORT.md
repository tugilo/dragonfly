# PHASE_250_sonae_jma_ingest REPORT

**作成日時:** 2026-06-24 21:53 JST  
**最終更新日時:** 2026-06-24 21:53 JST  
**Phase Type:** implement  
**Related SSOT:** SPEC-017 §9 JMAXML 9種  
**Status:** completed

---

## 概要

SONAE Phase 250 — JMA Normalizer + Ingest。9 種 Normalizer、`SonaeAlertEvent` への ingest、fetch パイプライン統合。

---

## テスト結果

```
php artisan test — 536 passed（SonaeJmaIngestTest 含む）
```

---

## Merge Evidence

Phase 249 と同一 merge（L2 パイプライン一括取り込み）。詳細は PHASE_249 REPORT 参照。
